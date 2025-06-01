# Security Group para a aplicação
resource "aws_security_group" "app" {
  vpc_id      = var.vpc_id
  name        = "${var.project_name}-app-sg"
  description = "Permitir tráfego para a aplicação CRUD"

  # Regra para SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH de qualquer lugar"
  }

  # Regra para HTTP na porta da aplicação (3001)
  ingress {
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Acesso HTTP à aplicação"
  }

  # Permitir todo tráfego de saída
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Permitir todo tráfego de saída"
  }

  tags = {
    Name = "${var.project_name}-app-sg"
  }
}

output "app_sg_id" {
  value = aws_security_group.app.id
}
