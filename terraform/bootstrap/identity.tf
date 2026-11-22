data "azuread_client_config" "current" {}

locals {
  layers = toset(["persistent", "ephemeral"])
  phases = toset(["plan", "apply"])

  # Every layer × phase pair, keyed "ephemeral-plan", "ephemeral-apply"…
  federated_credentials = {
    for pair in setproduct(local.layers, local.phases) :
    "${pair[0]}-${pair[1]}" => {
      layer = pair[0]
      phase = pair[1]
    }
  }
}


resource "azuread_application" "hcp" {
  for_each     = local.layers
  display_name = "hcp-terraform-${each.key}"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "hcp" {
  for_each  = azuread_application.hcp
  client_id = each.value.client_id
  owners    = [data.azuread_client_config.current.object_id]
}


resource "azuread_application_federated_identity_credential" "hcp" {
  for_each = local.federated_credentials

  application_id = azuread_application.hcp[each.value.layer].id
  display_name   = "hcp-terraform-${each.key}"
  issuer         = "https://app.terraform.io"
  audiences      = ["api://AzureADTokenExchange"]
  subject        = "organization:${tfe_workspace.layer[each.value.layer].organization}:project:${tfe_project.azure.name}:workspace:${tfe_workspace.layer[each.value.layer].name}:run_phase:${each.value.phase}"
}


