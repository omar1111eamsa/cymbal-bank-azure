data "azurerm_resource_group" "ephemeral" {
  name = "rg-cymbal-bank-ephemeral"
}

# Tags (Azure "labels") on every taggable resource: cost per layer, who manages it
locals {
  tags = {
    project    = "cymbal-bank"
    layer      = "ephemeral"
    managed_by = "terraform"
    repo       = "omar1111eamsa/cymbal-bank-azure"
  }
}
