# Reusable resource group with standard demo tags. Every episode builds inside one
# of these so cost-guard.sh can find and nuke leftovers by tag.

resource "azurerm_resource_group" "this" {
  name     = var.name
  location = var.location

  tags = merge(
    {
      project   = "talonbots-labs"
      series    = "azure"
      managedby = "terraform"
      ephemeral = "true"
    },
    var.tags,
  )
}
