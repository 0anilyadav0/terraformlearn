locals {
  infra_prefix = "${var.department}-${lower(substr(var.env, 0, 1))}"
  tag = {
    department = var.department
    env        = var.env
  }

}

locals {
  protocols = {
    "22"  = "ssh"
    "80"  = "http"
    "443" = "https"
  }
  portpriority = {
    "22" : "100"
    "80" : "101"
    "443" : "102"
  }
}

locals {
  vmname     = "${local.infra_prefix}-${lower(var.VMSuffix)}"
  vmpassword = data.azurerm_key_vault_secret.secret.value
}