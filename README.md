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

- **Desenvolvedor**: David Damasceno, Gabriel Heleno , Beatriz, Thalis Ferreira
- **Repositório**: https://github.com/Davidamascen07/CRUD-eng-software

## 📞 Suporte

- **Issues**: https://github.com/Davidamascen07/CRUD-eng-software/issues
- **Documentação**: Esta README e pasta `/docs`
- **Email**: [seu-email@exemplo.com]

---

**🎯 Projeto 100% funcional e documentado para Engenharia de Software**



# 📋 CRUD App - Apresentação do Projeto
## Engenharia de Software

---

## 📖 Sumário
1. [Visão Geral](#visão-geral)
2. [Arquitetura do Sistema](#arquitetura-do-sistema)
3. [Tecnologias Utilizadas](#tecnologias-utilizadas)
4. [Funcionalidades](#funcionalidades)
5. [Interface do Usuário](#interface-do-usuário)
6. [Estrutura do Projeto](#estrutura-do-projeto)
7. [API REST](#api-rest)
8. [Banco de Dados](#banco-de-dados)
9. [Deploy e Produção](#deploy-e-produção)
10. [Demonstração](#demonstração)

---

## 🎯 Visão Geral

### Objetivo do Projeto
Sistema CRUD (Create, Read, Update, Delete) completo desenvolvido para a disciplina de Engenharia de Software, demonstrando:
- Arquitetura Full Stack moderna
- Boas práticas de desenvolvimento
- Deploy em nuvem (AWS)
- Interface responsiva e intuitiva

### Características Principais
- ✅ **Frontend React** com interface moderna
- ✅ **Backend Node.js** com API RESTful
- ✅ **Banco de dados** SQLite/MySQL flexível
- ✅ **Deploy automatizado** na AWS
- ✅ **Interface responsiva** mobile-first
- ✅ **Validação de dados** client e server-side

---

## 🏗️ Arquitetura do Sistema

```
┌─────────────────┐    HTTP/REST    ┌─────────────────┐
│                 │ ←──────────────→ │                 │
│   FRONTEND      │     Axios       │    BACKEND      │
│   (React)       │                 │   (Node.js)     │
│                 │                 │                 │
│ • Components    │                 │ • Express API   │
│ • State Mgmt    │                 │ • Middleware    │
│ • Routing       │                 │ • Validation    │
│ • Styling       │                 │                 │
└─────────────────┘                 └─────────────────┘
                                              │
                                              │ SQL Queries
                                              ▼
                                    ┌─────────────────┐
                                    │                 │
                                    │   DATABASE      │
                                    │ (SQLite/MySQL)  │
                                    │                 │
                                    │ • Items Table   │
                                    │ • CRUD Ops      │
                                    │ • Data Persist. │
                                    └─────────────────┘
```

### Fluxo de Dados
1. **Frontend** → Requisição HTTP → **Backend**
2. **Backend** → Query SQL → **Database**
3. **Database** → Retorna dados → **Backend**
4. **Backend** → Resposta JSON → **Frontend**
5. **Frontend** → Atualiza interface → **Usuário**

---

## 💻 Tecnologias Utilizadas

### Frontend
| Tecnologia | Versão | Propósito |
|------------|--------|-----------|
| **React** | 18.x | Framework JS para UI |
| **Tailwind CSS** | Latest | Framework CSS utilitário |
| **Axios** | Latest | Cliente HTTP |
| **Font Awesome** | 6.4.0 | Ícones |

### Backend
| Tecnologia | Versão | Propósito |
|------------|--------|-----------|
| **Node.js** | 18.x+ | Runtime JavaScript |
| **Express** | Latest | Framework web |
| **SQLite3** | Latest | Banco local |
| **MySQL2** | Latest | Banco produção |
| **CORS** | Latest | Cross-origin requests |

### DevOps & Deploy
| Tecnologia | Propósito |
|------------|-----------|
| **AWS EC2** | Servidor virtual |
| **AWS Route 53** | DNS management |
| **Nginx** | Reverse proxy |
| **PM2** | Process manager |
| **Git** | Controle de versão |

---

## ⚡ Funcionalidades

### CRUD Completo
- ✨ **CREATE**: Adicionar novos itens
- 📖 **READ**: Listar e visualizar itens
- ✏️ **UPDATE**: Editar itens existentes
- 🗑️ **DELETE**: Remover itens

### Recursos Avançados
- 🔍 **Busca em tempo real** por nome/descrição
- 🏷️ **Filtros por status** (Ativo/Inativo)
- 📄 **Paginação** para grandes volumes
- 📱 **Interface responsiva** mobile/desktop
- ⚡ **Feedback visual** com toasts
- 🔄 **Atualização automática** da lista

### Validações
- **Frontend**: Validação de formulários
- **Backend**: Sanitização de dados
- **Database**: Constraints e tipos

---

## 🎨 Interface do Usuário

### Layout Principal
```
┌─────────────────────────────────────────────────────┐
│                    HEADER                           │
│  📋 CRUD App        [🔄 Atualizar] [➕ Adicionar]  │
├─────────────────────────────────────────────────────┤
│                 FILTROS & BUSCA                     │
│  🔍 [________Buscar________] Status: [All ▼]       │
├─────────────────────────────────────────────────────┤
│                    TABELA                           │
│  ID │ Nome    │ Descrição │ Status │ Ações         │
│  1  │ Item A  │ Desc A    │ Ativo  │ [✏️] [🗑️]   │
│  2  │ Item B  │ Desc B    │ Inativo│ [✏️] [🗑️]   │
├─────────────────────────────────────────────────────┤
│                  PAGINAÇÃO                          │
│        [◀️] Página 1 de 3 [▶️]                     │
└─────────────────────────────────────────────────────┘
```

### Modais Interativos
- **Modal de Criação/Edição**: Formulário completo
- **Modal de Confirmação**: Para exclusões
- **Toasts**: Feedback de sucesso/erro

### Responsividade
- **Desktop**: Layout em grid completo
- **Tablet**: Adaptação de colunas
- **Mobile**: Stack vertical, botões maiores

---

## 📁 Estrutura do Projeto

```
CRUD-eng-software/
├── 📁 frontend/                 # Aplicação React
│   ├── 📁 public/
│   │   └── index.html
│   ├── 📁 src/
│   │   ├── 📁 components/       # Componentes reutilizáveis
│   │   │   ├── Header.js
│   │   │   ├── ItemModal.js
│   │   │   ├── ItemsTable.js
│   │   │   ├── SearchFilter.js
│   │   │   └── Toast.js
│   │   ├── App.js              # Componente principal
│   │   └── index.js            # Ponto de entrada
│   └── package.json
├── 📁 backend/                  # API Node.js
│   ├── server.js               # Servidor principal
│   ├── database.sqlite         # Banco SQLite
│   └── package.json
├── 📁 docs/                    # Documentação
│   └── setup.md
└── 📄 README.md
```

---

## 🔌 API REST

### Endpoints Disponíveis

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `GET` | `/api/items` | Listar todos os itens |
| `GET` | `/api/items/:id` | Buscar item específico |
| `POST` | `/api/items` | Criar novo item |
| `PUT` | `/api/items/:id` | Atualizar item |
| `DELETE` | `/api/items/:id` | Excluir item |
| `GET` | `/health` | Status da aplicação |

### Exemplo de Payload
```json
{
  "name": "Produto Exemplo",
  "description": "Descrição do produto",
  "status": "active"
}
```

### Resposta Padrão
```json
{
  "id": 1,
  "name": "Produto Exemplo",
  "description": "Descrição do produto",
  "status": "active",
  "createdAt": "2024-01-01T10:00:00.000Z",
  "updatedAt": "2024-01-01T10:00:00.000Z"
}
```

---

## 🗄️ Banco de Dados

### Esquema da Tabela `items`
```sql
CREATE TABLE items (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  description TEXT,
  status TEXT DEFAULT 'active',
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### Configuração Flexível
- **Desenvolvimento**: SQLite (arquivo local)
- **Produção**: MySQL (AWS RDS ou local)
- **Switch automático** via variáveis de ambiente

---

## ☁️ Deploy e Produção

### Ambiente AWS
```
Internet ──→ Route 53 ──→ EC2 Instance
                            │
                            ├── Nginx (Port 80/443)
                            │    │
                            │    └── Proxy to Node.js (Port 3001)
                            │
                            ├── Node.js Backend
                            │    │
                            │    └── SQLite/MySQL Database
                            │
                            └── React Build (Static Files)
```

### Processo de Deploy
1. **Build do React**: `npm run build`
2. **Upload para EC2**: Via Git ou SCP
3. **Install dependências**: `npm install`
4. **Start com PM2**: `pm2 start server.js`
5. **Nginx config**: Proxy reverso
6. **SSL**: Certificado Let's Encrypt

### Monitoramento
- **Health checks**: `/health` endpoint
- **Logs**: PM2 logs centralizados
- **Uptime**: Monitoramento automático

---

## 🎥 Demonstração

### Cenário de Uso
1. **Acesso inicial**: Interface limpa e intuitiva
2. **Adicionar item**: Modal com validação
3. **Listar itens**: Tabela paginada
4. **Buscar/Filtrar**: Resultados em tempo real
5. **Editar item**: Modal pré-preenchido
6. **Excluir item**: Confirmação de segurança
7. **Feedback**: Toasts de sucesso/erro

### Fluxo de Demonstração
```
🏠 Página inicial
  ↓
➕ Adicionar novo item
  ↓
📝 Preencher formulário
  ↓
✅ Confirmar criação
  ↓
📋 Ver item na lista
  ↓
🔍 Testar busca
  ↓
✏️ Editar item
  ↓
🗑️ Excluir item
  ↓
✨ Aplicação funcionando!
```

---

## 📊 Métricas do Projeto

### Linhas de Código
- **Frontend**: ~800 linhas
- **Backend**: ~400 linhas
- **Total**: ~1200 linhas

### Componentes React
- **6 componentes** principais
- **Reutilização** em 90%
- **Props drilling** minimizado

### Performance
- **Build size**: ~2MB
- **Load time**: <3s
- **API response**: <200ms

---

## 🚀 Próximos Passos

### Funcionalidades Futuras
- 🔐 **Autenticação** de usuários
- 📤 **Import/Export** CSV
- 📈 **Dashboard** com gráficos
- 🔔 **Notificações** push
- 📱 **App mobile** React Native

### Melhorias Técnicas
- 🧪 **Testes automatizados** (Jest/Cypress)
- 🐳 **Containerização** Docker
- 🔄 **CI/CD pipeline** GitHub Actions
- 📊 **Monitoring** com CloudWatch
- 🔒 **Segurança** avançada

---

## 👥 Equipe de Desenvolvimento

**Desenvolvedor Principal**: [equipe3]
**Disciplina**: Engenharia de Software
**Instituição**: [FIED]


---

## 📞 Contato e Links

- 📧 **Email**: [seu.email@exemplo.com]
- 🌐 **GitHub**: [github.com/Davidamascen07/CRUD-eng-software]
- 🔗 **Demo Live**: [seu-dominio.com]
- 📋 **Documentação**: [Link para docs]

---

## 🙏 Agradecimentos

Agradecimentos especiais:
- Professor orientador
- Colegas de classe
- Comunidade open source
- Documentações oficiais das tecnologias

---

*Apresentação preparada para demonstrar conhecimentos em Engenharia de Software através de um projeto prático e funcional.*
