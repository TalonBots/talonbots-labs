variable "location" {
  description = "Azure region for the state backend."
  type        = string
  default     = "eastus"
}

variable "state_rg_name" {
  description = "Resource group that holds the remote-state storage account."
  type        = string
  default     = "rg-tfstate-demos"
}

variable "state_sa_prefix" {
  description = "Storage account name prefix (a random suffix is appended; must be globally unique, lowercase, <=18 chars here)."
  type        = string
  default     = "sttfstatedemos"

  validation {
    condition     = can(regex("^[a-z0-9]{3,18}$", var.state_sa_prefix))
    error_message = "state_sa_prefix must be 3-18 lowercase alphanumeric chars (6-char suffix is added, 24 max total)."
  }
}
