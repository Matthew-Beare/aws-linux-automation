output "instance_ids" {
  value = { for label, machine in aws_instance.linux : label => machine.id }
}
output "public_ips" {
  value = { for label, machine in aws_instance.linux : label => machine.public_ip }
}
