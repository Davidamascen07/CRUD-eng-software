# Security Group para a aplicação - 100% GRATUITO
resource "aws_security_group" "app_sg" {
  name        = "${var.project_name}-app-sg"
  description = "Security Group GRATUITO para aplicacao CRUD"
  vpc_id      = var.vpc_id

  # SSH (porta 22) - GRATUITO
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  # HTTP Frontend (porta 80) - GRATUITO
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP Frontend React"
  }

  # Backend API (porta 3001) - GRATUITO
  ingress {
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Backend API Node.js"
  }

  # Todo trafego de saida - GRATUITO
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = {
    Name        = "${var.project_name}-app-sg"
    Environment = "Free-Tier"
    Cost        = "US$ 0.00"
  }
}
