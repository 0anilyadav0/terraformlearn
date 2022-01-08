terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.90.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "Resourcegroup" {
  source = "./Resourcegroup"
  base_name = "terraformstg"
  location = "westus"
} 

module "StorageAccount" {
  source = "./StorageAccount"
  base_name = "terraformstg"
  resourcegroupname = module.Resourcegroup.rg_name_out
  location = "westus"
}