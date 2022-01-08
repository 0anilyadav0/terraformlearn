resource "azurerm_virtual_network" "VNET" {
  name                = "${local.infra_prefix}-VNET01"
  address_space       = var.VNET_Address_space
  location            = data.azurerm_resource_group.rg01.location
  resource_group_name = data.azurerm_resource_group.rg01.name
tags = local.tag
}

resource "azurerm_subnet" "subnet" {
  for_each             = var.subnet
  name                 = each.key
  address_prefixes     = each.value
  virtual_network_name = azurerm_virtual_network.VNET.name
  depends_on = [
    azurerm_virtual_network.VNET
  ]
  resource_group_name = data.azurerm_resource_group.rg01.name
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${local.infra_prefix}-${var.nsg}"
  resource_group_name = data.azurerm_resource_group.rg01.name
  location            = data.azurerm_resource_group.rg01.location
  tags                = local.tag
}

resource "azurerm_network_security_rule" "nsgrule" {
  for_each                    = local.portpriority
  name                        = "Allow-Inbound-${local.protocols[each.key]}"
  priority                    = each.value
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.key
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.rg01.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_subnet_network_security_group_association" "Subnet_NSG_Assoc" {
  subnet_id                 = azurerm_subnet.subnet["dev01-subnet"].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

