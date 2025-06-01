provider "aws" {
  region = var.aws_region
}

# VPC e Rede - GRATUITO
module "vpc" {
  source = "./modules/vpc"
  
  vpc_cidr_block      = var.vpc_cidr_block
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone   = var.availability_zone
  project_name        = var.project_name
}

# Security Groups - GRATUITO
module "security_groups" {
  source = "./modules/security_groups"
  
  vpc_id       = module.vpc.vpc_id
  project_name = var.project_name
  app_port     = var.app_port
}

# Instância EC2 - GRATUITO (Free Tier)
module "ec2" {
  source = "./modules/ec2"
  
  instance_type     = var.instance_type
  subnet_id         = module.vpc.public_subnet_id
  security_group_id = module.security_groups.app_sg_id
  key_name          = var.key_name
  project_name      = var.project_name
  db_host           = "localhost"  # SQLite local
  db_username       = ""           # Não usar
  db_password       = ""           # Não usar  
  db_name           = ""           # Não usar
}

# OUTPUTS - Informações importantes
output "deployment_success" {
  value = "🎉 DEPLOYMENT 100% GRATUITO CONCLUÍDO!"
  description = "Status do deployment"
}

output "access_urls" {
  value = {
    frontend    = "http://${module.ec2.public_ip}/"
    backend_api = "http://${module.ec2.public_ip}:3001/"
    health      = "http://${module.ec2.public_ip}/health"
    ssh         = "ssh -i ~/.ssh/crud-app-key.pem ec2-user@${module.ec2.public_ip}"
  }
  description = "URLs de acesso à aplicação"
}

output "cost_breakdown" {
  value = {
    ec2_instance    = "t2.micro - GRATUITO (750h/mês)"
    ebs_storage     = "8GB gp2 - GRATUITO (30GB/mês)"
    elastic_ip      = "1 IP - GRATUITO (se anexado)"
    vpc_networking  = "VPC + Subnets - GRATUITO"
    data_transfer   = "GRATUITO (1GB/mês)"
    total_monthly   = "US$ 0.00"
    database        = "SQLite Local - GRATUITO"
    node_version    = "16.x LTS - GRATUITO"
  }
  description = "💚 Detalhamento de custos (TUDO GRATUITO)"
}

output "free_tier_limits" {
  value = {
    warning = "⚠️ MONITORE PARA MANTER GRATUITO:"
    ec2_hours = "750 horas/mês t2.micro"
    storage = "30 GB EBS"
    bandwidth = "1 GB transferência/mês"
    tip = "Configure alertas de billing na AWS Console"
  }
  description = "Limites para manter no Free Tier"
}

# REMOVIDO: Qualquer referência a RDS ou serviços pagos

