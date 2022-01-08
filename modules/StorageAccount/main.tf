terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.1.0"
    }
  }
}

resource "random_string" "random" {
  length = 6
  upper = false
  special = false
}

resource "azurerm_storage_account" "storageaccount" {
  name                     = "${lower(var.base_name)}${random_string.random.result}"
  resource_group_name      = var.resourcegroupname
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

}