# Instância EC2 para a aplicação
resource "aws_instance" "app_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name
  
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y git nodejs npm
              echo "NODE_ENV=production" >> /etc/environment
              echo "DB_HOST=${var.db_host}" >> /etc/environment
              echo "DB_USER=${var.db_username}" >> /etc/environment
              echo "DB_PASSWORD=${var.db_password}" >> /etc/environment
              echo "DB_NAME=${var.db_name}" >> /etc/environment
              EOF
  
  tags = {
    Name = "${var.project_name}-app-server"
  }
}

# AMI mais recente do Amazon Linux 2
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Elastic IP para a instância EC2
resource "aws_eip" "app_eip" {
  instance = aws_instance.app_server.id
  domain   = "vpc"  # Alterado de 'vpc = true' para 'domain = "vpc"'
  
  tags = {
    Name = "${var.project_name}-app-eip"
  }
}
