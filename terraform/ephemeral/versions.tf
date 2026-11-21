terraform {
  required_version = "~> 1.17"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.14"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.29"
    }
  }

  cloud {
    organization = "cymbal-bank-org"
    workspaces {
      name    = "cymbal-bank-azure-ephemeral"
      project = "cymbal-bank-azure"
    }
  }
}