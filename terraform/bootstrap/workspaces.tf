resource "tfe_project" "azure" {
  name = "cymbal-bank-azure"
}

# Holds this stack's own state. Not in local.layers on purpose: no OIDC identity,
# bootstrap creates identities and roles, so it runs only with your own rights
resource "tfe_workspace" "bootstrap" {
  name       = "cymbal-bank-azure-bootstrap"
  project_id = tfe_project.azure.id

  # Deleting it would delete the bootstrap state with it
  lifecycle {
    prevent_destroy = true
  }
}

# Local execution: HCP only stores the state, plan/apply run on your laptop
resource "tfe_workspace_settings" "bootstrap" {
  workspace_id   = tfe_workspace.bootstrap.id
  execution_mode = "local"
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

resource "tfe_variable" "cloudflare_api_token" {

  workspace_id = tfe_workspace.layer["ephemeral"].id
  category     = "env"
  sensitive    = true
  key          = "CLOUDFLARE_API_TOKEN"
  value_wo     = var.cloudflare_api_token
}


moved {
  from = tfe_variable.cloudeflare_api_token
  to = tfe_variable.cloudflare_api_token
}