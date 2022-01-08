locals {
  infra_prefix = lower("${var.department}${substr(var.env, 0, 1)}")
  tag = {
    department = var.department
    env        = var.env
  }

}

locals {
  vmname = "${local.infra_prefix}-${lower(var.VMSuffix)}"
}