module "production-southcentral-splunk-heavy-forwarder" {
  source                 = "../../../modules/single_vm"
  location               = "southcentralus"
  environment            = "test"
  prefix                 = "test-"
  label                  = "tst"
  instance_size          = "Standard_D4s_v3"
  accelerated_networking = true
  public_ip              = true
  managed_os_disk_type   = "Standard_LRS"
  adm_password           = "{$var.admin_password}"
}
