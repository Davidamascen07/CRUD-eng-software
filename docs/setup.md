# Guia de Setup Completo

## 🔧 Configuração do Ambiente

### 1. Instalação do Node.js
```bash
# Verificar se está instalado
node --version
npm --version

# Se não estiver instalado:
# Windows: Baixar de https://nodejs.org
# macOS: brew install node
# Linux: apt-get install nodejs npm
```

### 2. Configuração do Git
```bash
# Configurar usuário global
git config --global user.name "Seu Nome"
git config --global user.email "seu.email@exemplo.com"

# Verificar configuração
git config --list
```

### 3. Setup do Projeto
```bash
# Clonar repositório
git clone https://github.com/Davidamascen07/CRUD-eng-software.git
cd CRUD-eng-software

# Instalar dependências do backend
cd backend
npm install

# Instalar dependências do frontend
cd ../frontend
npm install

# Voltar para raiz
cd ..
```

## 🚀 Execução Local

### Método 1: Separado
```bash
# Terminal 1 - Backend
cd backend
npm start

# Terminal 2 - Frontend
cd frontend
npm start
```

### Método 2: Concorrente (se configurado)
```bash
# Da raiz do projeto
npm run dev
```

## ☁️ Setup AWS

### 1. Criar Conta AWS
- Acessar https://aws.amazon.com
- Criar conta gratuita
- Verificar email e cartão

### 2. Configurar AWS CLI
```bash
# Instalar AWS CLI
pip install awscli

# Configurar credenciais
aws configure
```

### 3. Criar Key Pair
```bash
# Via AWS CLI
aws ec2 create-key-pair --key-name crud-app-key --output text --query 'KeyMaterial' > crud-app-key.pem
chmod 400 crud-app-key.pem

# Ou via Console AWS EC2
```

## 🔒 Variáveis de Ambiente

### Backend (.env)
```bash
NODE_ENV=development
PORT=3001
USE_SQLITE=true
SQLITE_PATH=./database.sqlite
```

### Frontend (.env)
```bash
REACT_APP_API_URL=http://localhost:3001
GENERATE_SOURCEMAP=false
```

## ✅ Verificação do Setup

### 1. Testar Backend
```bash
# Iniciar backend
cd backend && npm start

# Em outro terminal, testar
curl http://localhost:3001/health
```

### 2. Testar Frontend
```bash
# Iniciar frontend
cd frontend && npm start

# Abrir http://localhost:3000
```

### 3. Testar Integração
- Abrir frontend
- Tentar criar/editar item
- Verificar se dados persistem

## 🐛 Problemas Comuns

### Porta em uso
```bash
# Encontrar processo
lsof -i :3001
# Matar processo
kill -9 [PID]
```

### Permissões AWS
```bash
# Verificar credenciais
aws sts get-caller-identity

# Verificar permissões
aws iam get-user
```

### Módulos não encontrados
```bash
# Limpar cache e reinstalar
rm -rf node_modules package-lock.json
npm install
```
