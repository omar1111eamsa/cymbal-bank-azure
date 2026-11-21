# One-time: adopt the identity an interrupted apply created. Delete after apply.
import {
  to = azurerm_user_assigned_identity.aks
  id = "/subscriptions/${var.subscription_id}/resourceGroups/rg-cymbal-bank-persistent/providers/Microsoft.ManagedIdentity/userAssignedIdentities/id-aks-cymbal-bank"
}

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

resource "azurerm_role_assignment" "ephemeral_identity_operator" {
  scope                = azurerm_user_assigned_identity.aks.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azuread_service_principal.hcp["ephemeral"].object_id
}

resource "azurerm_role_assignment" "aks_admin_me" {
  scope                = azurerm_resource_group.rg["ephemeral"].id
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id         = data.azuread_client_config.current.object_id
}