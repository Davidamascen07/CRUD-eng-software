#!/bin/bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

confirm_destruction() {
    echo
    log_warn "ATENÇÃO: Esta ação irá destruir TODA a infraestrutura!"
    log_warn "Isso inclui:"
    echo "  - Instância EC2"
    echo "  - Banco de dados RDS (TODOS OS DADOS SERÃO PERDIDOS)"
    echo "  - VPC e componentes de rede"
    echo "  - Security Groups"
    echo "  - Elastic IP"
    echo
    
    read -p "Tem certeza que deseja continuar? (digite 'sim' para confirmar): " confirmation
    
    if [ "$confirmation" != "sim" ]; then
        log_info "Operação cancelada pelo usuário"
        exit 0
    fi
}

backup_data() {
    log_info "Tentando fazer backup dos dados..."
    
    cd "$PROJECT_DIR/terraform"
    
    if terraform output ec2_public_ip &> /dev/null && terraform output rds_endpoint &> /dev/null; then
        EC2_IP=$(terraform output -raw ec2_public_ip 2>/dev/null || echo "")
        RDS_ENDPOINT=$(terraform output -raw rds_endpoint 2>/dev/null || echo "")
        
        if [ -n "$EC2_IP" ] && [ -n "$RDS_ENDPOINT" ]; then
            log_info "Fazendo backup do banco de dados..."
            
            BACKUP_FILE="backup_$(date +%Y%m%d_%H%M%S).sql"
            
            ssh -i ~/.ssh/crud-app-key.pem -o StrictHostKeyChecking=no \
                ec2-user@"$EC2_IP" \
                "mysqldump -h $RDS_ENDPOINT -u crudadmin -pChangeMe123! crud_app > $BACKUP_FILE" || {
                log_warn "Falha no backup do banco de dados"
            }
            
            scp -i ~/.ssh/crud-app-key.pem -o StrictHostKeyChecking=no \
                ec2-user@"$EC2_IP":$BACKUP_FILE ./backups/ 2>/dev/null || {
                log_warn "Falha ao baixar backup"
                mkdir -p ./backups
            }
        fi
    else
        log_warn "Não foi possível obter informações da infraestrutura para backup"
    fi
}

destroy_infrastructure() {
    log_info "Destruindo infraestrutura..."
    
    cd "$PROJECT_DIR/terraform"
    
    # Show what will be destroyed
    terraform plan -destroy
    
    echo
    read -p "Confirma a destruição dos recursos acima? (digite 'DESTROY' para confirmar): " final_confirmation
    
    if [ "$final_confirmation" != "DESTROY" ]; then
        log_info "Destruição cancelada"
        exit 0
    fi
    
    # Destroy infrastructure
    terraform destroy -auto-approve
    
    log_info "Infraestrutura destruída com sucesso"
}

cleanup_local_files() {
    log_info "Limpando arquivos locais..."
    
    cd "$PROJECT_DIR/terraform"
    
    # Clean Terraform files
    rm -f terraform.tfstate*
    rm -f tfplan
    rm -rf .terraform
    
    # Clean SSH key
    rm -f ~/.ssh/crud-app-key.pem
    
    # Clean AWS key pair
    aws ec2 delete-key-pair --key-name crud-app-key 2>/dev/null || log_warn "Key pair não encontrado na AWS"
    
    log_info "Limpeza concluída"
}

main() {
    log_info "Iniciando destruição da infraestrutura..."
    
    confirm_destruction
    backup_data
    destroy_infrastructure
    cleanup_local_files
    
    echo
    log_info "=== DESTRUIÇÃO CONCLUÍDA ==="
    echo "✅ Infraestrutura destruída"
    echo "✅ Arquivos locais limpos"
    echo "✅ Chave SSH removida"
    echo
    log_info "Destruição concluída com sucesso! 🗑️"
}

main "$@"
