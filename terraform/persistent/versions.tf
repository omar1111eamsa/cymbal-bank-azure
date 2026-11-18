terraform {
  required_version = "~> 1.17"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.14"
    }

  }

  cloud {
    organization = "cymbal-bank-org"
    workspaces {
      name    = "cymbal-bank-azure-persistent"
      project = "cymbal-bank-azure"
    }
  }
}