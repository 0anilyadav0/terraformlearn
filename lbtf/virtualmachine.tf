
resource "azurerm_network_interface" "vmnic" {
  count               = 2
  name                = "${local.vmname}-nic${count.index + 1}"
  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location
  ip_configuration {
    name                          = "${local.vmname}-ipconfig${count.index + 1}"
    primary                       = true
    private_ip_address_allocation = "dynamic"
    subnet_id                     = azurerm_subnet.subnet["dev01-subnet"].id
  }
}

resource "azurerm_virtual_machine" "vm" {
  count                            = 2
  name                             = "${local.vmname}${count.index + 1}"
  resource_group_name              = azurerm_resource_group.rg01.name
  location                         = azurerm_resource_group.rg01.location
  delete_data_disks_on_termination = true
  delete_os_disk_on_termination    = true
  network_interface_ids            = [azurerm_network_interface.vmnic[count.index].id]
  #az vm list-sizes --location eastus | ConvertFrom-Json | ft -AutoSize
  vm_size = "Standard_DS1_v2"
  tags    = local.tag
  os_profile {
    computer_name  = "${local.vmname}${count.index + 1}"
    admin_username = "azureadmin"
    admin_password = "var.password"
    custom_data    = filebase64("${path.module}/script/redhat-webvm-script.sh")
  }
  storage_os_disk {
    name          = "${local.vmname}-os${count.index + 1}"
    create_option = "FromImage"
    caching       = "ReadWrite"
  }
  storage_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "83-gen2"
    version   = "latest"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }

}

