resource "azurerm_resource_group" "rg" {
  for_each = local.layers
  name     = "rg-cymbal-bank-${each.key}"
  location = var.region
}

resource "azurerm_role_assignment" "role" {
  for_each             = local.layers
  scope                = azurerm_resource_group.rg[each.key].id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.hcp[each.key].object_id
}

resource "azurerm_role_assignment" "persistent_kv_secrets_officer" {
  role_definition_name = "Key Vault Secrets Officer"
  scope                = azurerm_resource_group.rg["persistent"].id
  principal_id         = azuread_service_principal.hcp["persistent"].object_id
}