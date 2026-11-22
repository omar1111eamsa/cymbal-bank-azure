# External Secrets Operator: reads the app secrets from Key Vault with workload identity.
# Lives in persistent (stable client ID across cluster rebuilds). The federated
# credential is in ephemeral: it trusts the cluster's OIDC issuer, which changes per cluster.
resource "azurerm_user_assigned_identity" "eso" {
  name                = "id-eso-cymbal-bank"
  resource_group_name = azurerm_resource_group.rg["persistent"].name
  location            = azurerm_resource_group.rg["persistent"].location
}

# Read-only on secret values, nothing else
resource "azurerm_role_assignment" "eso_kv_secrets_user" {
  scope                = azurerm_resource_group.rg["persistent"].id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.eso.principal_id
}

# Lets ephemeral add the federated credential, on this one identity only
resource "azurerm_role_assignment" "ephemeral_eso_identity_contributor" {
  scope                = azurerm_user_assigned_identity.eso.id
  role_definition_name = "Managed Identity Contributor"
  principal_id         = azuread_service_principal.hcp["ephemeral"].object_id
}
