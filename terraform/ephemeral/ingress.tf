# Public entry point of the bank: a static IP that the Istio gateway's
# LoadBalancer Service adopts (annotations azure-pip-name + azure-load-balancer-resource-group).
# Created here so DNS and the NSG rule can use it before the Service exists.
resource "azurerm_public_ip" "ingress" {
  name                = "pip-ingress-cymbal-bank"
  location            = data.azurerm_resource_group.ephemeral.location
  resource_group_name = data.azurerm_resource_group.ephemeral.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.tags
}

# The subnet NSG denies inbound internet by default and AKS doesn't edit a custom
# subnet NSG, so open 80/443 to the ingress IP only (AKS LB uses floating IP:
# packets keep the frontend IP as destination). 80 = HTTP-01 challenge + redirect.
resource "azurerm_network_security_rule" "ingress_https" {
  name                        = "allow-internet-ingress-http-https"
  network_security_group_name = azurerm_network_security_group.aks_nodes.name
  resource_group_name         = data.azurerm_resource_group.ephemeral.name
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_address_prefix       = "Internet"
  source_port_range           = "*"
  destination_address_prefix  = azurerm_public_ip.ingress.ip_address
  destination_port_ranges     = ["80", "443"]
}

# DNS-only record (not proxied): Let's Encrypt and clients reach Azure directly
data "cloudflare_zone" "main" {
  filter = {
    name = "assfah.me"
  }
}

resource "cloudflare_dns_record" "bank" {
  zone_id = data.cloudflare_zone.main.zone_id
  name    = "bank.az"
  type    = "A"
  content = azurerm_public_ip.ingress.ip_address
  ttl     = 1 # automatic
  proxied = false
  comment = "Cymbal Bank on AKS (terraform: cymbal-bank-azure ephemeral)"
}
