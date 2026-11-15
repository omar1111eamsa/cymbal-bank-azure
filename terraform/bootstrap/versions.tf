terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.14"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.10"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.84.0"
    }
  }
  required_version = "~> 1.17"
}
