terraform {
  required_version = "~> 1.17"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.14"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.9"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.4"
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