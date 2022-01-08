terraform {
  required_version = "=1.1.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.90.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.1.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tfrg01"
    storage_account_name = "tflearndsa"
    container_name       = "statecontainer"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

provider "random" {
  # Configuration options
}

provider "null" {
  # Configuration options
}


resource "random_string" "random" {
  length  = 6
  upper   = false
  special = false
  number  = false
}