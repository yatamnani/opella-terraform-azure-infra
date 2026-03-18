#####################################################
# main.tf - Backend configuration for Terraform
#####################################################

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  # Remote backend configuration (already created manually)
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "tfstatestorage1da"
    container_name       = "tfstate"
    key                  = "global-backend.tfstate"
  }
}

provider "azurerm" {
  features {}
}

