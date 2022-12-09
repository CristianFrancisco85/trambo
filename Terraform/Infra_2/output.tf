output "modulo_instance_ip" {
  value = module.training_instance-module.instance_ip
}

output "modulo_key" {
  value = module.training_instance-module.key
  sensitive = true
}