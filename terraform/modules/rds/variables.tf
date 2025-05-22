variable "db_subnet_group_name" {
  description = "Nome do DB subnet group"
}

variable "db_instance_class" {
  description = "Classe de instância para o RDS"
}

variable "db_name" {
  description = "Nome do banco de dados"
}

variable "db_username" {
  description = "Nome de usuário para o banco de dados"
}

variable "db_password" {
  description = "Senha para o banco de dados"
  sensitive   = true
}

variable "security_group_id" {
  description = "ID do security group para o RDS"
}

variable "project_name" {
  description = "Nome do projeto para identificação dos recursos"
}
