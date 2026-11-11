variable "telegram_bot_token" {
  description = <<-EOT
    Telegram bot token from @BotFather. Supply at runtime — never commit a real token.
    Recommended: export TF_VAR_telegram_bot_token=<token> before running terraform.
    Alternatively, create a gitignored terraform.tfvars with: telegram_bot_token = "<token>"
  EOT
  type        = string
  sensitive   = true
}

variable "acr_name_prefix" {
  description = "Prefix for the throwaway ACR (a random suffix is appended; must be lowercase alphanumeric, <=42 chars here)."
  type        = string
  default     = "acrtbot"

  validation {
    condition     = can(regex("^[a-z0-9]{2,42}$", var.acr_name_prefix))
    error_message = "acr_name_prefix must be 2-42 lowercase alphanumeric chars (an 8-char suffix is appended; ACR max is 50)."
  }
}

variable "image_tag" {
  description = "Tag for the bot image built into the ACR."
  type        = string
  default     = "latest"
}

variable "location" {
  description = "Azure region for this episode's resources."
  type        = string
  default     = "eastus"
}

variable "existing_resource_group" {
  description = "Name of a pre-created resource group to deploy into. Leave null to create a throwaway RG (needs subscription-scope rights). Set it when your service principal is scoped to a single RG."
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "Resource group name for this demo (only used when existing_resource_group is null)."
  type        = string
  default     = "rg-telegram-bot-demo"
}

variable "container_group_name" {
  description = "Name of the ACI container group."
  type        = string
  default     = "aci-telegram-bot"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,62}[a-z0-9]$", var.container_group_name))
    error_message = "container_group_name must be lowercase alphanumeric and hyphens, 3-64 chars, starting with a letter."
  }
}

variable "expires" {
  description = "ISO date tag for cost-guard sweep — set to today's date so leftovers are easy to spot."
  type        = string
  default     = "2099-01-01"
}
