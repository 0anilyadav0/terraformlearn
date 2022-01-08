
variable "env" {
  type    = string
  default = "development"
}
variable "department" {
  type    = string
  default = "tblblearn"
}

variable "VNET_Address_space" {
  type        = list(string)
  description = "Virtual Network Address Space"
  default     = ["10.0.0.0/16"]
}

variable "subnet" {
  type = object({
    dev01-subnet = list(string)
  })
  description = "Subnet Name And Address prefix"
  default = {
    "dev01-subnet" = ["10.0.3.0/24"]
  }
}

variable "VMSuffix" {
  type        = string
  description = "Used to create VM name "
  default     = "web"
}

variable "password" {
  type = string
}