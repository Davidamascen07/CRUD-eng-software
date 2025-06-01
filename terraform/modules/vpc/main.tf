# VPC - GRATUITA
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  
  tags = {
    Name = "${var.project_name}-vpc"
    Cost = "Free"
  }
}

# Subnet pública - GRATUITA
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
  
  tags = {
    Name = "${var.project_name}-public-subnet"
    Cost = "Free"
  }
}

# Subnet privada - GRATUITA (mas não usada para evitar custos de NAT)
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone
  
  tags = {
    Name = "${var.project_name}-private-subnet"
    Cost = "Free"
    Usage = "Reserved-Not-Used"
  }
}

# Internet Gateway - GRATUITO
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name = "${var.project_name}-igw"
    Cost = "Free"
  }
}

# Route Table - GRATUITA
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  
  tags = {
    Name = "${var.project_name}-public-rt"
    Cost = "Free"
  }
}

# Route Table Association - GRATUITA
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# REMOVIDO: DB Subnet Group (não necessário para SQLite)
# REMOVIDO: Segunda subnet privada (não necessária para Free Tier)
