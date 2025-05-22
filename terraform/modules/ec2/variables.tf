variable "instance_type" {
  description = "Tipo de instância EC2"
}

variable "subnet_id" {
  description = "ID da subnet onde a instância será criada"
}

variable "security_group_id" {
  description = "ID do security group para a instância"
}

variable "key_name" {
  description = "Nome do key pair para acesso SSH"
}

variable "project_name" {
  description = "Nome do projeto para identificação dos recursos"
}

variable "db_host" {
  description = "Host do banco de dados"
  default     = "localhost"
}

variable "db_username" {
  description = "Usuário do banco de dados"
  default     = "crudadmin"
}

variable "db_password" {
  description = "Senha do banco de dados"
  default     = "ChangeMe123!"
}

variable "db_name" {
  description = "Nome do banco de dados"
  default     = "crud_app"
}
