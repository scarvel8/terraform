
terraform {
  required_version = ">= 0.12.0"
}

module "env" {
  source      = "./env_vars"
  environment = "${var.environment}"
}

locals {
  admin_username = "admin"
  vm_basename    = "${var.prefix}-${var.label}"
  tags = {
    created_by = "Terraform"
  }
}

resource "azurerm_network_interface" "nic" {
  count                         = 1
  name                          = "${local.vm_basename}${count.index}-nic"
  location                      = "${var.location}"
  resource_group_name           = "${module.env.resource_group_name}"
  network_security_group_id     = "${module.env.network_security_group_id}"
  enable_accelerated_networking = "${var.accelerated_networking}"

  ip_configuration {
    name                          = "IPConfig${count.index}"
    subnet_id                     = "${module.env.subnet_id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${length(azurerm_public_ip.pubip.*.id) > 0 ? element(concat(azurerm_public_ip.pubip.*.id, list("")), count.index) : ""}"
  }

  tags = "${local.tags}"

  lifecycle {
    ignore_changes = ["tags"]
  }

}

resource "azurerm_virtual_machine" "single_vm" {
  count               = 1
  name                = "${local.vm_basename}${count.index}"
  location            = "${var.location}"
  resource_group_name = "${module.env.resource_group_name}"

  network_interface_ids = ["${element(azurerm_network_interface.nic.*.id, count.index)}"]
  vm_size               = "${var.instance_size}"

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  os_profile {
    computer_name  = "${local.vm_basename}${count.index}"
    admin_username = "${local.admin_username}"
    admin_password = "${var.admin_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${local.vm_basename}${count.index}-os"
    caching           = "${var.os_disk_caching}"
    create_option     = "FromImage"
    managed_disk_type = "${var.managed_os_disk_type}"
    disk_size_gb      = "${var.os_disk_size_gb}"
  }

  tags = "${local.tags}"

  dynamic "storage_data_disk" {

    for_each = [for i in var.storage_disk : {
      lun                    = i.lun
      data_disk_size_gb      = i.data_disk_size_gb
      caching                = i.data_disk_caching
      managed_data_disk_type = i.managed_data_disk_type
    }]

    content {
      name              = "${local.vm_basename}${count.index}-data-disk${storage_data_disk.value.lun}"
      lun               = "${storage_data_disk.value.lun}"
      disk_size_gb      = "${storage_data_disk.value.data_disk_size_gb}"
      caching           = "${storage_data_disk.value.caching}"
      create_option     = "Empty"
      managed_disk_type = "${storage_data_disk.value.managed_data_disk_type}"
    }
  }

  lifecycle {
    ignore_changes = ["tags"]
  }
}

resource "azurerm_public_ip" "pubip" {
  count                        = "${var.public_ip ? 1 : 0}"
  name                         = "${local.vm_basename}-${count.index}-publicIP"
  location                     = "${var.location}"
  resource_group_name          = "${module.env.resource_group_name}"
  public_ip_address_allocation = "${var.public_ip_address_allocation}"
  domain_name_label            = "${local.vm_basename}-${count.index}"
  tags                         = "${local.tags}"

  lifecycle {
    ignore_changes = ["tags"]
  }
}
