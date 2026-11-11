output "resource_group" {
  description = "Resource group holding this demo."
  value       = local.rg_name
}

output "acr_login_server" {
  description = "The throwaway ACR the bot image was built into."
  value       = azurerm_container_registry.acr.login_server
}

output "container_group" {
  description = "ACI container group name."
  value       = azurerm_container_group.bot.name
}

output "next_steps" {
  description = "What to do now."
  value       = <<-EOT
    Bot is running. Watch live logs:
      az container logs --resource-group ${local.rg_name} --name ${azurerm_container_group.bot.name} --follow

    Message your bot on Telegram: /start, /ping, or any text (it echoes).

    When you're done recording — one command tears down ACR, image, and container:
      terraform destroy -auto-approve
    (Or Ctrl-C if you launched via ../../../shared/apply-record-destroy.sh — the trap fires.)
  EOT
}
