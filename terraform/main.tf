provider "aws" {
  region = var.aws_region
}

# VPC e Rede
module "vpc" {
  source = "./modules/vpc"
  
  vpc_cidr_block     = var.vpc_cidr_block
  public_subnet_cidr = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone  = var.availability_zone
  project_name       = var.project_name
}

# Grupo de Segurança
module "security_groups" {
  source = "./modules/security_groups"
  
  vpc_id      = module.vpc.vpc_id
  project_name = var.project_name
}

# Instância EC2
module "ec2" {
  source = "./modules/ec2"
  
  instance_type     = var.instance_type
  subnet_id         = module.vpc.public_subnet_id
  security_group_id = module.security_groups.app_sg_id
  key_name          = var.key_name
  project_name      = var.project_name
  db_host           = "localhost"  # SQLite é local
  db_username       = ""           # Não necessário para SQLite
  db_password       = ""           # Não necessário para SQLite  
  db_name           = ""           # Não necessário para SQLite
}

output "ec2_public_ip" {
  value = module.ec2.public_ip
  description = "O endereço IP público da instância EC2"
}

output "application_url" {
  value = "http://${module.ec2.public_ip}:3001"
  description = "URL para acessar a aplicação CRUD com SQLite"
}

output "ssh_command" {
  value = "ssh -i ~/.ssh/crud-app-key.pem ec2-user@${module.ec2.public_ip}"
  description = "Comando para conectar via SSH"
}

output "database_info" {
  value = "SQLite local na instância - arquivo: /home/ec2-user/app/database.sqlite"
  description = "Informações sobre o banco de dados"
}

