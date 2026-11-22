provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}


provider "azuread" {
  tenant_id = var.tenant_id
}

provider "tfe" {
  organization = "cymbal-bank-org"
}

provider "github" {
  owner = "omar1111eamsa"
}