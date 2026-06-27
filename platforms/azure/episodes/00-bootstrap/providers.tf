terraform {
  required_version = ">= 1.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  # Episode 00 intentionally uses LOCAL state — it is the chicken that lays the
  # remote-state egg. Later episodes point their backend at the storage account
  # this episode creates. (See README.md for the migration snippet.)
}

provider "azurerm" {
  features {}

  # Auth comes from ARM_* env vars exported by scripts/load-azure-creds.sh.
  # Nothing sensitive is set here.
}
