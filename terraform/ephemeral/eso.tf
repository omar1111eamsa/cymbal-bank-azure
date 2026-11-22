# External Secrets Operator: trust this cluster's ServiceAccount tokens for the ESO identity.
# Here (not bootstrap) because the OIDC issuer URL changes with every new cluster.
data "azurerm_user_assigned_identity" "eso" {
  name                = "id-eso-cymbal-bank"
  resource_group_name = "rg-cymbal-bank-persistent"
}

resource "azurerm_federated_identity_credential" "eso" {
  name                      = "eso-aks-cymbal-bank"
  user_assigned_identity_id = data.azurerm_user_assigned_identity.eso.id
  issuer                    = azurerm_kubernetes_cluster.main.oidc_issuer_url
  subject                   = "system:serviceaccount:external-secrets:external-secrets"
  audience                  = ["api://AzureADTokenExchange"]
}
