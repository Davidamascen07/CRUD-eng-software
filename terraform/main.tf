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
  app_port    = var.app_port  # Adicionar variável que estava faltando
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

output "frontend_url" {
  value = "http://${module.ec2.public_ip}"
  description = "URL para acessar o frontend React"
}

output "backend_url" {
  value = "http://${module.ec2.public_ip}:3001"
  description = "URL para acessar a API backend"
}

output "health_check_url" {
  value = "http://${module.ec2.public_ip}/health"
  description = "URL para verificar saúde da aplicação"
}

output "ssh_command" {
  value = "ssh -i ~/.ssh/crud-app-key.pem ec2-user@${module.ec2.public_ip}"
  description = "Comando para conectar via SSH"
}

output "deployment_info" {
  value = {
    frontend = "React servido pelo Nginx na porta 80"
    backend = "Node.js com Express na porta 3001"
    database = "SQLite local"
    proxy = "Nginx fazendo proxy /api/* para backend"
    repository = "https://github.com/Davidamascen07/CRUD-eng-software.git"
  }
  description = "Informações do deployment"
}

output "free_tier_info" {
  value = {
    instance_type    = "t2.micro (750h/mês GRÁTIS)"
    database        = "SQLite Local (US$ 0.00)"
    storage         = "8GB EBS gp2 (30GB GRÁTIS)"
    network         = "VPC + Subnet (GRÁTIS)"
    ip              = "1 Elastic IP (GRÁTIS)"
    bandwidth       = "1GB/mês (GRÁTIS)"
    monthly_cost    = "US$ 0.00"
    node_version    = "16.x LTS"
    estimated_cost  = "💚 TOTALMENTE GRATUITO"
  }
  description = "Confirmação de uso 100% Free Tier"
}

output "cost_monitoring" {
  value = {
    warning = "⚠️ MONITORE SEU USO:"
    ec2_limit = "750 horas/mês t2.micro"
    ebs_limit = "30 GB armazenamento"
    transfer_limit = "1 GB transferência/mês"
    tip = "Configure billing alerts na AWS"
  }
  description = "Limites do Free Tier para monitorar"
}

