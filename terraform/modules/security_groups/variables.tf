variable "vpc_id" {
  description = "ID da VPC"
}

variable "project_name" {
  description = "Nome do projeto para identificação dos recursos"
}

variable "app_port" {
  description = "Porta da aplicação Node.js"
  default     = 3001
}
