resource "azurerm_public_ip" "lbpip" {
  name                = "lbpip"
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name
  allocation_method   = "Static"
  sku                 = "standard"
}

resource "azurerm_lb" "lb" {
  name                = "lb01"
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name
  sku                 = "standard"
  frontend_ip_configuration {
    name                 = "lbpip"
    public_ip_address_id = azurerm_public_ip.lbpip.id
  }
}

resource "azurerm_lb_backend_address_pool" "bepool" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "bepool"
}

resource "azurerm_lb_probe" "healthprobe" {
  name                = "hb01"
  loadbalancer_id     = azurerm_lb.lb.id
  port                = 80

  resource_group_name = azurerm_resource_group.rg01.name
  number_of_probes    = 10
  interval_in_seconds = 60


}
resource "azurerm_lb_rule" "lbrule" {
  loadbalancer_id                = azurerm_lb.lb.id
  probe_id                       = azurerm_lb_probe.healthprobe.id
  name                           = "lbrule"
  protocol                       = "TCP"
  resource_group_name            = azurerm_resource_group.rg01.name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.bepool.id]
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.lb.frontend_ip_configuration[0].name
  frontend_port                  = 80

}

resource "azurerm_network_interface_backend_address_pool_association" "nicbepoolassoc" {
  count                   = 2
  network_interface_id    = azurerm_network_interface.vmnic[count.index].id
  ip_configuration_name   = azurerm_network_interface.vmnic[count.index].ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.bepool.id
}

resource "azurerm_lb_nat_rule" "natrule" {
  name ="shh-vm01"
  backend_port = 22
  frontend_port = 1022
  frontend_ip_configuration_name = azurerm_lb.lb.frontend_ip_configuration[0].name
  loadbalancer_id = azurerm_lb.lb.id
  protocol = "Tcp"
  resource_group_name = azurerm_resource_group.rg01.name

}

resource "azurerm_network_interface_nat_rule_association" "webnic" {
  ip_configuration_name = azurerm_network_interface.vmnic[0].ip_configuration[0].name
  network_interface_id = azurerm_network_interface.vmnic[0].id
  nat_rule_id = azurerm_lb_nat_rule.natrule.id
}

resource "azurerm_lb_nat_rule" "natrule1" {
  name ="shh-vm02"
  backend_port = 22
  frontend_port = 2022
  frontend_ip_configuration_name = azurerm_lb.lb.frontend_ip_configuration[0].name
  loadbalancer_id = azurerm_lb.lb.id
  protocol = "Tcp"
  resource_group_name = azurerm_resource_group.rg01.name

}

resource "azurerm_network_interface_nat_rule_association" "webnic1" {
  ip_configuration_name = azurerm_network_interface.vmnic[1].ip_configuration[0].name
  network_interface_id = azurerm_network_interface.vmnic[1].id
  nat_rule_id = azurerm_lb_nat_rule.natrule.id
}