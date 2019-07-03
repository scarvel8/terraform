variable "environment" {
  default = ""
}

variable "resource_group_name" {
  default = {
    "(envname)" = "(resourcegroup)"
  }
}

variable "subnet_id" {
  default = {
    "(envname)" = "(subnetid)"
  }
}

variable "network_security_group_id" {
  default = {
    "(envname)" = "(securitygroupid)"
  }
}
