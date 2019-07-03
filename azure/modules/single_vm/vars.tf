variable "location" {
  description = "The location that the resource will be provisioned in. Example: southcentralus"
}

variable "environment" {
  description = "The environment the VM is in."
}

variable "prefix" {
  description = "VM name = prefix + label"
}

variable "instance_size" {
  description = "The VM size that will be used, search Azure VM Sizes on Google for reference. Example: Standard_D3_v2"
}

variable "label" {
  description = "VM name = prefix + label"
}

variable "accelerated_networking" {
  description = "Turns on accelerated networking for VM. Enable when possible, not all VM sizes support accelerated networking"
  default     = true
}

variable "os_disk_caching" {
  description = "Type of disk caching to use for the OS disk. Options are None, ReadOnly, ReadWrite. Defaults to ReadWrite"
  default     = "ReadWrite"
}

variable "managed_os_disk_type" {
  description = "OS disk type, defaults to Standard_LRS"
  default     = "Standard_LRS"
}

variable "os_disk_size_gb" {
  description = "Size of OS disk in GB (careful of IO/IOPS throttling)"
  default     = 128
}

variable "storage_disk" {
  description = "Attached disk definition"
  default     = []
}

variable "adm_password" {
  description = "Admin password"
}

variable "public_ip" {
  description = "Number of public IPs to assign corresponding to one IP per vm. Set to 0 to not assign any public IP addresses."
  default     = "0"
}

variable "public_ip_address_allocation" {
  description = "Defines how an IP address is assigned. Options are static or dynamic."
  default     = "static"
}
