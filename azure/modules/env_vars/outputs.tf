output "resource_group_name" {
  value = "${lookup(var.resource_group_name, var.environment)}"
}

output "subnet_id" {
  value = "${lookup(var.subnet_id, var.environment)}"
}

output "network_security_group_id" {
  value = "${lookup(var.network_security_group_id, var.environment)}"
}
