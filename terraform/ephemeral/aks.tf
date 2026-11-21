data "azurerm_user_assigned_identity" "aks" {
  name                = "id-aks-cymbal-bank"
  resource_group_name = "rg-cymbal-bank-persistent"
}

data "azurerm_client_config" "current" {}

resource "azurerm_kubernetes_cluster" "main" {
  name                    = "aks-cymbal-bank"
  location                = data.azurerm_resource_group.ephemeral.location
  resource_group_name     = data.azurerm_resource_group.ephemeral.name
  dns_prefix              = "cymbal-bank"
  sku_tier                = "Free"
  tags                    = local.tags
  node_os_upgrade_channel = "Unmanaged"

  identity {
    type         = "UserAssigned"
    identity_ids = [data.azurerm_user_assigned_identity.aks.id]
  }

  default_node_pool {
    name           = "system"
    vm_size        = "Standard_B2s_v2"
    node_count     = 3
    vnet_subnet_id = azurerm_subnet.aks_nodes.id
    upgrade_settings {
      max_surge = "1"
    }
  }
  node_provisioning_profile {
    mode = "Manual"
  }

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_data_plane  = "cilium"
    network_policy      = "cilium"
    pod_cidr            = "10.244.0.0/16"
    service_cidr        = "10.0.0.0/16"
    dns_service_ip      = "10.0.0.10"
    outbound_type       = "userAssignedNATGateway"
    load_balancer_sku   = "standard"
  }

  local_account_disabled = true
  azure_active_directory_role_based_access_control {
    azure_rbac_enabled = true
    tenant_id          = data.azurerm_client_config.current.tenant_id
  }

  oidc_issuer_enabled       = true
  workload_identity_enabled = true
  run_command_enabled       = false

  depends_on = [azurerm_subnet_nat_gateway_association.aks_nodes, azurerm_subnet_network_security_group_association.aks_nodes]
}
