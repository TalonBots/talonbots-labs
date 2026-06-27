# Episode 00 — Bootstrap
# Creates the one (cheap, ~pennies/mo) always-on piece of infra these demos need:
# a storage account + container to hold remote Terraform state for every other
# episode. This is the only thing you DON'T destroy after filming.

resource "random_string" "sa_suffix" {
  length  = 6
  upper   = false
  special = false
}

module "rg" {
  source   = "../../modules/resource-group"
  name     = var.state_rg_name
  location = var.location
  tags = {
    purpose   = "remote-tfstate"
    ephemeral = "false" # keep this one
  }
}

resource "azurerm_storage_account" "state" {
  name                            = "${var.state_sa_prefix}${random_string.sa_suffix.result}"
  resource_group_name             = module.rg.name
  location                        = module.rg.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false

  blob_properties {
    versioning_enabled = true
  }

  tags = {
    project = "talonbots-labs"
    series  = "azure"
    purpose = "remote-tfstate"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.state.id
  container_access_type = "private"
}
