resource "azurerm_virtual_network" "main" {
  name                = "vnet-cymbal-bank"
  location            = data.azurerm_resource_group.ephemeral.location
  resource_group_name = data.azurerm_resource_group.ephemeral.name
  address_space       = ["10.10.0.0/16"]
  tags                = local.tags
}

resource "azurerm_subnet" "aks_nodes" {
  name                 = "snet-aks-nodes"
  resource_group_name  = azurerm_virtual_network.main.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.10.0.0/24"]

  # No implicit internet access: egress only through the NAT Gateway
  default_outbound_access_enabled = false
}

resource "azurerm_public_ip" "nat" {
  name                = "pip-nat-cymbal-bank"
  location            = data.azurerm_resource_group.ephemeral.location
  resource_group_name = data.azurerm_resource_group.ephemeral.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.tags
}

resource "azurerm_nat_gateway" "main" {
  name                = "ng-cymbal-bank"
  location            = data.azurerm_resource_group.ephemeral.location
  resource_group_name = data.azurerm_resource_group.ephemeral.name
  sku_name            = "Standard"
  tags                = local.tags
}

resource "azurerm_nat_gateway_public_ip_association" "main" {
  nat_gateway_id       = azurerm_nat_gateway.main.id
  public_ip_address_id = azurerm_public_ip.nat.id
}

resource "azurerm_subnet_nat_gateway_association" "aks_nodes" {
  subnet_id      = azurerm_subnet.aks_nodes.id
  nat_gateway_id = azurerm_nat_gateway.main.id
}

resource "azurerm_network_security_group" "aks_nodes" {
  name                = "nsg-aks-nodes"
  location            = data.azurerm_resource_group.ephemeral.location
  resource_group_name = data.azurerm_resource_group.ephemeral.name
  tags                = local.tags
}

resource "azurerm_subnet_network_security_group_association" "aks_nodes" {
  subnet_id                 = azurerm_subnet.aks_nodes.id
  network_security_group_id = azurerm_network_security_group.aks_nodes.id
}
