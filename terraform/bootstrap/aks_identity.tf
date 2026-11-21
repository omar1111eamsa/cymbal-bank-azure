resource "azurerm_user_assigned_identity" "aks" {
  name                = "id-aks-cymbal-bank"
  resource_group_name = azurerm_resource_group.rg["persistent"].name
  location            = azurerm_resource_group.rg["persistent"].location
}

resource "azurerm_role_assignment" "aks_network" {
  scope                = azurerm_resource_group.rg["ephemeral"].id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}