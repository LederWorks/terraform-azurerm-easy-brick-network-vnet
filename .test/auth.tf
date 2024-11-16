# Providers
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  storage_use_azuread = true
}

# Versions
terraform {
  required_version = ">=1.3.4"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.10.0"
    }
  }

}

#Backend
terraform {
  backend "azurerm" {
    resource_group_name  = "rgrp-pde3-it-terratest"
    storage_account_name = "saccpde3itterratest001"
    container_name       = "terratest-azurerm"
    key                  = "easy-brick-network-vnet.default.tfstate"
    snapshot             = true
  }
}

data "azurerm_client_config" "current" {}
