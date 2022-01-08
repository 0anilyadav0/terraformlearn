resource "azurerm_resource_group" "resourcegroup" {
  name     = "${var.base_name}rg"
  location = var.location
}