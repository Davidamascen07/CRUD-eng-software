# Guia de Deploy CRUD Full-Stack na AWS Free Tier

## 📋 Resumo do Projeto
Deploy completo de uma aplicação CRUD full-stack na AWS usando apenas recursos gratuitos do Free Tier.

### 🛠️ Stack Tecnológica
- **Frontend**: React.js
- **Backend**: Node.js 16 LTS + Express
- **Banco de Dados**: SQLite (local)
- **Servidor Web**: Nginx (proxy reverso)
- **Infraestrutura**: AWS EC2 t2.micro
- **IaC**: Terraform

---

## 🎯 Objetivos Alcançados
✅ **Deploy 100% gratuito** - US$ 0.00 mensais  
✅ **Infraestrutura como Código** com Terraform  
✅ **Frontend React** servido pelo Nginx  
✅ **Backend Node.js** como serviço systemd  
✅ **Banco SQLite** local sem custos de RDS  
✅ **Proxy reverso** configurado para APIs  
✅ **SSL/TLS ready** (configuração preparada)  

---

## 📈 Arquitetura Final

```
Internet → AWS EC2 (t2.micro) → Nginx (porta 80)
                              ├── Frontend React (build estático)
                              └── Proxy → Backend Node.js (porta 3001)
                                         └── SQLite Database (local)
```

---

## 🚀 Passo a Passo Completo

### 1. Configuração da Infraestrutura (Terraform)

#### 1.1 Estrutura de Módulos Criada
```
terraform/
├── main.tf                    # Configuração principal
├── variables.tf               # Variáveis do projeto
├── modules/
│   ├── vpc/                   # Rede virtual privada
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── security_groups/       # Grupos de segurança
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── ec2/                   # Instância de computação
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
```

#### 1.2 Recursos AWS Criados (100% Free Tier)
- **VPC**: Rede virtual privada (10.0.0.0/16)
- **Subnets**: Pública e privada
- **Internet Gateway**: Acesso à internet
- **Security Groups**: Portas 22 (SSH), 80 (HTTP), 3001 (API)
- **EC2 t2.micro**: 750 horas gratuitas/mês
- **EBS gp2 8GB**: Dentro dos 30GB gratuitos
- **Elastic IP**: 1 IP gratuito por conta

#### 1.3 Comando de Deploy
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### 2. Configuração da Instância EC2

#### 2.1 User Data Script (Automação)
O script automatizado configura:
- Atualização do sistema Amazon Linux 2
- Instalação do Node.js 16 LTS
- Instalação do Nginx via Amazon Linux Extras
- Clone do repositório GitHub
- Configuração do backend com SQLite
- Build do frontend React
- Configuração de serviços systemd

#### 2.2 Problemas Identificados e Soluções
**Problema**: User data falhou com erro de sintaxe
```
/var/lib/cloud/instance/scripts/part-001: line 2: syntax error near unexpected token `>'
```

**Solução**: Correção da sintaxe usando `tee` para redirecionamento seguro:
```bash
# Antes (com erro)
cat > /etc/nginx/nginx.conf << 'EOF'

# Depois (corrigido)
tee /etc/nginx/nginx.conf > /dev/null << 'EOF'
```

### 3. Configuração Manual do Backend

#### 3.1 Instalação de Dependências
```bash
# Node.js 16 já estava instalado
node --version  # v16.20.2
npm --version   # 8.19.4

# Instalação do Nginx
sudo amazon-linux-extras install -y nginx1
nginx -v  # nginx/1.26.3
```

#### 3.2 Backend Node.js + SQLite
```bash
cd /home/ec2-user/CRUD-eng-software/backend
npm install --production

# Configuração do ambiente
cat > .env << 'EOF'
NODE_ENV=production
PORT=3001
USE_SQLITE=true
SQLITE_PATH=/home/ec2-user/CRUD-eng-software/backend/database.sqlite
EOF

# Inicialização do banco com dados exemplo
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
console.log('Banco SQLite inicializado');
"
```

#### 3.3 Serviço Systemd para Backend
```bash
sudo tee /etc/systemd/system/crud-backend.service > /dev/null << 'EOF'
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
EOF

sudo systemctl daemon-reload
sudo systemctl enable crud-backend
sudo systemctl start crud-backend
```

### 4. Configuração do Frontend React

#### 4.1 Build de Produção
```bash
cd /home/ec2-user/CRUD-eng-software/frontend
npm install
npm run build

# Resultado: Build otimizado em frontend/build/
# - 62.88 kB JS (main.210ca93e.js)
# - 398 B CSS (main.4c8a5a1f.css)
```

#### 4.2 Estrutura do Build
```
frontend/build/
├── index.html              # SPA principal
├── asset-manifest.json     # Manifest dos assets
└── static/
    ├── css/
    └── js/
```

### 5. Configuração do Nginx

#### 5.1 Configuração como Proxy Reverso
```bash
sudo tee /etc/nginx/nginx.conf > /dev/null << 'EOF'
user nginx;
worker_processes 1;
error_log /var/log/nginx/error.log warn;
pid /run/nginx.pid;

events {
    worker_connections 512;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
    
    # Otimizações para Free Tier
    access_log off;
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 30;
    client_max_body_size 1m;
    
    # Compressão para economizar bandwidth
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml text/javascript;
    
    server {
        listen 80;
        server_name _;
        root /home/ec2-user/CRUD-eng-software/frontend/build;
        index index.html;
        
        # Cache para arquivos estáticos
        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
        }
        
        # React SPA
        location / {
            try_files $uri $uri/ /index.html;
        }
        
        # Proxy para API backend
        location /api/ {
            proxy_pass http://127.0.0.1:3001;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }
        
        # Health check
        location /health {
            proxy_pass http://127.0.0.1:3001/health;
        }
    }
}
EOF

sudo systemctl restart nginx
```

### 6. Verificação e Testes

#### 6.1 Status dos Serviços
```bash
# Backend ativo e funcionando
sudo systemctl status crud-backend
● crud-backend.service - CRUD Backend API - Free Tier
   Loaded: loaded (/etc/systemd/system/crud-backend.service; enabled)
   Active: active (running)

# Nginx ativo e funcionando
sudo systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled)
   Active: active (running)
```

#### 6.2 Logs de Sucesso
```
Jun 01 16:30:50 node[3976]: Servidor rodando na porta 3001
Jun 01 16:30:50 node[3976]: Usando banco de dados: SQLite
Jun 01 16:30:50 node[3976]: Conectado ao SQLite: /home/ec2-user/CRUD-eng-software/backend/database.sqlite
```

---

## 🌐 URLs de Acesso

### Produção (AWS)
- **Frontend**: http://3.209.114.113/
- **Backend API**: http://3.209.114.113:3001/
- **Health Check**: http://3.209.114.113/health
- **SSH**: `ssh -i ~/.ssh/crud-app-key.pem ec2-user@3.209.114.113`

### Rotas da API
- `GET /api/items` - Listar todos os items
- `POST /api/items` - Criar novo item
- `PUT /api/items/:id` - Atualizar item
- `DELETE /api/items/:id` - Deletar item
- `GET /health` - Status da aplicação

---

## 💰 Análise de Custos (Free Tier)

### Recursos Utilizados (GRATUITOS)
| Recurso | Especificação | Limite Free Tier | Uso Atual | Custo |
|---------|---------------|------------------|-----------|--------|
| EC2 t2.micro | 1 vCPU, 1GB RAM | 750 horas/mês | 24/7 = 720h | $0.00 |
| EBS gp2 | 8GB storage | 30GB/mês | 8GB | $0.00 |
| Elastic IP | IP público | 1 IP (se anexado) | 1 IP | $0.00 |
| VPC | Rede virtual | Ilimitado | 1 VPC | $0.00 |
| Data Transfer | Saída | 1GB/mês | <1GB/mês | $0.00 |
| **TOTAL MENSAL** | | | | **$0.00** |

### Monitoramento Recomendado
⚠️ **Configurar alertas de billing para monitorar**:
- EC2: Não exceder 750 horas/mês
- Storage: Manter abaixo de 30GB
- Data Transfer: Monitorar uso de bandwidth

---

## 🔧 Comandos Úteis de Manutenção

### Monitoramento
```bash
# Status dos serviços
sudo systemctl status crud-backend nginx

# Logs em tempo real
sudo journalctl -u crud-backend -f
sudo tail -f /var/log/nginx/error.log

# Verificar portas
sudo netstat -tlnp | grep -E ':(80|3001)'

# Processos Node.js
ps aux | grep node
```

### Reinicialização
```bash
# Reiniciar backend
sudo systemctl restart crud-backend

# Reiniciar Nginx
sudo systemctl restart nginx

# Verificar configuração Nginx
sudo nginx -t
```

### Backup do Banco
```bash
# Backup do SQLite
cp /home/ec2-user/CRUD-eng-software/backend/database.sqlite /tmp/backup_$(date +%Y%m%d).sqlite

# Verificar dados
sqlite3 /home/ec2-user/CRUD-eng-software/backend/database.sqlite "SELECT * FROM items;"
```

---

## 🚀 Próximos Passos (Melhorias Futuras)

### Segurança
- [ ] Implementar HTTPS com Let's Encrypt (gratuito)
- [ ] Configurar firewall mais restritivo
- [ ] Implementar autenticação JWT

### Performance
- [ ] Configurar cache Redis (quando necessário)
- [ ] Implementar CDN para assets estáticos
- [ ] Otimizar queries SQL

### Monitoramento
- [ ] Implementar logs estruturados
- [ ] Configurar métricas básicas
- [ ] Alertas de saúde da aplicação

### CI/CD
- [ ] GitHub Actions para deploy automático
- [ ] Testes automatizados
- [ ] Deploy blue-green

---

## 📝 Conclusão

✅ **Deploy realizado com sucesso** - Aplicação CRUD full-stack funcionando na AWS  
✅ **Custo zero** - Utilizando apenas recursos do Free Tier  
✅ **Infraestrutura escalável** - Pronta para crescimento futuro  
✅ **Código versionado** - Terraform e aplicação no GitHub  

### Tecnologias Dominadas
- **Terraform** para IaC
- **AWS EC2** e recursos Free Tier
- **Node.js** em produção com systemd
- **React** build otimizado
- **Nginx** como proxy reverso
- **SQLite** para persistência local

### Lições Aprendidas
1. **User data scripts** requerem cuidado com sintaxe de redirecionamento
2. **Amazon Linux Extras** é necessário para pacotes como nginx
3. **Systemd** é essencial para serviços em produção
4. **Terraform** simplifica muito o gerenciamento de infraestrutura
5. **Free Tier** da AWS permite projetos reais sem custos

---

**Status Final**: 🎉 **DEPLOYMENT CONCLUÍDO COM SUCESSO!**
