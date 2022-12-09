output "instance_ip" {
  value = aws_instance.instance_training.*.public_ip
}

output "key" {
  value = tls_private_key.pk.private_key_pem
}
