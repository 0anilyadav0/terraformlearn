output "subnet" {
  value = {
    for subnetname, details in azurerm_subnet.subnet :
    subnetname => (details.address_prefix)
  }
}

output "VM_Public_IP" {
  value = azurerm_public_ip.vmpip.ip_address
}
output "VM_Private_IP" {
  value = azurerm_network_interface.vmnic.private_ip_address
}