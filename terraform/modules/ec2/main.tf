# Instância EC2 otimizada para Free Tier
resource "aws_instance" "app_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name
  
  # Configurações Free Tier - SEM CUSTOS
  monitoring                  = false  # Monitoramento detalhado é PAGO
  associate_public_ip_address = true   # IP público automático é GRATUITO
  
  # Volume raiz Free Tier - 30GB gratuitos
  root_block_device {
    volume_type           = "gp2"    # gp2 é gratuito até 30GB
    volume_size           = 8        # Bem dentro do limite gratuito
    delete_on_termination = true     # Evitar custos órfãos
    encrypted             = false    # Criptografia pode gerar custos
  }
  
  # Script corrigido com tee para evitar problemas de permissão
  user_data = <<-EOF
#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo "=========================================="
echo "Deploy GRATUITO AWS Free Tier - Node.js 16"
echo "=========================================="
              
# Atualizar sistema (gratuito)
yum update -y
yum install -y git htop

# Instalar nginx via Amazon Linux Extras (gratuito)
amazon-linux-extras install -y nginx1
              
# Instalar Node.js 16 LTS (gratuito)
curl -fsSL https://rpm.nodesource.com/setup_16.x | bash -
yum install -y nodejs
              
# Verificar versoes instaladas
echo "Node.js version: $(node --version)"
echo "NPM version: $(npm --version)"
              
# Configurar diretorios
mkdir -p /home/ec2-user/app
cd /home/ec2-user/
              
# Clonar repositorio (gratuito)
echo "Clonando repositorio GitHub..."
git clone https://github.com/Davidamascen07/CRUD-eng-software.git
cd CRUD-eng-software
              
# ==========================================
# BACKEND - 100% GRATUITO
# ==========================================
echo "Configurando backend com SQLite (gratuito)..."
cd backend
              
# Instalar dependencias
npm install --production --no-optional
              
# Configurar ambiente para producao gratuita
cat > .env << 'EOFENV'
NODE_ENV=production
PORT=3001
USE_SQLITE=true
SQLITE_PATH=/home/ec2-user/CRUD-eng-software/backend/database.sqlite
EOFENV
              
# Inicializar banco SQLite com dados exemplo
node -e "
const sqlite3 = require('sqlite3').verbose();
const db = new sqlite3.Database('./database.sqlite');
db.serialize(() => {
  db.run('CREATE TABLE IF NOT EXISTS items (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, description TEXT, status TEXT DEFAULT \"active\", createdAt DATETIME DEFAULT CURRENT_TIMESTAMP, updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP)');
  db.run('INSERT OR IGNORE INTO items (id, name, description, status) VALUES (1, \"Deploy AWS Free Tier\", \"Aplicacao rodando gratuitamente na AWS\", \"active\")');
  db.run('INSERT OR IGNORE INTO items (id, name, description, status) VALUES (2, \"Node.js 16 LTS\", \"Versao estavel e gratuita\", \"active\")');
  db.run('INSERT OR IGNORE INTO items (id, name, description, status) VALUES (3, \"SQLite Banco\", \"Banco de dados local sem custos\", \"active\")');
});
db.close();
console.log('Banco SQLite inicializado com sucesso');
"
              
# Servico systemd para backend usando tee
tee /etc/systemd/system/crud-backend.service > /dev/null << 'EOFSVC'
[Unit]
Description=CRUD Backend API - Free Tier
After=network.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=/home/ec2-user/CRUD-eng-software/backend
ExecStart=/usr/bin/node server.js
Restart=always
RestartSec=10
Environment=NODE_ENV=production
Environment=USE_SQLITE=true
Environment=PORT=3001

[Install]
WantedBy=multi-user.target
EOFSVC
              
# ==========================================
# FRONTEND - 100% GRATUITO
# ==========================================
echo "Configurando frontend React (gratuito)..."
cd ../frontend
              
# Instalar dependencias de producao
npm ci --production --no-optional
              
# Build otimizado para producao
export GENERATE_SOURCEMAP=false
export INLINE_RUNTIME_CHUNK=false
npm run build
              
# ==========================================
# NGINX - 100% GRATUITO
# ==========================================
echo "Configurando Nginx (gratuito)..."
              
# Configuracao Nginx usando tee
tee /etc/nginx/nginx.conf > /dev/null << 'EOFNGINX'
user ec2-user;
worker_processes 1;
error_log /var/log/nginx/error.log warn;
pid /run/nginx.pid;

events {
    worker_connections 512;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
    
    access_log off;
    error_log /var/log/nginx/error.log warn;
    
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 30;
    client_max_body_size 1m;
    
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml text/javascript;
    
    server {
        listen 80;
        server_name _;
        root /home/ec2-user/CRUD-eng-software/frontend/build;
        index index.html;
        
        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
        }
        
        location / {
            try_files $uri $uri/ /index.html;
        }
        
        location /api/ {
            proxy_pass http://127.0.0.1:3001;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }
        
        location /health {
            proxy_pass http://127.0.0.1:3001/health;
        }
    }
}
EOFNGINX
              
# ==========================================
# CORREÇÕES DE PERMISSÕES - AUTOMATIZADAS
# ==========================================
echo "Corrigindo permissões e configurações..."

# Dar permissões corretas para todos os diretórios
chmod 755 /home/ec2-user
chmod -R 755 /home/ec2-user/CRUD-eng-software

# Garantir que o build foi criado com sucesso
if [ ! -f "/home/ec2-user/CRUD-eng-software/frontend/build/index.html" ]; then
    echo "ERRO: Build do frontend não foi criado. Tentando novamente..."
    cd /home/ec2-user/CRUD-eng-software/frontend
    npm run build --verbose
fi

# Verificar se o build existe após tentativa
if [ ! -f "/home/ec2-user/CRUD-eng-software/frontend/build/index.html" ]; then
    echo "ERRO CRÍTICO: Não foi possível criar o build do frontend"
    exit 1
fi

# Corrigir propriedade dos arquivos
chown -R ec2-user:ec2-user /home/ec2-user/CRUD-eng-software

# Ajustar permissões específicas para Nginx
chmod -R 755 /home/ec2-user/CRUD-eng-software/frontend/build

# Verificar configuração do Nginx antes de iniciar
nginx -t
if [ $? -ne 0 ]; then
    echo "ERRO: Configuração do Nginx inválida"
    exit 1
fi

# ==========================================
# INICIALIZACAO - SEM CUSTOS EXTRAS
# ==========================================
echo "Iniciando servicos gratuitos..."
              
# Iniciar backend
systemctl daemon-reload
systemctl enable crud-backend
systemctl start crud-backend
              
# Iniciar Nginx
systemctl enable nginx
systemctl start nginx
              
# Aguardar inicializacao
sleep 15
              
# ==========================================
# VERIFICACOES FINAIS
# ==========================================
echo "Verificando deployment gratuito..."
              
# Status dos servicos
echo "=== Status Backend ==="
systemctl status crud-backend --no-pager -l
              
echo "=== Status Nginx ==="
systemctl status nginx --no-pager -l
              
# Testes de conectividade
echo "=== Teste Backend ==="
curl -s http://localhost:3001/health | head -5
              
echo "=== Teste Frontend ==="
curl -s http://localhost/ | head -5
              
# Informacoes finais
PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
echo "=========================================="
echo "DEPLOYMENT GRATUITO CONCLUIDO!"
echo "=========================================="
echo "Frontend: http://$PUBLIC_IP/"
echo "Backend:  http://$PUBLIC_IP:3001/"
echo "Health:   http://$PUBLIC_IP/health"
echo "Custos:   US$ 0.00 (Free Tier)"
echo "Banco:    SQLite Local"
echo "Node.js:  $(node --version)"
echo "=========================================="
              
# Log de sucesso
echo "$(date): Deployment FREE TIER concluido com sucesso" >> /var/log/deployment.log
EOF
  
  tags = {
    Name        = "${var.project_name}-free-tier"
    Environment = "Free-Tier"
    Cost        = "Zero"
    NodeVersion = "16.x"
    Database    = "SQLite"
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

# Elastic IP GRATUITO (1 por conta no Free Tier)
resource "aws_eip" "app_eip" {
  instance = aws_instance.app_server.id
  domain   = "vpc"
  
  tags = {
    Name = "${var.project_name}-free-eip"
    Cost = "Free"
  }
}
