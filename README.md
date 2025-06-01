# CRUD App - Engenharia de Software

## 📋 Especificações Atendidas

✅ **CRUD Completo**: Cadastro, consulta, edição e exclusão  
✅ **Interface Gráfica**: React + Tailwind CSS responsivo  
✅ **Terraform**: Deploy automatizado AWS Free Tier  
✅ **DevOps Ready**: Modularizado e escalável  
✅ **Versionamento Git**: Código fonte versionado  
✅ **Documentação**: Guia completo de execução  

## 📦 Estrutura do Projeto

```
CRUD-eng-software/
├── backend/           # API Node.js + Express + SQLite
├── frontend/          # Interface React + Tailwind
├── terraform/         # Infraestrutura AWS modularizada
├── docs/             # Documentação adicional
├── .gitignore        # Arquivos ignorados pelo Git
├── package.json      # Dependências do projeto
└── README.md         # Este arquivo
```

## 🔄 Versionamento Git

### Configuração Inicial
```bash
# Clonar repositório
git clone https://github.com/Davidamascen07/CRUD-eng-software.git
cd CRUD-eng-software

# Verificar status
git status
git log --oneline -10
```

### Workflow de Desenvolvimento
```bash
# Criar nova feature
git checkout -b feature/nova-funcionalidade
git add .
git commit -m "feat: adicionar nova funcionalidade"
git push origin feature/nova-funcionalidade

# Merge para main
git checkout main
git merge feature/nova-funcionalidade
git push origin main
```

### Branches Organizadas
- `main`: Código de produção estável
- `develop`: Desenvolvimento ativo
- `feature/*`: Novas funcionalidades
- `hotfix/*`: Correções urgentes

## 🚀 Deploy Rápido

```bash
# 1. Configurar AWS CLI
aws configure

# 2. Deploy automatizado com correções
cd terraform
terraform init
terraform plan
terraform apply -auto-approve

# 3. Aguardar deploy completo (8-12 minutos)
# O script agora corrige automaticamente:
# ✅ Permissões do Nginx
# ✅ Build do frontend
# ✅ Propriedade dos arquivos
# ✅ Configurações de segurança

# 4. Verificar aplicação
terraform output
```

## ✅ Correções Implementadas

### Problemas Resolvidos Automaticamente:
- **Nginx User**: Alterado para `ec2-user` automaticamente
- **Permissões**: `chmod 755` aplicado recursivamente
- **Build Frontend**: Verificação e recriação automática se necessário
- **Propriedade Arquivos**: `chown ec2-user:ec2-user` aplicado
- **Validação Nginx**: Teste de configuração antes de iniciar
- **ESLint Warning**: Dependência do useEffect corrigida

### Script de Deploy Robusto:
```bash
# O deploy agora inclui verificações automáticas:
✅ Verificar se build existe
✅ Recriar build se necessário
✅ Corrigir permissões automaticamente
✅ Validar configuração Nginx
✅ Logs detalhados de cada etapa
```

## 🏗️ Arquitetura

- **Frontend**: React + Tailwind CSS
- **Backend**: Node.js + Express + SQLite
- **Infraestrutura**: AWS Free Tier
- **Deploy**: Terraform + user-data automation

## 💰 Custos

**US$ 0.00** - 100% Free Tier AWS

### ✅ Análise de Custos das Correções

**TODAS as correções implementadas são 100% GRATUITAS:**

#### Correções que NÃO geram custos:
- ✅ **Alteração do usuário Nginx**: Apenas configuração de software
- ✅ **Permissões de arquivos (chmod/chown)**: Operações do sistema operacional
- ✅ **Build do frontend**: Processamento local na instância
- ✅ **Validação de configuração**: Comandos de verificação
- ✅ **Logs detalhados**: Gravação em arquivos locais
- ✅ **Headers de segurança**: Configuração de software
- ✅ **Middleware adicional**: Código Node.js

#### Por que são gratuitas:
- **Sem recursos AWS adicionais**: Usamos apenas a instância EC2 já provisionada
- **Sem transferência de dados extra**: Correções são locais
- **Sem armazenamento adicional**: Logs e builds usam o mesmo volume EBS
- **Sem serviços pagos**: Todas as operações são do sistema operacional Linux

#### Recursos Free Tier utilizados:
```bash
# Instância EC2 t2.micro: 750 horas/mês GRÁTIS
# Volume EBS 8GB: Dentro dos 30GB gratuitos
# Elastic IP: 1 IP gratuito por conta
# Transferência: Primeiros 15GB/mês gratuitos
# Monitoramento básico: Sempre gratuito
```

#### Custos potenciais EVITADOS pelas correções:
- **Sem CloudWatch Logs**: US$ 0.50/GB - Usamos logs locais
- **Sem Load Balancer**: US$ 16.20/mês - Nginx local
- **Sem RDS**: US$ 12.41/mês - SQLite local
- **Sem S3 para assets**: CDN grátis para CSS/JS

### 🔒 Garantia Free Tier

**ZERO custos adicionais garantidos:**
- Todas as melhorias são otimizações de software
- Nenhum recurso AWS extra é provisionado
- Deploy permanece 100% dentro do Free Tier
- Correções melhoram performance SEM custos

## 📊 Funcionalidades

- [x] Create (Criar itens)
- [x] Read (Listar/Buscar itens)  
- [x] Update (Editar itens)
- [x] Delete (Excluir itens)
- [x] Filtros e busca
- [x] Paginação
- [x] Interface responsiva

## 🛠️ Execução do Sistema

### Pré-requisitos
```bash
# Verificar versões necessárias
node --version    # >= 16.0.0
npm --version     # >= 8.0.0
git --version     # >= 2.0.0
```

### 1. Setup Inicial
```bash
# Clonar e entrar no projeto
git clone https://github.com/Davidamascen07/CRUD-eng-software.git
cd CRUD-eng-software

# Instalar dependências raiz (se houver)
npm install
```

### 2. Backend (Desenvolvimento)
```bash
# Navegar para backend
cd backend

# Instalar dependências
npm install

# Configurar ambiente (opcional)
cp .env.example .env
# Editar .env conforme necessário

# Iniciar servidor de desenvolvimento
npm run dev
# ou
npm start

# Servidor rodará em: http://localhost:3001
```

### 3. Frontend (Desenvolvimento)
```bash
# Em novo terminal, navegar para frontend
cd frontend

# Instalar dependências
npm install

# Iniciar servidor de desenvolvimento
npm start

# Aplicação abrirá em: http://localhost:3000
```

### 4. Verificação de Funcionamento
```bash
# Testar backend
curl http://localhost:3001/health

# Testar frontend
# Abrir http://localhost:3000 no navegador
```

## 🐳 Execução com Docker (Opcional)

### Backend
```bash
# Construir imagem
cd backend
docker build -t crud-backend .

# Executar container
docker run -p 3001:3001 crud-backend
```

### Frontend
```bash
# Construir imagem
cd frontend
docker build -t crud-frontend .

# Executar container
docker run -p 3000:3000 crud-frontend
```

## ☁️ Deploy AWS com Terraform

### Pré-requisitos AWS
```bash
# Instalar AWS CLI
# Windows: Download do site oficial
# macOS: brew install awscli
# Linux: apt-get install awscli

# Configurar credenciais
aws configure
# AWS Access Key ID: [sua-key]
# AWS Secret Access Key: [sua-secret]
# Default region: us-east-1
# Default output format: json

# Verificar configuração
aws sts get-caller-identity
```

### Deploy Completo
```bash
# Navegar para terraform
terraform destroy

# Inicializar Terraform
terraform init

# Verificar plano de execução
terraform plan

# Aplicar infraestrutura
terraform apply
# Digite 'yes' para confirmar

# Aguardar conclusão (5-10 minutos)
# URLs serão exibidas no final
```

### Verificação do Deploy
```bash
# Obter outputs importantes
terraform output

# Testar aplicação
curl http://[IP-PUBLICO]/health
```

### Limpeza de Recursos
```bash
# Destruir infraestrutura
terraform destroy
# Digite 'yes' para confirmar
```

## 🔧 Scripts Úteis

### Backend
```bash
cd backend

# Executar testes
npm test

# Verificar sintaxe
npm run lint

# Inicializar banco local
npm run db:init

# Reset do banco
npm run db:reset
```

### Frontend
```bash
cd frontend

# Build para produção
npm run build

# Testar build local
npm run serve

# Executar testes
npm test

# Análise de bundle
npm run analyze
```

## 📈 Monitoramento

### Logs do Sistema
```bash
# Logs do backend (desenvolvimento)
tail -f backend/logs/app.log

# Logs do sistema (produção AWS)
ssh -i crud-app-key.pem ec2-user@[IP] tail -f /var/log/user-data.log

# Status dos serviços (produção)
ssh -i crud-app-key.pem ec2-user@[IP] systemctl status crud-backend
```

### Health Checks
- **Local**: http://localhost:3001/health
- **Produção**: http://[IP-PUBLICO]/health

### Métricas Importantes
- Tempo de resposta da API
- Status do banco SQLite
- Uso de CPU/Memória da instância
- Logs de erro da aplicação

## 🐛 Solução de Problemas

### Problemas Comuns

**Backend não inicia**
```bash
# Verificar porta em uso
netstat -an | grep 3001
# Matar processo se necessário
kill -9 [PID]
```

**Frontend não conecta ao backend**
```bash
# Verificar URL da API em frontend/src/App.js
# Deve apontar para localhost:3001 em dev
```

**Deploy AWS falha**
```bash
# Verificar credenciais AWS
aws sts get-caller-identity

# Verificar key pair existe
aws ec2 describe-key-pairs --key-names crud-app-key

# Criar key pair se necessário
aws ec2 create-key-pair --key-name crud-app-key --output text --query 'KeyMaterial' > crud-app-key.pem
chmod 400 crud-app-key.pem
```

## 📚 Documentação Adicional

- [API Documentation](docs/api.md)
- [Frontend Components](docs/components.md)
- [Terraform Modules](docs/terraform.md)
- [Deployment Guide](docs/deployment.md)

## 🤝 Contribuição

```bash
# Fork do projeto
# Criar branch para feature
git checkout -b feature/minha-feature

# Fazer alterações e commit
git commit -m "feat: minha nova feature"

# Push e criar Pull Request
git push origin feature/minha-feature
```

## 📄 Licença

Este projeto está sob licença MIT. Veja [LICENSE](LICENSE) para detalhes.

## 👥 Equipe

- **Desenvolvedor**: David Damasceno, Gabriel Heleno , Beatriz, 
- **Repositório**: https://github.com/Davidamascen07/CRUD-eng-software

## 📞 Suporte

- **Issues**: https://github.com/Davidamascen07/CRUD-eng-software/issues
- **Documentação**: Esta README e pasta `/docs`
- **Email**: [seu-email@exemplo.com]

---

**🎯 Projeto 100% funcional e documentado para Engenharia de Software**
