output "security_group_id" {
  value = aws_security_group.security_group_training.id
}

output "public_subnets" {
  value = aws_subnet.public.*.id
}