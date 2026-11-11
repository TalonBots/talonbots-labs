# Episode 01 — Telegram Bot on ACI (one-apply)
# A single `terraform apply` does the whole thing:
#   RG → ACR → `az acr build` the sample bot → ACI runs it (long-poll, no inbound).
# A single `terraform destroy` removes ALL of it — registry, image, container.
# Nothing is left billing after filming. That's the whole point.

# Resource group: by default this episode creates (and on destroy deletes) its own.
# Set existing_resource_group to deploy into a pre-created RG instead. Use that when
# your service principal is scoped to one RG rather than the whole subscription
# (least privilege): the RG then survives `terraform destroy`, only its contents go.
module "rg" {
  count    = var.existing_resource_group == null ? 1 : 0
  source   = "../../modules/resource-group"
  name     = var.resource_group_name
  location = var.location
  tags = {
    expires = var.expires
  }
}

data "azurerm_resource_group" "existing" {
  count = var.existing_resource_group == null ? 0 : 1
  name  = var.existing_resource_group
}

locals {
  rg_name     = var.existing_resource_group == null ? module.rg[0].name : data.azurerm_resource_group.existing[0].name
  rg_location = var.existing_resource_group == null ? module.rg[0].location : data.azurerm_resource_group.existing[0].location
}

# ACR names are global + alphanumeric only, so we append a random suffix.
resource "random_string" "acr_suffix" {
  length  = 8
  upper   = false
  special = false
}

resource "azurerm_container_registry" "acr" {
  name                = "${var.acr_name_prefix}${random_string.acr_suffix.result}"
  resource_group_name = local.rg_name
  location            = local.rg_location
  sku                 = "Basic"
  admin_enabled       = true # demo-simple auth for ACI to pull; fine for an ephemeral lab

  tags = local.tags
}

# Build sample-bot/ straight into the ACR with `az acr build` (server-side build,
# no local Docker needed). Re-runs whenever the bot source changes. Auth reuses the
# ARM_* env vars already exported by ../../scripts/load-azure-creds.sh.
resource "null_resource" "build" {
  triggers = {
    acr        = azurerm_container_registry.acr.id
    bot        = filesha256("${path.module}/sample-bot/bot.py")
    dockerfile = filesha256("${path.module}/sample-bot/Dockerfile")
    reqs       = filesha256("${path.module}/sample-bot/requirements.txt")
    tag        = var.image_tag
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOT
      set -euo pipefail
      # Ensure the az CLI is authenticated as the same service principal Terraform uses.
      az account show >/dev/null 2>&1 || az login --service-principal \
        -u "$ARM_CLIENT_ID" -p "$ARM_CLIENT_SECRET" --tenant "$ARM_TENANT_ID" >/dev/null
      az account set --subscription "$ARM_SUBSCRIPTION_ID"
      az acr build \
        --registry ${azurerm_container_registry.acr.name} \
        --image telegram-bot:${var.image_tag} \
        ${path.module}/sample-bot
    EOT
  }

  depends_on = [azurerm_container_registry.acr]
}

resource "azurerm_container_group" "bot" {
  name                = var.container_group_name
  location            = local.rg_location
  resource_group_name = local.rg_name
  os_type             = "Linux"
  restart_policy      = "OnFailure"

  # Long-polling only — the bot dials OUT to api.telegram.org.
  # No inbound connectivity required, so no public IP is allocated.
  ip_address_type = "None"

  image_registry_credential {
    server   = azurerm_container_registry.acr.login_server
    username = azurerm_container_registry.acr.admin_username
    password = azurerm_container_registry.acr.admin_password
  }

  container {
    name   = "telegram-bot"
    image  = "${azurerm_container_registry.acr.login_server}/telegram-bot:${var.image_tag}"
    cpu    = 0.5
    memory = 1.0

    secure_environment_variables = {
      TELEGRAM_BOT_TOKEN = var.telegram_bot_token
    }
  }

  tags = local.tags

  # ACI must not be created until the image actually exists in the registry.
  depends_on = [null_resource.build]
}

locals {
  tags = {
    project   = "talonbots-labs"
    series    = "azure"
    ephemeral = "true"
    expires   = var.expires
  }
}
