variable "vpc_cidr_block" {
  description = "CIDR block para a VPC"
}

variable "public_subnet_cidr" {
  description = "CIDR block para a subnet pública"
}

variable "private_subnet_cidr" {
  description = "CIDR block para a subnet privada"
}

variable "availability_zone" {
  description = "Zona de disponibilidade para as subnets"
}

variable "project_name" {
  description = "Nome do projeto para identificação dos recursos"
}
