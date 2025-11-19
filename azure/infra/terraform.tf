terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.44.1"
    }
  }
  cloud {
    workspaces {
      name = "azure-terraform-dynamic-credentials"
    }
  }
}
