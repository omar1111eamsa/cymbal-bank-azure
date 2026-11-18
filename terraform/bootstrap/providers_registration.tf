locals {
  namespaces = toset(["Microsoft.KeyVault", "Microsoft.Network", "Microsoft.Compute", "Microsoft.ContainerService", "Microsoft.ManagedIdentity", "Microsoft.ServiceNetworking"])
}


resource "azurerm_resource_provider_registration" "provider_registration" {
  for_each = local.namespaces
  name     = each.key
}