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

# Grupo de Seguranca
module "security_groups" {
  source = "./modules/security_groups"
  
  vpc_id      = module.vpc.vpc_id
  project_name = var.project_name
}

# Instância EC2
module "ec2" {
  source = "./modules/ec2"
  
  instance_type   = var.instance_type
  subnet_id       = module.vpc.public_subnet_id
  security_group_id = module.security_groups.app_sg_id
  key_name        = var.key_name
  project_name    = var.project_name
}

# Banco de Dados RDS MySQL
module "rds" {
  source = "./modules/rds"
  
  db_subnet_group_name = module.vpc.db_subnet_group_name
  db_instance_class    = var.db_instance_class
  db_name              = var.db_name
  db_username          = var.db_username
  db_password          = var.db_password
  security_group_id    = module.security_groups.db_sg_id
  project_name         = var.project_name
}

output "ec2_public_ip" {
  value = module.ec2.public_ip
  description = "O endereco IP público da instância EC2"
}

output "rds_endpoint" {
  value = module.rds.endpoint
  description = "O endpoint de conexão da instância RDS"
}

