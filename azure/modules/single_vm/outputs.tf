output "vm_ids" {
  description = "Virtual machine ids created."
  value       = "${concat(azurerm_virtual_machine.single_vm.*.id)}"
}

output "network_interface_ids" {
  description = "ids of the vm nics provisoned."
  value       = "${azurerm_network_interface.nic.*.id}"
}

output "public_ip_id" {
  description = "id of the public ip address provisoned."
  value       = "${azurerm_public_ip.pubip.*.id}"
}

output "public_ip_address" {
  description = "The actual ip address allocated for the resource."
  value       = "${azurerm_public_ip.pubip.*.ip_address}"
}


output "public_ip_dns_name" {
  description = "fqdn to connect to the first vm provisioned."
  value       = "${azurerm_public_ip.pubip.*.fqdn}"
}
