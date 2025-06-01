output "app_sg_id" {
  value       = aws_security_group.app_sg.id
  description = "ID do Security Group da aplicação"
}

# Removido db_sg_id para evitar custos de RDS
# Como estamos usando SQLite local, não precisamos de security group para banco
