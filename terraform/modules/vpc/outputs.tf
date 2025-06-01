output "vpc_id" {
  value       = aws_vpc.main.id
  description = "ID da VPC gratuita"
}

output "public_subnet_id" {
  value       = aws_subnet.public.id
  description = "ID da subnet pública gratuita"
}

output "private_subnet_id" {
  value       = aws_subnet.private.id
  description = "ID da subnet privada (reservada)"
}
