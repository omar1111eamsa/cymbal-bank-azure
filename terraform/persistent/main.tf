data "azurerm_resource_group" "persistent" {
  name = "rg-cymbal-bank-persistent"
}

output "resource_group_location" {
  description = "Proves the persistent identity can read its own resource group"
  value       = data.azurerm_resource_group.persistent.location
}