resource "azurerm_public_ip" "vmpip" {
  name                = "${local.vmname}-pip"
  allocation_method   = "Static"
  resource_group_name = data.azurerm_resource_group.rg01.name
  location            = data.azurerm_resource_group.rg01.location
}

resource "azurerm_network_interface" "vmnic" {
  name                = "${local.vmname}-nic"
  resource_group_name = data.azurerm_resource_group.rg01.name
  location            = data.azurerm_resource_group.rg01.location
  ip_configuration {
    name                          = "${local.vmname}-ipconfig"
    primary                       = true
    private_ip_address_allocation = "dynamic"
    subnet_id                     = azurerm_subnet.subnet["dev01-subnet"].id
    public_ip_address_id          = azurerm_public_ip.vmpip.id
  }
}

resource "azurerm_virtual_machine" "vm" {
  name                             = local.vmname
  resource_group_name              = data.azurerm_resource_group.rg01.name
  location                         = data.azurerm_resource_group.rg01.location
  delete_data_disks_on_termination = true
  delete_os_disk_on_termination    = true
  network_interface_ids            = [azurerm_network_interface.vmnic.id]
  #az vm list-sizes --location eastus | ConvertFrom-Json | ft -AutoSize
  vm_size = "Standard_DS1_v2"
  tags = local.tag
  os_profile {
    computer_name  = local.vmname
    admin_username = "azureadmin"
    admin_password = local.vmpassword
    custom_data    = filebase64("${path.module}/script/redhat-webvm-script.sh")
  }
  storage_os_disk {
    name          = "${local.vmname}-os"
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
  provisioner "remote-exec" {
    inline = [
      "sudo ip r l"
    ]
    on_failure = continue
  }

  provisioner "local-exec" {
    command = "echo ${azurerm_network_interface.vmnic.private_ip_address} >> private_ips.txt"
  }
  connection {
    type     = "ssh"
    user     = "azureadmin"
    password = local.vmpassword
    host     = azurerm_public_ip.vmpip.ip_address
  }
}

resource "null_resource" "localexec" {
  depends_on = [
    azurerm_virtual_machine.vm
  ]
  provisioner "local-exec" {
    command     = "echo ${azurerm_network_interface.vmnic.private_ip_address} >> from_null_private_ips.txt"
  }
  provisioner "local-exec" {
    when        = destroy
    interpreter = ["PowerShell", "-Command"]
    command     = <<EOT
      pwd
      cd F:\VSCode\Terraform\terraform\maintf
      rm *.txt
    EOT
  }
}