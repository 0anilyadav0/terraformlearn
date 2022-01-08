data "azurerm_client_config" "current" {}
data "azurerm_resource_group" "rg01" {
  name = "tfrg01"
}
data "azurerm_key_vault" "akv" {
  name                = "aykv01"
  resource_group_name = data.azurerm_resource_group.rg01.name
}

data "azurerm_key_vault_secret" "secret" {
  name         = "VMPassword"
  key_vault_id = data.azurerm_key_vault.akv.id
}