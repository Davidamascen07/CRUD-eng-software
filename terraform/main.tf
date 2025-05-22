provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"
}

module "rds" {
  source = "./modules/rds"
  vpc_id         = module.vpc.vpc_id
  db_subnet_ids  = module.vpc.private_subnet_ids
}

module "ec2" {
  source = "./modules/ec2"
  vpc_id     = module.vpc.vpc_id
  subnet_id  = module.vpc.public_subnet_id
  rds_host   = module.rds.rds_endpoint
  db_user    = var.db_user
  db_pass    = var.db_password
  db_name    = var.db_name
}