data "azurerm_client_config" "current" {}


resource "azurerm_key_vault" "kv" {
  name                       = "kv-cymbal-bank-os-frc"
  resource_group_name        = data.azurerm_resource_group.persistent.name
  location                   = data.azurerm_resource_group.persistent.location
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  rbac_authorization_enabled = true
  soft_delete_retention_days = 90
  purge_protection_enabled   = true
}