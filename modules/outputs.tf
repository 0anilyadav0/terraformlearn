output "stgaccname" {
  value = module.StorageAccount.Storage_Account_Name
}

output "rgname" {
  value = module.Resourcegroup.rg_name_out
}