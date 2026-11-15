resource "tfe_project" "azure" {
  name = "cymbal-bank-azure"
}

resource "tfe_workspace" "layer" {
  for_each   = local.layers
  name       = "cymbal-bank-azure-${each.key}"
  project_id = tfe_project.azure.id
}

# Turns on OIDC: each run gets a short-lived Azure token, no secret stored
resource "tfe_variable" "azure_provider_auth" {
  for_each = local.layers

  workspace_id = tfe_workspace.layer[each.key].id
  category     = "env"
  key          = "TFC_AZURE_PROVIDER_AUTH"
  value        = "true"
}

resource "tfe_variable" "azure_run_client_id" {
  for_each = local.layers

  workspace_id = tfe_workspace.layer[each.key].id
  category     = "env"
  key          = "TFC_AZURE_RUN_CLIENT_ID"
  value        = azuread_application.hcp[each.key].client_id
}

resource "tfe_variable" "arm_subscription_id" {
  for_each = local.layers

  workspace_id = tfe_workspace.layer[each.key].id
  category     = "env"
  key          = "ARM_SUBSCRIPTION_ID"
  value        = var.subscription_id
}

resource "tfe_variable" "arm_tenant_id" {
  for_each = local.layers

  workspace_id = tfe_workspace.layer[each.key].id
  category     = "env"
  key          = "ARM_TENANT_ID"
  value        = var.tenant_id
}