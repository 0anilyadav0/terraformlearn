nsg                = "nsg"
env                = "development"
department         = "tflearn"
VNET_Address_space = ["10.1.0.0/16"]
subnet = {
  adbprivate-subnet = ["10.1.1.0/24"]
  adbpublic-subnet  = ["10.1.2.0/24"]
  dev01-subnet      = ["10.1.3.0/24"]
}
VMSuffix = "web"
