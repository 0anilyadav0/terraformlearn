#terraform import azurerm_resource_group.rg01 /subscriptions/b9e0d361-8c90-41bc-9099-a1f575078fea/resourceGroups/rg01
resource "azurerm_resource_group" "rg01" {
  name     = "tfrg01"
  location = "eastus"
}