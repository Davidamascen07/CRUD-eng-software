# Guia de Deployment - CRUD Application

## 🎯 Visão Geral

Este guia fornece instruções detalhadas para fazer o deploy da aplicação CRUD na AWS usando Terraform.

## 🔧 Configuração Inicial

### 1. Pré-requisitos

Certifique-se de ter instalado:

```bash
# Verificar versões
aws --version          # >= 2.0
terraform --version    # >= 1.0
node --version         # >= 16.0
ansible --version      # >= 2.9 (opcional)
```

### 2. Configuração da AWS

```bash
# Configure suas credenciais
aws configure set aws_access_key_id YOUR_ACCESS_KEY
aws configure set aws_secret_access_key YOUR_SECRET_KEY
aws configure set default.region us-east-2
aws configure set default.output json

# Teste a conexão
aws sts get-caller-identity
```

### 3. Preparação do Key Pair

```bash
# Criar key pair
aws ec2 create-key-pair \
  --key-name crud-app-key \
  --query 'KeyMaterial' \
  --output text > ~/.ssh/crud-app-key.pem

# Configurar permissões
chmod 400 ~/.ssh/crud-app-key.pem

# Verificar se foi criado
aws ec2 describe-key-pairs --key-names crud-app-key
```

## 🚀 Deploy com Terraform

### 1. Inicialização

```bash
cd terraform

# Inicializar
terraform init

# Verificar formatação
terraform fmt -recursive

# Validar configuração
terraform validate
```

### 2. Planejamento

```bash
# Visualizar mudanças
terraform plan

# Salvar plano (opcional)
terraform plan -out=tfplan

# Visualizar recursos
terraform show tfplan
```

### 3. Aplicação

```bash
# Aplicar infraestrutura
terraform apply

# Ou usar plano salvo
terraform apply tfplan

# Confirmar com 'yes'
```

### 4. Verificação

```bash
# Ver outputs
terraform output

# Específicos
terraform output ec2_public_ip
terraform output rds_endpoint

# Estado dos recursos
terraform state list
terraform show
```

## 🔄 Configuração da Aplicação

### Método 1: Script Automático

```bash
# Usar script de deploy
chmod +x scripts/deploy.sh
./scripts/deploy.sh $(terraform output -raw ec2_public_ip)
```

### Método 2: Manual

```bash
# Conectar na instância
EC2_IP=$(terraform output -raw ec2_public_ip)
ssh -i ~/.ssh/crud-app-key.pem ec2-user@$EC2_IP

# Configurar aplicação
sudo yum update -y
sudo yum install -y git nodejs npm nginx

# Clonar projeto
git clone https://github.com/seu-usuario/crud-app.git /home/ec2-user/app
cd /home/ec2-user/app

# Configurar backend
cd backend
npm install

# Criar arquivo de ambiente
cat > .env << EOF
DB_HOST=$(terraform output -raw rds_endpoint)
DB_USER=crudadmin
DB_PASSWORD=ChangeMe123!
DB_NAME=crud_app
NODE_ENV=production
PORT=3001
EOF

# Iniciar aplicação
npm start &

# Configurar frontend
cd ../frontend
npm install
npm run build
```

### Método 3: Ansible

```bash
# Configurar inventory
cd ansible
echo "[app_servers]" > inventory.ini
echo "crud-server ansible_host=$(terraform output -raw ec2_public_ip) ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/crud-app-key.pem" >> inventory.ini

# Executar playbook
ansible-playbook -i inventory.ini playbook.yml
```

## 🗄️ Configuração do Banco

### 1. Conectar no RDS

```bash
# Instalar cliente MySQL
sudo yum install -y mysql

# Conectar
RDS_ENDPOINT=$(terraform output -raw rds_endpoint)
mysql -h $RDS_ENDPOINT -u crudadmin -p
```

### 2. Executar Schema

```sql
-- Criar banco (se não existir)
CREATE DATABASE IF NOT EXISTS crud_app;
USE crud_app;

-- Executar schema
source backend/database/schema.sql;

-- Verificar
SHOW TABLES;
SELECT COUNT(*) FROM items;
```

## ✅ Validação do Deploy

### 1. Testes de Conectividade

```bash
# Testar EC2
curl -I http://$(terraform output -raw ec2_public_ip):3001

# Testar API
curl http://$(terraform output -raw ec2_public_ip):3001/api/items

# Testar banco
mysql -h $(terraform output -raw rds_endpoint) -u crudadmin -p -e "SELECT 1"
```

### 2. Testes Funcionais

```bash
# Criar item via API
curl -X POST http://$(terraform output -raw ec2_public_ip):3001/api/items \
  -H "Content-Type: application/json" \
  -d '{"name":"Teste Deploy","description":"Item criado via API","status":"active"}'

# Listar itens
curl http://$(terraform output -raw ec2_public_ip):3001/api/items
```

### 3. Verificação de Logs

```bash
# Logs da aplicação
ssh -i ~/.ssh/crud-app-key.pem ec2-user@$(terraform output -raw ec2_public_ip) \
  "sudo journalctl -u crud-app -f"

# Logs do sistema
ssh -i ~/.ssh/crud-app-key.pem ec2-user@$(terraform output -raw ec2_public_ip) \
  "sudo tail -f /var/log/cloud-init-output.log"
```

## 🔧 Configurações Avançadas

### 1. SSL/TLS

```bash
# Instalar Certbot
sudo yum install -y certbot python3-certbot-nginx

# Obter certificado (substitua pelo seu domínio)
sudo certbot --nginx -d seu-dominio.com

# Verificar renovação
sudo certbot renew --dry-run
```

### 2. Firewall

```bash
# Configurar iptables
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Salvar regras
sudo service iptables save
```

### 3. Monitoramento

```bash
# Instalar htop
sudo yum install -y htop

# Configurar CloudWatch Agent
wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
sudo rpm -U ./amazon-cloudwatch-agent.rpm
```

## 🔄 Atualizações

### 1. Atualização de Código

```bash
# No servidor
cd /home/ec2-user/app
git pull origin main
cd backend && npm install
cd ../frontend && npm install && npm run build
sudo systemctl restart crud-app
```

### 2. Atualização de Infraestrutura

```bash
# Modificar arquivos .tf
terraform plan
terraform apply

# Em caso de mudanças na EC2
terraform taint aws_instance.app_server
terraform apply
```

## 🛡️ Backup e Recuperação

### 1. Backup do Banco

```bash
# Script de backup
cat > backup.sh << 'EOF'
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
RDS_ENDPOINT=$(terraform output -raw rds_endpoint)
mysqldump -h $RDS_ENDPOINT -u crudadmin -p crud_app > backup_$DATE.sql
aws s3 cp backup_$DATE.sql s3://seu-bucket-backup/
EOF

chmod +x backup.sh
```

### 2. Backup de Arquivos

```bash
# Backup da aplicação
tar -czf app_backup_$(date +%Y%m%d).tar.gz /home/ec2-user/app
aws s3 cp app_backup_$(date +%Y%m%d).tar.gz s3://seu-bucket-backup/
```

## 🚨 Troubleshooting

### Problemas Comuns

1. **Terraform apply falha**:
   ```bash
   # Verificar estado
   terraform state list
   terraform state show aws_instance.app_server
   
   # Limpar cache
   rm -rf .terraform
   terraform init
   ```

2. **EC2 não responde**:
   ```bash
   # Verificar security groups
   aws ec2 describe-security-groups --group-ids sg-xxxxxxxxx
   
   # Verificar instância
   aws ec2 describe-instances --instance-ids i-xxxxxxxxx
   ```

3. **RDS não conecta**:
   ```bash
   # Testar conectividade
   telnet $(terraform output -raw rds_endpoint) 3306
   
   # Verificar security group
   aws rds describe-db-instances --db-instance-identifier crud-app-mysql
   ```

### Logs Importantes

```bash
# Terraform
terraform apply 2>&1 | tee terraform.log

# Cloud-init
sudo cat /var/log/cloud-init-output.log

# Aplicação
sudo journalctl -u crud-app -f

# Sistema
sudo tail -f /var/log/messages
```

## 📊 Monitoramento de Custos

```bash
# Verificar custos
aws ce get-cost-and-usage \
  --time-period Start=2023-11-01,End=2023-12-01 \
  --granularity MONTHLY \
  --metrics BlendedCost

# Alertas de billing
aws budgets create-budget \
  --account-id $(aws sts get-caller-identity --query Account --output text) \
  --budget file://budget.json
```

## 🧹 Limpeza

### Destruir Infraestrutura

```bash
# Destruir tudo
terraform destroy

# Ou específicos
terraform destroy -target=aws_instance.app_server
terraform destroy -target=aws_db_instance.mysql

# Confirmar com 'yes'
```

### Limpeza Manual

```bash
# Limpar key pairs
aws ec2 delete-key-pair --key-name crud-app-key
rm ~/.ssh/crud-app-key.pem

# Limpar arquivos locais
rm -rf .terraform
rm terraform.tfstate*
```
