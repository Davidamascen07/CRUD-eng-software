variable "aws_region" {
  description = "Região da AWS onde os recursos serão criados"
  default     = "us-east-2"  # Alterado de us-east-1 para us-east-2 (Ohio)
}

variable "project_name" {
  description = "Nome do projeto para identificação dos recursos"
  default     = "crud-app"
}

variable "vpc_cidr_block" {
  description = "CIDR block para a VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block para a subnet pública"
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block para a subnet privada"
  default     = "10.0.2.0/24"
}

variable "availability_zone" {
  description = "Zona de disponibilidade para as subnets"
  default     = "us-east-2a"  # Alterado para corresponder à nova região us-east-2
}

variable "instance_type" {
  description = "Tipo de instância EC2"
  default     = "t2.micro"
}

variable "key_name" {
  description = "Nome do key pair para acesso SSH"
  default     = "crud-app-key"  # Assegure-se que este nome corresponde ao seu key pair na AWS
}

variable "db_instance_class" {
  description = "Classe de instância para o RDS"
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Nome do banco de dados"
  default     = "crud_app"
}

variable "db_username" {
  description = "Nome de usuário para o banco de dados"
  default     = "crudadmin"
}

variable "db_password" {
  description = "Senha para o banco de dados"
  sensitive   = true
  default     = "ChangeMe123!" # Alterar para uma senha segura em produção
}
