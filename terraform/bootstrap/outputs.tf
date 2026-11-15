# Login ID of each layer's identity (public, not a secret): handy to debug OIDC
output "hcp_client_ids" {
  description = "Client ID of the HCP Terraform identity of each layer"
  value       = { for layer, app in azuread_application.hcp : layer => app.client_id }
}

# persistent/ephemeral create their resources inside these groups
output "resource_groups" {
  description = "Resource group of each layer"
  value       = { for layer, rg in azurerm_resource_group.rg : layer => rg.name }
}

# The cloud block of persistent/ephemeral points to these workspaces
output "workspaces" {
  description = "HCP Terraform workspace of each layer"
  value       = { for layer, ws in tfe_workspace.layer : layer => ws.name }
}
