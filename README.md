# Aplicação CRUD com DevOps

Uma aplicação CRUD simples com interface gráfica em React, pronta para ser implantada em ambientes cloud usando ferramentas de DevOps.

## Tecnologias Utilizadas

- **Frontend**: React, Tailwind CSS
- **Backend**: Node.js, Express.js
- **Banco de Dados**: MySQL
- **Infraestrutura**: Terraform, AWS CloudFormation, Ansible

## Estrutura do Projeto

```
.
├── frontend/              # Frontend em React
│   ├── public/            # Arquivos públicos
│   ├── src/               # Código fonte React
│   │   ├── components/    # Componentes React
│   │   ├── App.js         # Componente principal
│   │   └── index.js       # Ponto de entrada
│   └── package.json       # Dependências do frontend
├── backend/
│   ├── server.js          # Servidor Node.js
│   ├── package.json       # Dependências do backend
│   └── database/
│       └── schema.sql     # Schema do banco de dados
├── terraform/             # Configuração Terraform
├── cloudformation/        # Template CloudFormation
├── ansible/               # Playbooks Ansible
└── README.md              # Documentação
```

## Requisitos

- Node.js 14+
- MySQL 8.0+
- AWS CLI (para deploy)
- Terraform 1.0+ (opcional)
- Ansible 2.9+ (opcional)

### Instalando o Terraform

O erro `'terraform' não é reconhecido como um comando interno` indica que o Terraform não está instalado ou não está no PATH do sistema.

**Para Windows:**
1. Baixe o arquivo ZIP do Terraform em [terraform.io/downloads](https://www.terraform.io/downloads)
2. Extraia o arquivo terraform.exe para uma pasta, por exemplo: `C:\terraform`
3. Adicione esta pasta ao PATH do sistema:
   - Busque por "Variáveis de Ambiente" no menu Iniciar
   - Clique em "Editar as variáveis de ambiente do sistema"
   - Clique em "Variáveis de Ambiente"
   - Em "Variáveis do sistema", selecione "Path" e clique em "Editar"
   - Clique em "Novo" e adicione `C:\terraform`
   - Clique em OK em todas as janelas
4. Abra um novo prompt de comando e teste com `terraform version`

**Para macOS (usando Homebrew):**
```bash
brew install terraform
```

**Para Linux (Ubuntu/Debian):**
```bash
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

Após a instalação, você pode continuar com as etapas de inicialização e deploy do Terraform.

## Execução Local

1. **Configurar o banco de dados**:
   ```bash
   mysql -u root -p < backend/database/schema.sql
   ```

2. **Instalar dependências do backend**:
   ```bash
   cd backend
   npm install
   ```

3. **Instalar dependências do frontend**:
   ```bash
   cd frontend
   npm install
   ```

4. **Configurar variáveis de ambiente**:
   ```bash
   # No diretório backend
   cp .env.example .env
   # Edite o arquivo .env com suas configurações
   ```

5. **Iniciar o servidor backend**:
   ```bash
   cd backend
   npm start
   ```

6. **Iniciar o servidor de desenvolvimento React**:
   ```bash
   cd frontend
   npm start
   ```

7. **Para produção, construir o frontend**:
   ```bash
   cd frontend
   npm run build
   ```

8. **Acessar a aplicação**:
   - Desenvolvimento: Abra o navegador e acesse `http://localhost:3000`
   - Produção: Abra o navegador e acesse `http://localhost:3001`

## Executando o Frontend React

### Modo de Desenvolvimento

Para executar o frontend em modo de desenvolvimento:

```bash
# Navegar até o diretório do frontend
cd frontend

# Instalar dependências (se ainda não instalou)
npm install

# Iniciar o servidor de desenvolvimento
npm start
```

O servidor de desenvolvimento React será iniciado na porta 3000. Abra seu navegador em `http://localhost:3000` para visualizar a aplicação. O servidor tem hot-reload habilitado, então as alterações no código serão automaticamente aplicadas.

### Modo de Produção

Para construir e executar o frontend para produção:

```bash
# Construir o aplicativo React
cd frontend
npm run build

# Os arquivos estarão disponíveis na pasta 'frontend/build'
# O backend está configurado para servir estes arquivos estáticos
```

Após o build, inicie o servidor backend que servirá os arquivos estáticos:

```bash
cd backend
npm start
```

Acesse a aplicação em `http://localhost:3001`.

### Solução de Problemas Comuns

1. **Erro de conexão com a API**:
   - Verifique se o backend está rodando na porta correta
   - Confirme que o arquivo `package.json` do frontend tem a linha: `"proxy": "http://localhost:3001"`

2. **Erros de CORS**:
   - Certifique-se de que o backend tem o middleware CORS configurado corretamente

3. **Erro "Invalid options object. Dev Server has been initialized using an options object that does not match the API schema"**:
   - Crie um arquivo `.env` no diretório do frontend com o seguinte conteúdo:
     ```
     DANGEROUSLY_DISABLE_HOST_CHECK=true
     WDS_SOCKET_HOST=localhost
     ```
   - Alternativa: Crie um arquivo `setupProxy.js` na pasta `src`:
     ```javascript
     module.exports = function(app) {
       app.use((req, res, next) => {
         res.header('Access-Control-Allow-Origin', '*');
         next();
       });
     };
     ```

4. **Avisos de pacotes deprecados**:
   ```bash
   # Atualizar pacotes com vulnerabilidades (modo seguro)
   npm audit fix
   ```

5. **Para desenvolvimento avançado**:
   Considere migrar para ferramentas mais modernas como Vite:
   ```bash
   npm create vite@latest my-new-crud-app -- --template react
   ```

## Deploy na AWS

### Utilizando Terraform

1. **Inicializar o Terraform**:
   ```bash
   cd terraform
   terraform init
   ```
   
   Este comando inicializa o diretório de trabalho do Terraform, baixa os providers necessários e configura os módulos. Se executado com sucesso, você verá uma mensagem "Terraform has been successfully initialized!".

2. **Configurar Credenciais da AWS**:
   
   Antes de continuar, você precisa configurar suas credenciais da AWS:

   **Opção 1: Usando o AWS CLI**
   ```bash
   aws configure
   # Informe sua Access Key, Secret Key, região (ex: us-east-1) e formato de saída (json)
   ```

   **Opção 2: Variáveis de ambiente**
   ```bash
   # Windows
   set AWS_ACCESS_KEY_ID=sua-access-key
   set AWS_SECRET_ACCESS_KEY=sua-secret-key
   set AWS_REGION=us-east-1

   # Linux/macOS
   export AWS_ACCESS_KEY_ID=sua-access-key
   export AWS_SECRET_ACCESS_KEY=sua-secret-key
   export AWS_REGION=us-east-2
   ```

3. **Planejar a infraestrutura**:
   ```bash
   terraform plan
   ```
   
   Este comando mostra as mudanças que serão feitas na infraestrutura, sem aplicá-las ainda. Execute apenas este comando primeiro, sem combiná-lo com outros comandos.

4. **Aplicar a infraestrutura**:
   ```bash
   terraform apply -var="db_password=SuaSenhaSegura"
   ```
   
   Depois que o comando for executado, o Terraform mostrará o plano de execução e pedirá confirmação:
   
   ```
   Do you want to perform these actions?
   Terraform will perform the actions described acima.
   Only 'yes' will be accepted to approve.

   Enter a value:
   ```
   
   Digite `yes` e pressione Enter para iniciar a criação dos recursos. Não digite apenas "y" ou qualquer outra coisa, pois o Terraform só aceita "yes" como confirmação.

5. **Durante a execução do Terraform**:

   O Terraform começará a criar os recursos na AWS, mostrando o progresso de cada recurso. Este processo pode levar entre 10 a 20 minutos, principalmente a criação do banco de dados RDS.
   
   Exemplo de saída durante a execução:
   ```
   module.security_groups.aws_security_group.app_sg: Creating...
   module.vpc.aws_subnet.private: Creating...
   module.vpc.aws_subnet.private2: Creating...
   module.vpc.aws_subnet.public: Creating...
   ```

6. **Após a execução ser concluída**:

   Quando todos os recursos forem criados, você verá uma mensagem de sucesso e um resumo dos outputs:
   ```
   Apply complete! Resources: 10 added, 0 changed, 3 destroyed.

   Outputs:
   ec2_public_ip = "34.xxx.xxx.xxx"
   rds_endpoint = "crud-app-mysql.xxxxxx.us-east-1.rds.amazonaws.com:3306"
   ```

7. **Verificar os outputs gerados**:
   ```bash
   terraform output
   ```
   
   Este comando exibirá novamente os outputs, que incluem:
   - O endereço IP público da instância EC2 (`ec2_public_ip`)
   - O endpoint do banco de dados RDS (`rds_endpoint`)

8. **Acessar e configurar a aplicação**:

   - Conecte-se à instância EC2 usando SSH:
     ```bash
     ssh -i /path/to/crud-app-key.pem ec2-user@[EC2_IP_ADDRESS]
     ```
     Substitua `[EC2_IP_ADDRESS]` pelo valor do output `ec2_public_ip`

   - Clone o repositório da aplicação na instância:
     ```bash
     git clone https://github.com/seu-usuario/crud-app.git
     cd crud-app/backend
     npm install
     ```

   - Configure as variáveis de ambiente para conexão com o banco de dados:
     ```bash
     export DB_HOST=[RDS_ENDPOINT_SEM_PORTA]
     export DB_USER=crudadmin
     export DB_PASSWORD=#Projeto292307
     export DB_NAME=crud_app
     ```
     Substitua `[RDS_ENDPOINT_SEM_PORTA]` pela parte do endpoint RDS antes do `:3306`

   - Execute o script para criar o schema do banco de dados:
     ```bash
     mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME < database/schema.sql
     ```

   - Inicie o servidor backend:
     ```bash
     npm start
     ```

9. **Acesse a aplicação**:

   Abra o navegador e acesse `http://[EC2_IP_ADDRESS]:3000`

## Executando o Frontend React

### Modo de Desenvolvimento

Para executar o frontend em modo de desenvolvimento:

```bash
# Navegar até o diretório do frontend
cd frontend

# Instalar dependências (se ainda não instalou)
npm install

# Iniciar o servidor de desenvolvimento
npm start
```

O servidor de desenvolvimento React será iniciado na porta 3000. Abra seu navegador em `http://localhost:3000` para visualizar a aplicação. O servidor tem hot-reload habilitado, então as alterações no código serão automaticamente aplicadas.

### Modo de Produção

Para construir e executar o frontend para produção:

```bash
# Construir o aplicativo React
cd frontend
npm run build

# Os arquivos estarão disponíveis na pasta 'frontend/build'
# O backend está configurado para servir estes arquivos estáticos
```

Após o build, inicie o servidor backend que servirá os arquivos estáticos:

```bash
cd backend
npm start
```

Acesse a aplicação em `http://localhost:3001`.

### Solução de Problemas Comuns

1. **Erro de conexão com a API**:
   - Verifique se o backend está rodando na porta correta
   - Confirme que o arquivo `package.json` do frontend tem a linha: `"proxy": "http://localhost:3001"`

2. **Erros de CORS**:
   - Certifique-se de que o backend tem o middleware CORS configurado corretamente

3. **Erro "Invalid options object. Dev Server has been initialized using an options object that does not match the API schema"**:
   - Crie um arquivo `.env` no diretório do frontend com o seguinte conteúdo:
     ```
     DANGEROUSLY_DISABLE_HOST_CHECK=true
     WDS_SOCKET_HOST=localhost
     ```
   - Alternativa: Crie um arquivo `setupProxy.js` na pasta `src`:
     ```javascript
     module.exports = function(app) {
       app.use((req, res, next) => {
         res.header('Access-Control-Allow-Origin', '*');
         next();
       });
     };
     ```

4. **Avisos de pacotes deprecados**:
   ```bash
   # Atualizar pacotes com vulnerabilidades (modo seguro)
   npm audit fix
   ```

5. **Para desenvolvimento avançado**:
   Considere migrar para ferramentas mais modernas como Vite:
   ```bash
   npm create vite@latest my-new-crud-app -- --template react
   ```

## Deploy na AWS

### Utilizando Terraform

1. **Inicializar o Terraform**:
   ```bash
   cd terraform
   terraform init
   ```
   
   Este comando inicializa o diretório de trabalho do Terraform, baixa os providers necessários e configura os módulos. Se executado com sucesso, você verá uma mensagem "Terraform has been successfully initialized!".

2. **Configurar Credenciais da AWS**:
   
   Antes de continuar, você precisa configurar suas credenciais da AWS:

   **Opção 1: Usando o AWS CLI**
   ```bash
   aws configure
   # Informe sua Access Key, Secret Key, região (ex: us-east-1) e formato de saída (json)
   ```

   **Opção 2: Variáveis de ambiente**
   ```bash
   # Windows
   set AWS_ACCESS_KEY_ID=sua-access-key
   set AWS_SECRET_ACCESS_KEY=sua-secret-key
   set AWS_REGION=us-east-1

   # Linux/macOS
   export AWS_ACCESS_KEY_ID=sua-access-key
   export AWS_SECRET_ACCESS_KEY=sua-secret-key
   export AWS_REGION=us-east-2
   ```

3. **Planejar a infraestrutura**:
   ```bash
   terraform plan
   ```
   
   Este comando mostra as mudanças que serão feitas na infraestrutura, sem aplicá-las ainda. Execute apenas este comando primeiro, sem combiná-lo com outros comandos.

4. **Aplicar a infraestrutura**:
   ```bash
   terraform apply -var="db_password=SuaSenhaSegura"
   ```
   
   Depois que o comando for executado, o Terraform mostrará o plano de execução e pedirá confirmação:
   
   ```
   Do you want to perform these actions?
   Terraform will perform the actions described acima.
   Only 'yes' will be accepted to approve.

   Enter a value:
   ```
   
   Digite `yes` e pressione Enter para iniciar a criação dos recursos. Não digite apenas "y" ou qualquer outra coisa, pois o Terraform só aceita "yes" como confirmação.

5. **Durante a execução do Terraform**:

   O Terraform começará a criar os recursos na AWS, mostrando o progresso de cada recurso. Este processo pode levar entre 10 a 20 minutos, principalmente a criação do banco de dados RDS.
   
   Exemplo de saída durante a execução:
   ```
   module.security_groups.aws_security_group.app_sg: Creating...
   module.vpc.aws_subnet.private: Creating...
   module.vpc.aws_subnet.private2: Creating...
   module.vpc.aws_subnet.public: Creating...
   ```

6. **Após a execução ser concluída**:

   Quando todos os recursos forem criados, você verá uma mensagem de sucesso e um resumo dos outputs:
   ```
   Apply complete! Resources: 10 added, 0 changed, 3 destroyed.

   Outputs:
   ec2_public_ip = "34.xxx.xxx.xxx"
   rds_endpoint = "crud-app-mysql.xxxxxx.us-east-1.rds.amazonaws.com:3306"
   ```

7. **Verificar os outputs gerados**:
   ```bash
   terraform output
   ```
   
   Este comando exibirá novamente os outputs, que incluem:
   - O endereço IP público da instância EC2 (`ec2_public_ip`)
   - O endpoint do banco de dados RDS (`rds_endpoint`)

8. **Acessar e configurar a aplicação**:

   - Conecte-se à instância EC2 usando SSH:
     ```bash
     ssh -i /path/to/crud-app-key.pem ec2-user@[EC2_IP_ADDRESS]
     ```
     Substitua `[EC2_IP_ADDRESS]` pelo valor do output `ec2_public_ip`

   - Clone o repositório da aplicação na instância:
     ```bash
     git clone https://github.com/seu-usuario/crud-app.git
     cd crud-app/backend
     npm install
     ```

   - Configure as variáveis de ambiente para conexão com o banco de dados:
     ```bash
     export DB_HOST=[RDS_ENDPOINT_SEM_PORTA]
     export DB_USER=crudadmin
     export DB_PASSWORD=#Projeto292307
     export DB_NAME=crud_app
     ```
     Substitua `[RDS_ENDPOINT_SEM_PORTA]` pela parte do endpoint RDS antes do `:3306`

   - Execute o script para criar o schema do banco de dados:
     ```bash
     mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME < database/schema.sql
     ```

   - Inicie o servidor backend:
     ```bash
     npm start
     ```

9. **Acesse a aplicação**:

   Abra o navegador e acesse `http://[EC2_IP_ADDRESS]:3000`

## Executando o Frontend React

### Modo de Desenvolvimento

Para executar o frontend em modo de desenvolvimento:

```bash
# Navegar até o diretório do frontend
cd frontend

# Instalar dependências (se ainda não instalou)
npm install

# Iniciar o servidor de desenvolvimento
npm start
```

O servidor de desenvolvimento React será iniciado na porta 3000. Abra seu navegador em `http://localhost:3000` para visualizar a aplicação. O servidor tem hot-reload habilitado, então as alterações no código serão automaticamente aplicadas.

### Modo de Produção

Para construir e executar o frontend para produção:

```bash
# Construir o aplicativo React
cd frontend
npm run build

# Os arquivos estarão disponíveis na pasta 'frontend/build'
# O backend está configurado para servir estes arquivos estáticos
```

Após o build, inicie o servidor backend que servirá os arquivos estáticos:

```bash
cd backend
npm start
```

Acesse a aplicação em `http://localhost:3001`.

### Solução de Problemas Comuns

1. **Erro de conexão com a API**:
   - Verifique se o backend está rodando na porta correta
   - Confirme que o arquivo `package.json` do frontend tem a linha: `"proxy": "http://localhost:3001"`

2. **Erros de CORS**:
   - Certifique-se de que o backend tem o middleware CORS configurado corretamente

3. **Erro "Invalid options object. Dev Server has been initialized using an options object that does not match the API schema"**:
   - Crie um arquivo `.env` no diretório do frontend com o seguinte conteúdo:
     ```
     DANGEROUSLY_DISABLE_HOST_CHECK=true
     WDS_SOCKET_HOST=localhost
     ```
   - Alternativa: Crie um arquivo `setupProxy.js` na pasta `src`:
     ```javascript
     module.exports = function(app) {
       app.use((req, res, next) => {
         res.header('Access-Control-Allow-Origin', '*');
         next();
       });
     };
     ```

4. **Avisos de pacotes deprecados**:
   ```bash
   # Atualizar pacotes com vulnerabilidades (modo seguro)
   npm audit fix
   ```

5. **Para desenvolvimento avançado**:
   Considere migrar para ferramentas mais modernas como Vite:
   ```bash
   npm create vite@latest my-new-crud-app -- --template react
   ```

## Deploy na AWS

### Utilizando Terraform

1. **Inicializar o Terraform**:
   ```bash
   cd terraform
   terraform init
   ```
   
   Este comando inicializa o diretório de trabalho do Terraform, baixa os providers necessários e configura os módulos. Se executado com sucesso, você verá uma mensagem "Terraform has been successfully initialized!".

2. **Configurar Credenciais da AWS**:
   
   Antes de continuar, você precisa configurar suas credenciais da AWS:

   **Opção 1: Usando o AWS CLI**
   ```bash
   aws configure
   # Informe sua Access Key, Secret Key, região (ex: us-east-1) e formato de saída (json)
   ```

   **Opção 2: Variáveis de ambiente**
   ```bash
   # Windows
   set AWS_ACCESS_KEY_ID=sua-access-key
   set AWS_SECRET_ACCESS_KEY=sua-secret-key
   set AWS_REGION=us-east-1

   # Linux/macOS
   export AWS_ACCESS_KEY_ID=sua-access-key
   export AWS_SECRET_ACCESS_KEY=sua-secret-key
   export AWS_REGION=us-east-2
   ```

3. **Planejar a infraestrutura**:
   ```bash
   terraform plan
   ```
   
   Este comando mostra as mudanças que serão feitas na infraestrutura, sem aplicá-las ainda. Execute apenas este comando primeiro, sem combiná-lo com outros comandos.

4. **Aplicar a infraestrutura**:
   ```bash
   terraform apply -var="db_password=SuaSenhaSegura"
   ```
   
   Depois que o comando for executado, o Terraform mostrará o plano de execução e pedirá confirmação:
   
   ```
   Do you want to perform these actions?
   Terraform will perform the actions described acima.
   Only 'yes' will be accepted to approve.

   Enter a value:
   ```
   
   Digite `yes` e pressione Enter para iniciar a criação dos recursos. Não digite apenas "y" ou qualquer outra coisa, pois o Terraform só aceita "yes" como confirmação.

5. **Durante a execução do Terraform**:

   O Terraform começará a criar os recursos na AWS, mostrando o progresso de cada recurso. Este processo pode levar entre 10 a 20 minutos, principalmente a criação do banco de dados RDS.
   
   Exemplo de saída durante a execução:
   ```
   module.security_groups.aws_security_group.app_sg: Creating...
   module.vpc.aws_subnet.private: Creating...
   module.vpc.aws_subnet.private2: Creating...
   module.vpc.aws_subnet.public: Creating...
   ```

6. **Após a execução ser concluída**:

   Quando todos os recursos forem criados, você verá uma mensagem de sucesso e um resumo dos outputs:
   ```
   Apply complete! Resources: 10 added, 0 changed, 3 destroyed.

   Outputs:
   ec2_public_ip = "34.xxx.xxx.xxx"
   rds_endpoint = "crud-app-mysql.xxxxxx.us-east-1.rds.amazonaws.com:3306"
   ```

7. **Verificar os outputs gerados**:
   ```bash
   terraform output
   ```
   
   Este comando exibirá novamente os outputs, que incluem:
   - O endereço IP público da instância EC2 (`ec2_public_ip`)
   - O endpoint do banco de dados RDS (`rds_endpoint`)

8. **Acessar e configurar a aplicação**:

   - Conecte-se à instância EC2 usando SSH:
     ```bash
     ssh -i /path/to/crud-app-key.pem ec2-user@[EC2_IP_ADDRESS]
     ```
     Substitua `[EC2_IP_ADDRESS]` pelo valor do output `ec2_public_ip`

   - Clone o repositório da aplicação na instância:
     ```bash
     git clone https://github.com/seu-usuario/crud-app.git
     cd crud-app/backend
     npm install
     ```

   - Configure as variáveis de ambiente para conexão com o banco de dados:
     ```bash
     export DB_HOST=[RDS_ENDPOINT_SEM_PORTA]
     export DB_USER=crudadmin
     export DB_PASSWORD=#Projeto292307
     export DB_NAME=crud_app
     ```
     Substitua `[RDS_ENDPOINT_SEM_PORTA]` pela parte do endpoint RDS antes do `:3306`

   - Execute o script para criar o schema do banco de dados:
     ```bash
     mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME < database/schema.sql
     ```

   - Inicie o servidor backend:
     ```bash
     npm start
     ```

9. **Acesse a aplicação**:

   Abra o navegador e acesse `http://[EC2_IP_ADDRESS]:3000`

## Executando o Frontend React

### Modo de Desenvolvimento

Para executar o frontend em modo de desenvolvimento:

```bash
# Navegar até o diretório do frontend
cd frontend

# Instalar dependências (se ainda não instalou)
npm install

# Iniciar o servidor de desenvolvimento
npm start
```

O servidor de desenvolvimento React será iniciado na porta 3000. Abra seu navegador em `http://localhost:3000` para visualizar a aplicação. O servidor tem hot-reload habilitado, então as alterações no código serão automaticamente aplicadas.

### Modo de Produção

Para construir e executar o frontend para produção:

```bash
# Construir o aplicativo React
cd frontend
npm run build

# Os arquivos estarão disponíveis na pasta 'frontend/build'
# O backend está configurado para servir estes arquivos estáticos
```

Após o build, inicie o servidor backend que servirá os arquivos estáticos:

```bash
cd backend
npm start
```

Acesse a aplicação em `http://localhost:3001`.

### Solução de Problemas Comuns

1. **Erro de conexão com a API**:
   - Verifique se o backend está rodando na porta correta
   - Confirme que o arquivo `package.json` do frontend tem a linha: `"proxy": "http://localhost:3001"`

2. **Erros de CORS**:
   - Certifique-se de que o backend tem o middleware CORS configurado corretamente

3. **Erro "Invalid options object. Dev Server has been initialized using an options object that does not match the API schema"**:
   - Crie um arquivo `.env` no diretório do frontend com o seguinte conteúdo:
     ```
     DANGEROUSLY_DISABLE_HOST_CHECK=true
     WDS_SOCKET_HOST=localhost
     ```
   - Alternativa: Crie um arquivo `setupProxy.js` na pasta `src`:
     ```javascript
     module.exports = function(app) {
       app.use((req, res, next) => {
         res.header('Access-Control-Allow-Origin', '*');
         next();
       });
     };
     ```

4. **Avisos de pacotes deprecados**:
   ```bash
   # Atualizar pacotes com vulnerabilidades (modo seguro)
   npm audit fix
   ```

5. **Para desenvolvimento avançado**:
   Considere migrar para ferramentas mais modernas como Vite:
   ```bash
   npm create vite@latest my-new-crud-app -- --template react
   ```

## Deploy na AWS

### Utilizando Terraform

1. **Inicializar o Terraform**:
   ```bash
   cd terraform
   terraform init
   ```
   
   Este comando inicializa o diretório de trabalho do Terraform, baixa os providers necessários e configura os módulos. Se executado com sucesso, você verá uma mensagem "Terraform has been successfully initialized!".

2. **Configurar Credenciais da AWS**:
   
   Antes de continuar, você precisa configurar suas credenciais da AWS:

   **Opção 1: Usando o AWS CLI**
   ```bash
   aws configure
   # Informe sua Access Key, Secret Key, região (ex: us-east-1) e formato de saída (json)
   ```

   **Opção 2: Variáveis de ambiente**
   ```bash
   # Windows
   set AWS_ACCESS_KEY_ID=sua-access-key
   set AWS_SECRET_ACCESS_KEY=sua-secret-key
   set AWS_REGION=us-east-1

   # Linux/macOS
   export AWS_ACCESS_KEY_ID=sua-access-key
   export AWS_SECRET_ACCESS_KEY=sua-secret-key
   export AWS_REGION=us-east-2
   ```

3. **Planejar a infraestrutura**:
   ```bash
   terraform plan
   ```
   
   Este comando mostra as mudanças que serão feitas na infraestrutura, sem aplicá-las ainda. Execute apenas este comando primeiro, sem combiná-lo com outros comandos.

4. **Aplicar a infraestrutura**:
   ```bash
   terraform apply -var="db_password=SuaSenhaSegura"
   ```
   
   Depois que o comando for executado, o Terraform mostrará o plano de execução e pedirá confirmação:
   
   ```
   Do you want to perform these actions?
   Terraform will perform the actions described acima.
   Only 'yes' will be accepted to approve.

   Enter a value:
   ```
   
   Digite `yes` e pressione Enter para iniciar a criação dos recursos. Não digite apenas "y" ou qualquer outra coisa, pois o Terraform só aceita "yes" como confirmação.

5. **Durante a execução do Terraform**:

   O Terraform começará a criar os recursos na AWS, mostrando o progresso de cada recurso. Este processo pode levar entre 10 a 20 minutos, principalmente a criação do banco de dados RDS.
   
   Exemplo de saída durante a execução:
   ```
   module.security_groups.aws_security_group.app_sg: Creating...
   module.vpc.aws_subnet.private: Creating...
   module.vpc.aws_subnet.private2: Creating...
   module.vpc.aws_subnet.public: Creating...
   ```

6. **Após a execução ser concluída**:

   Quando todos os recursos forem criados, você verá uma mensagem de sucesso e um resumo dos outputs:
   ```
   Apply complete! Resources: 10 added, 0 changed, 3 destroyed.

   Outputs:
   ec2_public_ip = "34.xxx.xxx.xxx"
   rds_endpoint = "crud-app-mysql.xxxxxx.us-east-1.rds.amazonaws.com:3306"
   ```

7. **Verificar os outputs gerados**:
   ```bash
   terraform output
   ```
   
   Este comando exibirá novamente os outputs, que incluem:
   - O endereço IP público da instância EC2 (`ec2_public_ip`)
   - O endpoint do banco de dados RDS (`rds_endpoint`)

8. **Acessar e configurar a aplicação**:

   - Conecte-se à instância EC2 usando SSH:
     ```bash
     ssh -i /path/to/crud-app-key.pem ec2-user@[EC2_IP_ADDRESS]
     ```
     Substitua `[EC2_IP_ADDRESS]` pelo valor do output `ec2_public_ip`

   - Clone o repositório da aplicação na instância:
     ```bash
     git clone https://github.com/seu-usuario/crud-app.git
     cd crud-app/backend
     npm install
     ```

   - Configure as variáveis de ambiente para conexão com o banco de dados:
     ```bash
     export DB_HOST=[RDS_ENDPOINT_SEM_PORTA]
     export DB_USER=crudadmin
     export DB_PASSWORD=#Projeto292307
     export DB_NAME=crud_app
     ```
     Substitua `[RDS_ENDPOINT_SEM_PORTA]` pela parte do endpoint RDS antes do `:3306`

   - Execute o script para criar o schema do banco de dados:
     ```bash
     mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME < database/schema.sql
     ```

   - Inicie o servidor backend:
     ```bash
     npm start
     ```

9. **Acesse a aplicação**:

   Abra o navegador e acesse `http://[EC2_IP_ADDRESS]:3000`

## Executando o Frontend React

### Modo de Desenvolvimento

Para executar o frontend em modo de desenvolvimento:

```bash
# Navegar até o diretório do frontend
cd frontend

# Instalar dependências (se ainda não instalou)
npm install

# Iniciar o servidor de desenvolvimento
npm start
```

O servidor de desenvolvimento React será iniciado na porta 3000. Abra seu navegador em `http://localhost:3000` para visualizar a aplicação. O servidor tem hot-reload habilitado, então as alterações no código serão automaticamente aplicadas.

### Modo de Produção

Para construir e executar o frontend para produção:

```bash
# Construir o aplicativo React
cd frontend
npm run build

# Os arquivos estarão disponíveis na pasta 'frontend/build'
# O backend está configurado para servir estes arquivos estáticos
```

Após o build, inicie o servidor backend que servirá os arquivos estáticos:

```bash
cd backend
npm start
```

Acesse a aplicação em `http://localhost:3001`.

### Solução de Problemas Comuns

1. **Erro de conexão com a API**:
   - Verifique se o backend está rodando na porta correta
   - Confirme que o arquivo `package.json` do frontend tem a linha: `"proxy": "http://localhost:3001"`

2. **Erros de CORS**:
   - Certifique-se de que o backend tem o middleware CORS configurado corretamente

3. **Erro "Invalid options object. Dev Server has been initialized using an options object that does not match the API schema"**:
   - Crie um arquivo `.env` no diretório do frontend com o seguinte conteúdo:
     ```
     DANGEROUSLY_DISABLE_HOST_CHECK=true
     WDS_SOCKET_HOST=localhost
     ```
   - Alternativa: Crie um arquivo `setupProxy.js` na pasta `src`:
     ```javascript
     module.exports = function(app) {
       app.use((req, res, next) => {
         res.header('Access-Control-Allow-Origin', '*');
         next();
       });
     };
     ```

4. **Avisos de pacotes deprecados**:
   ```bash
   # Atualizar pacotes com vulnerabilidades (modo seguro)
   npm audit fix
   ```

5. **Para desenvolvimento avançado**:
   Considere migrar para ferramentas mais modernas como Vite:
   ```bash
   npm create vite@latest my-new-crud-app -- --template react
   ```

## Deploy na AWS

### Utilizando Terraform

1. **Inicializar o Terraform**:
   ```bash
   cd terraform
   terraform init
   ```
   
   Este comando inicializa o diretório de trabalho do Terraform, baixa os providers necessários e configura os módulos. Se executado com sucesso, você verá uma mensagem "Terraform has been successfully initialized!".

2. **Configurar Credenciais da AWS**:
   
   Antes de continuar, você precisa configurar suas credenciais da AWS:

   **Opção 1: Usando o AWS CLI**
   ```bash
   aws configure
   # Informe sua Access Key, Secret Key, região (ex: us-east-1) e formato de saída (json)
   ```

   **Opção 2: Variáveis de ambiente**
   ```bash
   # Windows
   set AWS_ACCESS_KEY_ID=sua-access-key
   set AWS_SECRET_ACCESS_KEY=sua-secret-key
   set AWS_REGION=us-east-1

   # Linux/macOS
   export AWS_ACCESS_KEY_ID=sua-access-key
   export AWS_SECRET_ACCESS_KEY=sua-secret-key
   export AWS_REGION=us-east-2
   ```

3. **Planejar a infraestrutura**:
   ```bash
   terraform plan
   ```
   
   Este comando mostra as mudanças que serão feitas na infraestrutura, sem aplicá-las ainda. Execute apenas este comando primeiro, sem combiná-lo com outros comandos.

4. **Aplicar a infraestrutura**:
   ```bash
   terraform apply -var="db_password=SuaSenhaSegura"
   ```
   
   Depois que o comando for executado, o Terraform mostrará o plano de execução e pedirá confirmação:
   
   ```
   Do you want to perform these actions?
   Terraform will perform the actions described acima.
   Only 'yes' will be accepted to approve.

   Enter a value:
   ```
   
   Digite `yes` e pressione Enter para iniciar a criação dos recursos. Não digite apenas "y" ou qualquer outra coisa, pois o Terraform só aceita "yes" como confirmação.

5. **Durante a execução do Terraform**:

   O Terraform começará a criar os recursos na AWS, mostrando o progresso de cada recurso. Este processo pode levar entre 10 a 20 minutos, principalmente a criação do banco de dados RDS.
   
   Exemplo de saída durante a execução:
   ```
   module.security_groups.aws_security_group.app_sg: Creating...
   module.vpc.aws_subnet.private: Creating...
   module.vpc.aws_subnet.private2: Creating...
   module.vpc.aws_subnet.public: Creating...
   ```

6. **Após a execução ser concluída**:

   Quando todos os recursos forem criados, você verá uma mensagem de sucesso e um resumo dos outputs:
   ```
   Apply complete! Resources: 10 added, 0 changed, 3 destroyed.

   Outputs:
   ec2_public_ip = "34.xxx.xxx.xxx"
   rds_endpoint = "crud-app-mysql.xxxxxx.us-east-1.rds.amazonaws.com:3306"
   ```

7. **Verificar os outputs gerados**:
   ```bash
   terraform output
   ```
   
   Este comando exibirá novamente os outputs, que incluem:
   - O endereço IP público da instância EC2 (`ec2_public_ip`)
   - O endpoint do banco de dados RDS (`rds_endpoint`)

8. **Acessar e configurar a aplicação**:

   - Conecte-se à instância EC2 usando SSH:
     ```bash
     ssh -i /path/to/crud-app-key.pem ec2-user@[EC2_IP_ADDRESS]
     ```
     Substitua `[EC2_IP_ADDRESS]` pelo valor do output `ec2_public_ip`

   - Clone o repositório da aplicação na instância:
     ```bash
     git clone https://github.com/seu-usuario/crud-app.git
     cd crud-app/backend
     npm install
     ```

   - Configure as variáveis de ambiente para conexão com o banco de dados:
     ```bash
     export DB_HOST=[RDS_ENDPOINT_SEM_PORTA]
     export DB_USER=crudadmin
     export DB_PASSWORD=#Projeto292307
     export DB_NAME=crud_app
     ```
     Substitua `[RDS_ENDPOINT_SEM_PORTA]` pela parte do endpoint RDS antes do `:3306`

   - Execute o script para criar o schema do banco de dados:
     ```bash
     mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME < database/schema.sql
     ```

   - Inicie o servidor backend:
     ```bash
     npm start
     ```

9. **Acesse a aplicação**:

   Abra o navegador e acesse `http://[EC2_IP_ADDRESS]:3000`

## Erros Comuns no Terraform

1. **Erro de Key Pair não encontrado**:

   ```
   Error: creating EC2 Instance: operation error EC2: RunInstances, api error InvalidKeyPair.NotFound: The key pair 'crud-app-key' does not exist
   ```

   **Solução**: Este erro ocorre porque o Terraform está tentando usar um par de chaves SSH que não existe na sua conta AWS. Para resolver:

   **Opção 1**: Crie o key pair manualmente no console da AWS
   - Acesse o [Console AWS](https://console.aws.amazon.com)
   - Navegue até EC2 > Key Pairs
   - Clique em "Criar key pair"
   - Nomeie como "crud-app-key"
   - Selecione o formato .pem (para OpenSSH) ou .ppk (para PuTTY)
   - Faça download e guarde a chave privada em local seguro
   - Execute novamente o comando `terraform apply` 

   **Opção 2**: Modifique o Terraform para criar o key pair automaticamente
   - Crie um arquivo chamado `key.tf` na pasta `terraform` com o seguinte conteúdo:

   ```hcl
   resource "tls_private_key" "pk" {
     algorithm = "RSA"
     rsa_bits  = 4096
   }

   resource "aws_key_pair" "generated_key" {
     key_name   = var.key_name
     public_key = tls_private_key.pk.public_key_openssh

     provisioner "local-exec" {
       command = "echo '${tls_private_key.pk.private_key_pem}' > ./${var.key_name}.pem && chmod 400 ./${var.key_name}.pem"
     }
   }
   ```

   - Adicione ao arquivo `main.tf` o provider necessário:
   
   ```hcl
   terraform {
     required_providers {
       aws = {
         source  = "hashicorp/aws"
         version = "~> 5.0"
       }
       tls = {
         source  = "hashicorp/tls"
         version = "~> 4.0"
       }
     }
   }
   ```

   - Execute `terraform init` para instalar o novo provider
   - Execute `terraform apply` novamente

   **Opção 3**: Utilize um key pair existente
   - Se você já tem um par de chaves (key pair) na AWS, modifique o valor da variável `key_name` no arquivo `variables.tf`:

   ```hcl
   variable "key_name" {
     description = "Nome do key pair para acesso SSH"
     default     = "nome-do-seu-key-pair-existente"  # Substitua pelo nome do seu key pair
   }
   ```

2. **Após resolver o problema do key pair**:
   Execute novamente o comando:
   ```bash
   terraform apply -var="db_password=#Projeto292307"
   ```

## Próximos passos após implantação bem-sucedida da infraestrutura

Parabéns! A infraestrutura foi implantada com sucesso na AWS. Vou guiá-lo pelos próximos passos para configurar e acessar sua aplicação.

## Acessando a infraestrutura na AWS

Após a execução bem-sucedida do `terraform apply`, você terá os seguintes recursos disponíveis:

- **Instância EC2**: IP público = 3.22.180.105
- **Banco de dados RDS**: Endpoint = crud-app-mysql.c1c6gg8miu1e.us-east-2.rds.amazonaws.com:3306

### 1. Conectar à instância EC2 via SSH

```bash
# No Windows usando o Terminal ou PowerShell
ssh -i "c:\Users\david\Downloads\crud-app-key.pem" ec2-user@3.22.180.105
```

Quando você se conectar pela primeira vez, verá uma mensagem sobre a autenticidade do host:

```
The authenticity of host '3.22.180.105 (3.22.180.105)' can't be established.
ED25519 key fingerprint is SHA256:u4k+FvmZg2ngr9N/aKX85eOmXCj1IND3He0+gTNcxZM.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])?
```

**O que isso significa**: 
- Esta é uma mensagem de segurança normal quando você se conecta a um servidor pela primeira vez
- O SSH está verificando se você confia neste servidor antes de estabelecer a conexão
- Digite `yes` e pressione Enter para confirmar e continuar
- A chave do servidor será adicionada ao arquivo `known_hosts` e você não verá esta mensagem novamente para este servidor

Se encontrar erros de permissão no Windows:
```bash
# Execute isto no PowerShell para corrigir permissões da chave
icacls "c:\Users\david\Downloads\crud-app-key.pem" /inheritance:r /grant:r "$($env:USERNAME):(R,W)"
```

### 2. Configurar a aplicação na instância EC2

Agora que você está conectado via SSH (você verá o prompt `[ec2-user@ip-10-0-1-242 ~]$`), siga estas etapas:

```bash
# Atualizar o sistema
sudo yum update -y

# Instalar o Git 
sudo yum install git -y

# Instalar o Node.js e NPM
curl -sL https://rpm.nodesource.com/setup_16.x | sudo bash -
sudo yum install -y nodejs

# Verificar instalação
node -v
npm -v

# Criar uma pasta para a aplicação
mkdir -p ~/crud-app/backend
mkdir -p ~/crud-app/frontend

# Criar um arquivo server.js básico para teste
cat > ~/crud-app/backend/server.js << 'EOF'
const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.send('Hello from AWS EC2! CRUD App is running.');
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
EOF

# Criar o arquivo package.json para o backend
cat > ~/crud-app/backend/package.json << 'EOF'
{
  "name": "crud-backend",
  "version": "1.0.0",
  "description": "Backend para aplicação CRUD",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.17.1"
  }
}
EOF

# Instalar dependências do backend
cd ~/crud-app/backend
npm install

# Configurar as variáveis de ambiente para conexão com o banco de dados
cat > .env << EOF
NODE_ENV=production
DB_HOST=crud-app-mysql.c1c6gg8miu1e.us-east-2.rds.amazonaws.com
DB_USER=crudadmin
DB_PASSWORD=#Projeto292307
DB_NAME=crud_app
PORT=3000
EOF

# Iniciar o servidor para testar
node server.js
```

Você deverá ver a mensagem: `Server running on port 3000`

Pressione `Ctrl+C` para parar o servidor de teste.

### 3. Abrir a porta no Security Group

Antes de acessar a aplicação, precisamos garantir que a porta 3000 está aberta no Security Group:

1. Abra o Console AWS (em outra janela do navegador)
2. Vá para EC2 > Instâncias > Selecione sua instância
3. Na aba "Segurança", clique no Security Group
4. Adicione uma regra de entrada: Tipo = TCP personalizado, Porta = 3000, Origem = 0.0.0.0/0

### 4. Iniciar a aplicação em modo background

```bash
# Volte à pasta do backend
cd ~/crud-app/backend

# Inicie o servidor em segundo plano
nohup node server.js > app.log 2>&1 &

# Verifique se está rodando
ps aux | grep node
```

### 5. Acessar a aplicação

Agora você pode acessar a aplicação em:
http://3.22.180.105:3000

Você deve ver a mensagem "Hello from AWS EC2! CRUD App is running."

### 6. Próximos passos

Agora que você tem uma aplicação básica rodando, você pode:

1. Implantar seu código real (substituindo o server.js de teste)
2. Configurar o frontend React
3. Configurar o banco de dados MySQL no RDS

Para implementar a aplicação completa, siga o resto das instruções na seção anterior
