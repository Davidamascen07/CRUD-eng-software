variable "aws_region" {
  description = "Região da AWS onde os recursos serão criados"
  default     = "us-east-1"  # Corrigido para us-east-1 onde a chave existe
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
  default     = "us-east-1a"  # Corrigido para us-east-1a
}

variable "instance_type" {
  description = "Tipo de instância EC2"
  default     = "t2.micro"  # Free Tier - 750 horas/mês grátis
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

variable "app_port" {
  description = "Porta da aplicação"
  default     = 3001
}

variable "frontend_port" {
  description = "Porta do frontend React"
  default     = 3000
}

variable "github_repo" {
  description = "URL do repositório GitHub"
  default     = "https://github.com/Davidamascen07/CRUD-eng-software.git"
}

variable "node_version" {
  description = "Versão do Node.js"
  default     = "16"  # Mantendo versão 16 como solicitado
}

variable "use_rds" {
  description = "Usar RDS ou SQLite local"
  default     = false  # Manter false para evitar custos do RDS
}

variable "use_sqlite" {
  description = "Usar SQLite como banco de dados padrão"
  default     = true  # SQLite é gratuito e local
}

variable "sqlite_path" {
  description = "Caminho do arquivo SQLite na instância"
  default     = "/home/ec2-user/CRUD-eng-software/backend/database.sqlite"  # Corrigir caminho
}

variable "local_test_mode" {
  description = "Modo de teste local (não criar recursos AWS)"
  default     = false
}

variable "local_sqlite_path" {
  description = "Caminho do SQLite para teste local"
  default     = "./database.sqlite"
}

variable "enable_monitoring" {
  description = "Habilitar monitoramento detalhado (pode gerar custos)"
  default     = false
}

variable "delete_on_termination" {
  description = "Deletar volumes EBS ao terminar a instância"
  default     = true  # Evitar custos de armazenamento órfão
}

variable "health_check_path" {
  description = "Caminho para health check da aplicação"
  default     = "/health"
}

variable "auto_scaling" {
  description = "Habilitar auto scaling (pode gerar custos)"
  default     = false
}

variable "backup_enabled" {
  description = "Habilitar backup automático do SQLite"
  default     = true
}
