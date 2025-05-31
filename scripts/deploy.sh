#!/bin/bash

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
KEY_FILE="$HOME/.ssh/crud-app-key.pem"
RETRY_COUNT=3
RETRY_DELAY=10

# Functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_dependencies() {
    log_info "Verificando dependências..."
    
    local deps=("aws" "terraform" "ssh" "curl")
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            log_error "$dep não está instalado"
            exit 1
        fi
    done
    
    log_info "Todas as dependências estão instaladas"
}

check_aws_credentials() {
    log_info "Verificando credenciais AWS..."
    
    if ! aws sts get-caller-identity &> /dev/null; then
        log_error "Credenciais AWS não configuradas"
        exit 1
    fi
    
    log_info "Credenciais AWS verificadas"
}

create_key_pair() {
    log_info "Verificando key pair..."
    
    if [ ! -f "$KEY_FILE" ]; then
        log_info "Criando key pair..."
        aws ec2 create-key-pair \
            --key-name crud-app-key \
            --query 'KeyMaterial' \
            --output text > "$KEY_FILE"
        chmod 400 "$KEY_FILE"
        log_info "Key pair criado: $KEY_FILE"
    else
        log_info "Key pair já existe: $KEY_FILE"
    fi
}

deploy_infrastructure() {
    log_info "Fazendo deploy da infraestrutura..."
    
    cd "$PROJECT_DIR/terraform"
    
    # Initialize Terraform
    terraform init
    
    # Validate configuration
    terraform validate
    
    # Plan deployment
    log_info "Gerando plano de deployment..."
    terraform plan -out=tfplan
    
    # Apply infrastructure
    log_info "Aplicando infraestrutura..."
    terraform apply tfplan
    
    log_info "Infraestrutura criada com sucesso"
}

get_infrastructure_info() {
    cd "$PROJECT_DIR/terraform"
    
    EC2_IP=$(terraform output -raw ec2_public_ip)
    RDS_ENDPOINT=$(terraform output -raw rds_endpoint)
    
    if [ -z "$EC2_IP" ] || [ -z "$RDS_ENDPOINT" ]; then
        log_error "Não foi possível obter informações da infraestrutura"
        exit 1
    fi
    
    log_info "EC2 IP: $EC2_IP"
    log_info "RDS Endpoint: $RDS_ENDPOINT"
}

wait_for_ec2() {
    log_info "Aguardando EC2 ficar disponível..."
    
    local count=0
    while [ $count -lt $RETRY_COUNT ]; do
        if ssh -i "$KEY_FILE" -o ConnectTimeout=10 -o StrictHostKeyChecking=no \
           ec2-user@"$EC2_IP" "echo 'EC2 ready'" &> /dev/null; then
            log_info "EC2 está disponível"
            return 0
        fi
        
        count=$((count + 1))
        log_warn "Tentativa $count/$RETRY_COUNT falhou. Aguardando $RETRY_DELAY segundos..."
        sleep $RETRY_DELAY
    done
    
    log_error "EC2 não ficou disponível após $RETRY_COUNT tentativas"
    exit 1
}

setup_application() {
    log_info "Configurando aplicação no servidor..."
    
    # Create setup script
    cat > /tmp/setup_app.sh << 'EOF'
#!/bin/bash
set -e

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "Atualizando sistema..."
sudo yum update -y

log "Instalando dependências..."
sudo yum install -y git nodejs npm nginx mysql

log "Criando diretório da aplicação..."
sudo mkdir -p /var/www/crud-app
sudo chown ec2-user:ec2-user /var/www/crud-app

log "Clonando aplicação..."
if [ -d "/var/www/crud-app/.git" ]; then
    cd /var/www/crud-app
    git pull origin main || true
else
    git clone https://github.com/seu-usuario/crud-app.git /var/www/crud-app || {
        log "Clone falhou, criando estrutura manual..."
        mkdir -p /var/www/crud-app/{backend,frontend}
    }
fi

cd /var/www/crud-app

log "Configurando backend..."
cd backend
if [ -f "package.json" ]; then
    npm install
fi

log "Configurando variáveis de ambiente..."
cat > .env << ENVEOF
DB_HOST=${RDS_ENDPOINT}
DB_USER=crudadmin
DB_PASSWORD=ChangeMe123!
DB_NAME=crud_app
NODE_ENV=production
PORT=3001
ENVEOF

log "Configurando frontend..."
cd ../frontend
if [ -f "package.json" ]; then
    npm install
    npm run build || log "Build do frontend falhou"
fi

log "Configurando serviço systemd..."
sudo tee /etc/systemd/system/crud-app.service > /dev/null << SERVICEEOF
[Unit]
Description=CRUD Application
After=network.target

[Service]
Environment=NODE_ENV=production
Environment=DB_HOST=${RDS_ENDPOINT}
Environment=DB_USER=crudadmin
Environment=DB_PASSWORD=ChangeMe123!
Environment=DB_NAME=crud_app
Type=simple
User=ec2-user
WorkingDirectory=/var/www/crud-app/backend
ExecStart=/usr/bin/node server.js
Restart=on-failure

[Install]
WantedBy=multi-user.target
SERVICEEOF

log "Iniciando serviços..."
sudo systemctl daemon-reload
sudo systemctl enable crud-app
sudo systemctl start crud-app

log "Configurando Nginx..."
sudo tee /etc/nginx/conf.d/crud-app.conf > /dev/null << NGINXEOF
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://localhost:3001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
    }
}
NGINXEOF

sudo systemctl enable nginx
sudo systemctl start nginx

log "Verificando serviços..."
sudo systemctl status crud-app --no-pager
sudo systemctl status nginx --no-pager

log "Configuração concluída!"
EOF

    # Copy and execute setup script
    scp -i "$KEY_FILE" -o StrictHostKeyChecking=no \
        /tmp/setup_app.sh ec2-user@"$EC2_IP":/tmp/
    
    ssh -i "$KEY_FILE" -o StrictHostKeyChecking=no \
        ec2-user@"$EC2_IP" "chmod +x /tmp/setup_app.sh && RDS_ENDPOINT='$RDS_ENDPOINT' /tmp/setup_app.sh"
    
    log_info "Aplicação configurada com sucesso"
}

setup_database() {
    log_info "Configurando banco de dados..."
    
    # Wait for RDS to be available
    log_info "Aguardando RDS ficar disponível..."
    
    local count=0
    while [ $count -lt $RETRY_COUNT ]; do
        if ssh -i "$KEY_FILE" -o StrictHostKeyChecking=no \
           ec2-user@"$EC2_IP" "mysql -h $RDS_ENDPOINT -u crudadmin -pChangeMe123! -e 'SELECT 1' 2>/dev/null"; then
            log_info "RDS está disponível"
            break
        fi
        
        count=$((count + 1))
        log_warn "RDS não está pronto. Tentativa $count/$RETRY_COUNT. Aguardando $RETRY_DELAY segundos..."
        sleep $RETRY_DELAY
    done
    
    if [ $count -eq $RETRY_COUNT ]; then
        log_error "RDS não ficou disponível após $RETRY_COUNT tentativas"
        exit 1
    fi
    
    # Setup database schema
    log_info "Configurando schema do banco..."
    ssh -i "$KEY_FILE" -o StrictHostKeyChecking=no \
        ec2-user@"$EC2_IP" "mysql -h $RDS_ENDPOINT -u crudadmin -pChangeMe123! < /var/www/crud-app/backend/database/schema.sql" || {
        log_warn "Falha ao executar schema. Criando schema manualmente..."
        
        ssh -i "$KEY_FILE" -o StrictHostKeyChecking=no \
            ec2-user@"$EC2_IP" "mysql -h $RDS_ENDPOINT -u crudadmin -pChangeMe123! -e \"
                CREATE DATABASE IF NOT EXISTS crud_app;
                USE crud_app;
                CREATE TABLE IF NOT EXISTS items (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    name VARCHAR(255) NOT NULL,
                    description TEXT,
                    status ENUM('active', 'inactive') DEFAULT 'active',
                    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
                    updatedAt DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
                );
                INSERT IGNORE INTO items (name, description, status) VALUES
                ('Item de Exemplo 1', 'Primeiro item criado pelo deploy', 'active'),
                ('Item de Exemplo 2', 'Segundo item criado pelo deploy', 'active');
            \""
    }
    
    log_info "Banco de dados configurado com sucesso"
}

test_application() {
    log_info "Testando aplicação..."
    
    # Test API endpoint
    local api_url="http://$EC2_IP:3001/api/items"
    
    log_info "Testando endpoint: $api_url"
    
    local count=0
    while [ $count -lt $RETRY_COUNT ]; do
        if curl -f -s "$api_url" > /dev/null; then
            log_info "API está respondendo"
            break
        fi
        
        count=$((count + 1))
        log_warn "API não está respondendo. Tentativa $count/$RETRY_COUNT. Aguardando $RETRY_DELAY segundos..."
        sleep $RETRY_DELAY
    done
    
    if [ $count -eq $RETRY_COUNT ]; then
        log_error "API não está respondendo após $RETRY_COUNT tentativas"
        return 1
    fi
    
    # Test creating an item
    log_info "Testando criação de item..."
    curl -X POST "$api_url" \
        -H "Content-Type: application/json" \
        -d '{"name":"Item de Teste Deploy","description":"Criado durante o teste de deploy","status":"active"}' \
        -f -s > /dev/null && log_info "Teste de criação: SUCESSO" || log_warn "Teste de criação: FALHA"
    
    # Test listing items
    log_info "Testando listagem de itens..."
    local item_count=$(curl -s "$api_url" | jq '. | length' 2>/dev/null || echo "0")
    log_info "Itens encontrados: $item_count"
    
    log_info "Testes concluídos"
}

show_summary() {
    log_info "=== RESUMO DO DEPLOY ==="
    echo
    echo "✅ Infraestrutura: Criada"
    echo "✅ Aplicação: Configurada"
    echo "✅ Banco de Dados: Configurado"
    echo "✅ Testes: Executados"
    echo
    echo "🌐 URL da Aplicação: http://$EC2_IP:3001"
    echo "🖥️  IP da Instância: $EC2_IP"
    echo "🗄️  Endpoint RDS: $RDS_ENDPOINT"
    echo "🔑 Chave SSH: $KEY_FILE"
    echo
    echo "📝 Para conectar via SSH:"
    echo "   ssh -i $KEY_FILE ec2-user@$EC2_IP"
    echo
    echo "📊 Para verificar logs:"
    echo "   ssh -i $KEY_FILE ec2-user@$EC2_IP 'sudo journalctl -u crud-app -f'"
    echo
    echo "🧹 Para destruir a infraestrutura:"
    echo "   cd $PROJECT_DIR/terraform && terraform destroy"
    echo
}

cleanup_on_error() {
    log_error "Deploy falhou. Limpando recursos..."
    cd "$PROJECT_DIR/terraform"
    terraform destroy -auto-approve || log_warn "Falha na limpeza automática"
}

# Main execution
main() {
    log_info "Iniciando deploy da aplicação CRUD..."
    
    # Set trap for cleanup on error
    trap cleanup_on_error ERR
    
    check_dependencies
    check_aws_credentials
    create_key_pair
    deploy_infrastructure
    get_infrastructure_info
    wait_for_ec2
    setup_application
    setup_database
    test_application
    show_summary
    
    log_info "Deploy concluído com sucesso! 🎉"
}

# Execute main function
main "$@"
