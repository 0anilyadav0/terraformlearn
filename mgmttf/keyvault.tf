data "azurerm_client_config" "current" {}
resource "azurerm_key_vault" "akv" {
  name = "aykv01"
  location = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name  
  sku_name = "standard"
  tenant_id = data.azurerm_client_config.current.tenant_id
}
#terraform import azurerm_key_vault_access_policy.access_policy "/subscriptions/b9e0d361xxxxxxxxxxxx8fea/resourceGroups/rg01/providers/Microsoft.KeyVault/vaults/aykv01/objectId/1ce1b963-f889-42a6-b8d7-0a43a0ba2a08"
resource "azurerm_key_vault_access_policy" "access_policy" {
  key_vault_id = azurerm_key_vault.akv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Get","Delete", "Get", "List", "Set","Purge","Recover"
  ]
}

resource "azurerm_key_vault_secret" "secret" {
  name         = "VMPassword"
  value        = "var.password"
  key_vault_id = azurerm_key_vault.akv.id
  depends_on = [
    azurerm_key_vault_access_policy.access_policy
  ]
}
