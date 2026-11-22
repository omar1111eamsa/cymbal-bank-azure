# Owner and repo as GitHub sees them: name + immutable numeric ID
data "github_user" "owner" {
  username = "omar1111eamsa"
}

data "github_repository" "azure" {
  name = "cymbal-bank-azure"
}

resource "azuread_application" "github" {
  display_name = "github-actions-cymbal-bank-azure"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "github" {
  client_id = azuread_application.github.client_id
  owners    = [data.azuread_client_config.current.object_id]
}

# GitHub sends "repo:<owner>@<id>/<repo>@<id>:ref:...". The IDs never get reused,
# so a deleted/renamed repo recreated under the same name can't get tokens.
resource "azuread_application_federated_identity_credential" "github_main" {
  application_id = azuread_application.github.id
  display_name   = "github-main"
  issuer         = "https://token.actions.githubusercontent.com"
  audiences      = ["api://AzureADTokenExchange"]
  subject        = "repo:${data.github_user.owner.login}@${data.github_user.owner.id}/${data.github_repository.azure.name}@${data.github_repository.azure.repo_id}:ref:refs/heads/main"
}

resource "azurerm_role_assignment" "github_aks_user" {
  scope                = azurerm_resource_group.rg["ephemeral"].id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = azuread_service_principal.github.object_id
}

resource "azurerm_role_assignment" "github_aks_admin" {
  scope                = azurerm_resource_group.rg["ephemeral"].id
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id         = azuread_service_principal.github.object_id
}

# What azure/login needs in the workflows. IDs, not secrets: useless without the
# federated trust above. Follows the identity if it is ever recreated.
resource "github_actions_variable" "azure" {
  for_each = {
    AZURE_CLIENT_ID       = azuread_application.github.client_id
    AZURE_TENANT_ID       = var.tenant_id
    AZURE_SUBSCRIPTION_ID = var.subscription_id
  }

  repository    = data.github_repository.azure.name
  variable_name = each.key
  value         = each.value
}
