resource "azurerm_storage_account" "blobstorage" {
  name                     = "tflearndsa"
  resource_group_name      = azurerm_resource_group.rg01.name
  location                 = azurerm_resource_group.rg01.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = true
  
}
resource "azurerm_storage_container" "statecontainer" {
  name                  = "statecontainer"
  storage_account_name  = azurerm_storage_account.blobstorage.name
  container_access_type = "container"
  depends_on = [
    azurerm_storage_account.blobstorage
  ]
}