# CRUD App - Aplicação de Engenharia de Software

Uma aplicação CRUD (Create, Read, Update, Delete) moderna e completa, desenvolvida como projeto acadêmico de Engenharia de Software. A aplicação demonstra boas práticas de desenvolvimento, arquitetura modular e deploy em nuvem.

## 🚀 Características Principais

- **Frontend moderno** em React com interface responsiva
- **Backend robusto** em Node.js/Express
- **Banco de dados flexível** (SQLite/MySQL)
- **Deploy automatizado** na AWS com Terraform
- **Interface intuitiva** com Tailwind CSS
- **Operações CRUD completas** com validação
- **Paginação e filtros** para melhor UX

## 🏗️ Arquitetura do Projeto

```
CRUD-eng-software/
├── frontend/           # Aplicação React
│   ├── src/
│   │   ├── components/ # Componentes reutilizáveis
│   │   ├── App.js      # Componente principal
│   │   └── index.js    # Ponto de entrada
│   └── public/         # Arquivos estáticos
├── backend/            # API Node.js/Express
│   ├── server.js       # Servidor principal
│   └── package.json    # Dependências do backend
├── terraform/          # Infraestrutura como código
│   ├── modules/        # Módulos Terraform reutilizáveis
│   │   ├── vpc/        # Configuração de rede
│   │   ├── ec2/        # Instâncias EC2
│   │   ├── security_groups/ # Grupos de segurança
│   │   └── rds/        # Banco de dados RDS
│   ├── main.tf         # Configuração principal
│   └── variables.tf    # Variáveis do Terraform
└── README.md           # Este arquivo
```

## 🛠️ Tecnologias Utilizadas

### Frontend
- **React** 18+ - Framework de interface
- **Tailwind CSS** - Framework CSS utilitário
- **Axios** - Cliente HTTP para API
- **Font Awesome** - Ícones

### Backend
- **Node.js** - Runtime JavaScript
- **Express** - Framework web
- **SQLite3** - Banco de dados local (padrão)
- **MySQL** - Banco de dados alternativo
- **CORS** - Middleware para requisições cross-origin

### Infraestrutura
- **AWS EC2** - Hospedagem da aplicação
- **AWS VPC** - Rede virtual privada
- **Terraform** - Infraestrutura como código
- **Amazon Linux 2** - Sistema operacional

## 📋 Pré-requisitos

### Para desenvolvimento local:
- Node.js 16+ 
- npm ou yarn
- Git

### Para deploy na AWS:
- Conta AWS ativa
- Terraform instalado
- AWS CLI configurado
- Key pair criado na AWS

## 🚀 Instalação e Execução Local

### 1. Clone o repositório
```bash
git clone https://github.com/seu-usuario/CRUD-eng-software.git
cd CRUD-eng-software
```

### 2. Configure o Backend
```bash
cd backend
npm install
npm start
```
O servidor estará rodando em `http://localhost:3001`

### 3. Configure o Frontend
```bash
cd frontend
npm install
npm start
```
A aplicação estará disponível em `http://localhost:3000`

## ☁️ Deploy na AWS

### 1. Configurar Terraform
```bash
cd terraform

# Inicializar Terraform
terraform init

# Verificar o plano de execução
terraform plan

# Aplicar as configurações
terraform apply
```

### 2. Configurar Key Pair
Antes do deploy, crie um key pair na AWS:
```bash
# No console AWS EC2, criar key pair com nome "crud-app-key"
# Ou usar AWS CLI:
aws ec2 create-key-pair --key-name crud-app-key --query 'KeyMaterial' --output text > crud-app-key.pem
chmod 400 crud-app-key.pem
```

### 3. Acessar a aplicação
Após o deploy, o Terraform fornecerá:
- **IP público da instância**
- **URL da aplicação** (http://IP:3001)
- **Comando SSH** para acesso

## 🎯 Funcionalidades

### Interface do Usuário
- ✅ **Listagem de itens** com paginação
- ✅ **Busca e filtros** por nome e status
- ✅ **Adição de novos itens** via modal
- ✅ **Edição de itens** existentes
- ✅ **Exclusão com confirmação**
- ✅ **Notificações toast** para feedback
- ✅ **Design responsivo** para mobile

### API Backend
- ✅ `GET /api/items` - Listar todos os itens
- ✅ `GET /api/items/:id` - Buscar item específico
- ✅ `POST /api/items` - Criar novo item
- ✅ `PUT /api/items/:id` - Atualizar item
- ✅ `DELETE /api/items/:id` - Excluir item

### Validações
- ✅ **Nome obrigatório** para todos os itens
- ✅ **Status válido** (ativo/inativo)
- ✅ **Tratamento de erros** robusto
- ✅ **Sanitização de dados** de entrada

## ⚙️ Configuração

### Variáveis de Ambiente (Backend)
```env
PORT=3001                    # Porta do servidor
USE_SQLITE=true             # Usar SQLite (padrão)
SQLITE_PATH=./database.sqlite # Caminho do banco SQLite
DB_HOST=localhost           # Host MySQL (se USE_SQLITE=false)
DB_USER=root               # Usuário MySQL
DB_PASSWORD=senha          # Senha MySQL
DB_NAME=crud_app          # Nome do banco MySQL
```

### Configuração do Terraform
```hcl
# Principais variáveis configuráveis
aws_region = "us-east-2"        # Região AWS
instance_type = "t2.micro"      # Tipo da instância (Free Tier)
key_name = "crud-app-key"       # Nome do key pair
use_sqlite = true               # Usar SQLite na instância
```

## 🔧 Comandos Úteis

### Desenvolvimento
```bash
# Backend - modo desenvolvimento
cd backend && npm run dev

# Frontend - modo desenvolvimento  
cd frontend && npm start

# Instalar dependências em ambos
npm run install-all
```

### Terraform
```bash
# Verificar recursos criados
terraform show

# Destruir infraestrutura
terraform destroy

# Verificar estado atual
terraform state list
```

### AWS EC2
```bash
# Conectar via SSH
ssh -i ~/.ssh/crud-app-key.pem ec2-user@SEU_IP_PUBLICO

# Verificar logs da aplicação
sudo journalctl -u crud-app -f

# Reiniciar serviço
sudo systemctl restart crud-app
```

## 📊 Estrutura do Banco de Dados

### Tabela: items
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

## 🧪 Testes

### Testar API manualmente
```bash
# Listar itens
curl http://localhost:3001/api/items

# Criar item
curl -X POST http://localhost:3001/api/items \
  -H "Content-Type: application/json" \
  -d '{"name":"Teste","description":"Item de teste"}'

# Atualizar item
curl -X PUT http://localhost:3001/api/items/1 \
  -H "Content-Type: application/json" \
  -d '{"name":"Teste Atualizado","status":"inactive"}'

# Excluir item
curl -X DELETE http://localhost:3001/api/items/1
```

## 🚨 Troubleshooting

### Problemas Comuns

#### Frontend não conecta com Backend
- Verificar se o backend está rodando na porta 3001
- Confirmar configuração de CORS no servidor
- Verificar URL da API no `App.js`

#### Erro ao fazer deploy na AWS
- Verificar credenciais AWS configuradas
- Confirmar que o key pair existe na região correta
- Verificar limites da conta AWS (Free Tier)

#### Instância EC2 não responde
- Verificar Security Groups (portas 22, 80, 3001)
- Confirmar que a instância está rodando
- Verificar logs: `sudo journalctl -u crud-app`

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📝 Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

## 👥 Autores

- **Seu Nome** - [GitHub](https://github.com/seu-usuario)

## 🙏 Agradecimentos

- Professores de Engenharia de Software
- Comunidade React e Node.js
- Documentação oficial do AWS e Terraform
- Tailwind CSS pela interface moderna

---

## 📈 Próximas Melhorias

- [ ] Implementar autenticação JWT
- [ ] Adicionar testes automatizados
- [ ] Configurar CI/CD com GitHub Actions
- [ ] Implementar cache Redis
- [ ] Adicionar monitoramento com CloudWatch
- [ ] Configurar HTTPS com Certificate Manager
- [ ] Implementar backup automático do banco

---

**📞 Suporte**: Para dúvidas ou problemas, abra uma [issue](https://github.com/seu-usuario/CRUD-eng-software/issues) no GitHub.
