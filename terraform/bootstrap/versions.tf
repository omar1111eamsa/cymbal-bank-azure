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
    github = {
      source  = "integrations/github"
      version = "~> 6.13"
    }
  }
  required_version = "~> 1.17"

  cloud {
    organization = "cymbal-bank-org"
    workspaces {
      name    = "cymbal-bank-azure-bootstrap"
      project = "cymbal-bank-azure"
    }
  }
}
