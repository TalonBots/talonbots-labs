output "state_resource_group" {
  description = "Resource group holding the state backend."
  value       = module.rg.name
}

output "state_storage_account" {
  description = "Storage account name — plug this into later episodes' backend blocks."
  value       = azurerm_storage_account.state.name
}

output "state_container" {
  description = "Blob container for tfstate."
  value       = azurerm_storage_container.tfstate.name
}

output "backend_snippet" {
  description = "Paste this into a later episode's backend.tf, then `terraform init -migrate-state`."
  value       = <<-EOT
    terraform {
      backend "azurerm" {
        resource_group_name  = "${module.rg.name}"
        storage_account_name = "${azurerm_storage_account.state.name}"
        container_name       = "${azurerm_storage_container.tfstate.name}"
        key                  = "EPISODE-NAME.tfstate"
      }
    }
  EOT
}
