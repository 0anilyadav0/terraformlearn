resource "azurerm_virtual_network" "VNET" {
  name                = "${local.infra_prefix}-VNET01"
  address_space       = var.VNET_Address_space
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name
  tags                = local.tag
}

resource "azurerm_subnet" "subnet" {
  for_each             = var.subnet
  name                 = each.key
  address_prefixes     = each.value
  virtual_network_name = azurerm_virtual_network.VNET.name
  depends_on = [
    azurerm_virtual_network.VNET
  ]
  resource_group_name = azurerm_resource_group.rg01.name
}
