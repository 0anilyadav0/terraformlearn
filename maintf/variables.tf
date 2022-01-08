variable "nsg" {
  type = string
}
variable "env" {
  type = string
}
variable "department" {
  type = string
}

variable "VNET_Address_space" {
  type        = list(string)
  description = "Virtual Network Address Space"
  default     = ["10.0.0.0/16"]
}

variable "subnet" {
  type = object({
    adbprivate-subnet = list(string)
    adbpublic-subnet  = list(string)
    dev01-subnet      = list(string)
  })
  description = "Subnet Name And Address prefix"
  default = {
    "adbprivate-subnet" = ["10.0.1.0/24"]
    "adbpublic-subnet"  = ["10.0.2.0/24"]
    "dev01-subnet"      = ["10.0.3.0/24"]
  }
}

variable "VMSuffix" {
  type        = string
  description = "Used to create VM name "
  default     = "vm01"
}

