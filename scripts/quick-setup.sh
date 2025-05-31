#!/bin/bash

set -e

# Configurações específicas do seu deploy
EC2_IP="3.22.180.105"
RDS_ENDPOINT="crud-app-mysql.c1c6gg8miu1e.us-east-2.rds.amazonaws.com"
KEY_FILE="~/.ssh/crud-app-key.pem"

echo "🚀 Configuração rápida da aplicação CRUD"
echo "EC2 IP: $EC2_IP"
echo "RDS: $RDS_ENDPOINT"

# Script de configuração para executar no servidor
cat > /tmp/server-setup.sh << 'EOF'
#!/bin/bash
set -e

echo "📦 Instalando dependências..."
sudo yum update -y
sudo yum install -y git nodejs npm nginx mysql

echo "📁 Criando estrutura de diretórios..."
sudo mkdir -p /var/www/crud-app
sudo chown ec2-user:ec2-user /var/www/crud-app

echo "📋 Criando arquivos da aplicação..."
# Backend
mkdir -p /var/www/crud-app/backend
cd /var/www/crud-app/backend

# Package.json do backend
cat > package.json << 'BACKENDPKG'
{
  "name": "crud-app-backend",
  "version": "1.0.0",
  "description": "Backend para aplicação CRUD com MySQL",
  "main": "server.js",
  "scripts": {
    "start": "node server.js",
    "dev": "nodemon server.js"
  },
  "dependencies": {
    "cors": "^2.8.5",
    "express": "^4.18.2",
    "mysql2": "^2.3.3"
  }
}
BACKENDPKG

# Server.js do backend
cat > server.js << 'SERVERJS'
const express = require('express');
const mysql = require('mysql2/promise');
const cors = require('cors');
const path = require('path');

const app = express();
const port = process.env.PORT || 3001;

app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, '../frontend/build')));

const dbConfig = {
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'crud_app',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
};

const pool = mysql.createPool(dbConfig);

async function testDatabaseConnection() {
  try {
    const connection = await pool.getConnection();
    console.log('Conexão com o banco estabelecida!');
    connection.release();
  } catch (error) {
    console.error('Erro ao conectar:', error);
  }
}

app.get('/api/items', async (req, res) => {
  try {
    const [rows] = await pool.execute('SELECT * FROM items ORDER BY id DESC');
    res.json(rows);
  } catch (error) {
    console.error('Erro:', error);
    res.status(500).json({ message: 'Erro ao buscar items' });
  }
});

app.get('/api/items/:id', async (req, res) => {
  try {
    const [rows] = await pool.execute('SELECT * FROM items WHERE id = ?', [req.params.id]);
    if (rows.length === 0) {
      return res.status(404).json({ message: 'Item não encontrado' });
    }
    res.json(rows[0]);
  } catch (error) {
    res.status(500).json({ message: 'Erro ao buscar item' });
  }
});

app.post('/api/items', async (req, res) => {
  const { name, description, status } = req.body;
  if (!name) {
    return res.status(400).json({ message: 'Nome é obrigatório' });
  }
  try {
    const [result] = await pool.execute(
      'INSERT INTO items (name, description, status, createdAt) VALUES (?, ?, ?, NOW())',
      [name, description, status]
    );
    const [newItem] = await pool.execute('SELECT * FROM items WHERE id = ?', [result.insertId]);
    res.status(201).json(newItem[0]);
  } catch (error) {
    res.status(500).json({ message: 'Erro ao criar item' });
  }
});

app.put('/api/items/:id', async (req, res) => {
  const { name, description, status } = req.body;
  const id = req.params.id;
  if (!name) {
    return res.status(400).json({ message: 'Nome é obrigatório' });
  }
  try {
    const [result] = await pool.execute(
      'UPDATE items SET name = ?, description = ?, status = ?, updatedAt = NOW() WHERE id = ?',
      [name, description, status, id]
    );
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Item não encontrado' });
    }
    const [updatedItem] = await pool.execute('SELECT * FROM items WHERE id = ?', [id]);
    res.json(updatedItem[0]);
  } catch (error) {
    res.status(500).json({ message: 'Erro ao atualizar item' });
  }
});

app.delete('/api/items/:id', async (req, res) => {
  try {
    const [result] = await pool.execute('DELETE FROM items WHERE id = ?', [req.params.id]);
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Item não encontrado' });
    }
    res.json({ message: 'Item excluído com sucesso' });
  } catch (error) {
    res.status(500).json({ message: 'Erro ao excluir item' });
  }
});

app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, '../frontend/build', 'index.html'));
});

async function startServer() {
  await testDatabaseConnection();
  app.listen(port, () => {
    console.log(`Servidor rodando na porta ${port}`);
  });
}

startServer();
SERVERJS

echo "🔧 Instalando dependências do backend..."
npm install

echo "⚙️ Configurando variáveis de ambiente..."
cat > .env << ENVEOF
DB_HOST=crud-app-mysql.c1c6gg8miu1e.us-east-2.rds.amazonaws.com
DB_USER=crudadmin
DB_PASSWORD=ChangeMe123!
DB_NAME=crud_app
NODE_ENV=production
PORT=3001
ENVEOF

echo "🎨 Criando frontend básico..."
mkdir -p /var/www/crud-app/frontend/build
cd /var/www/crud-app/frontend/build

cat > index.html << 'FRONTENDHTML'
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CRUD App</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-100">
    <div class="container mx-auto px-4 py-8">
        <h1 class="text-3xl font-bold text-indigo-700 mb-8">
            <i class="fas fa-database mr-2"></i> Aplicação CRUD
        </h1>
        <div id="app"></div>
    </div>
    
    <script>
        const API_URL = '/api/items';
        let items = [];
        
        async function loadItems() {
            try {
                const response = await fetch(API_URL);
                items = await response.json();
                renderItems();
            } catch (error) {
                console.error('Erro:', error);
            }
        }
        
        function renderItems() {
            const app = document.getElementById('app');
            app.innerHTML = `
                <div class="bg-white rounded-lg shadow-md p-6 mb-6">
                    <h2 class="text-xl font-semibold mb-4">Adicionar Item</h2>
                    <div class="flex gap-4">
                        <input type="text" id="itemName" placeholder="Nome" class="flex-1 px-3 py-2 border rounded">
                        <input type="text" id="itemDesc" placeholder="Descrição" class="flex-1 px-3 py-2 border rounded">
                        <button onclick="addItem()" class="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600">
                            Adicionar
                        </button>
                    </div>
                </div>
                
                <div class="bg-white rounded-lg shadow-md overflow-hidden">
                    <table class="w-full">
                        <thead class="bg-gray-50">
                            <tr>
                                <th class="px-6 py-3 text-left">ID</th>
                                <th class="px-6 py-3 text-left">Nome</th>
                                <th class="px-6 py-3 text-left">Descrição</th>
                                <th class="px-6 py-3 text-left">Status</th>
                                <th class="px-6 py-3 text-left">Ações</th>
                            </tr>
                        </thead>
                        <tbody>
                            ${items.map(item => `
                                <tr class="border-t">
                                    <td class="px-6 py-4">${item.id}</td>
                                    <td class="px-6 py-4">${item.name}</td>
                                    <td class="px-6 py-4">${item.description || '-'}</td>
                                    <td class="px-6 py-4">
                                        <span class="px-2 py-1 text-xs rounded ${item.status === 'active' ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}">
                                            ${item.status === 'active' ? 'Ativo' : 'Inativo'}
                                        </span>
                                    </td>
                                    <td class="px-6 py-4">
                                        <button onclick="deleteItem(${item.id})" class="text-red-600 hover:text-red-800">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </td>
                                </tr>
                            `).join('')}
                        </tbody>
                    </table>
                </div>
            `;
        }
        
        async function addItem() {
            const name = document.getElementById('itemName').value;
            const description = document.getElementById('itemDesc').value;
            
            if (!name) return alert('Nome é obrigatório');
            
            try {
                await fetch(API_URL, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ name, description, status: 'active' })
                });
                
                document.getElementById('itemName').value = '';
                document.getElementById('itemDesc').value = '';
                loadItems();
            } catch (error) {
                console.error('Erro:', error);
            }
        }
        
        async function deleteItem(id) {
            if (!confirm('Excluir item?')) return;
            
            try {
                await fetch(`${API_URL}/${id}`, { method: 'DELETE' });
                loadItems();
            } catch (error) {
                console.error('Erro:', error);
            }
        }
        
        loadItems();
    </script>
</body>
</html>
FRONTENDHTML

echo "🔧 Configurando serviço systemd..."
sudo tee /etc/systemd/system/crud-app.service > /dev/null << 'SYSTEMDEOF'
[Unit]
Description=CRUD Application
After=network.target

[Service]
Environment=NODE_ENV=production
Environment=DB_HOST=crud-app-mysql.c1c6gg8miu1e.us-east-2.rds.amazonaws.com
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
SYSTEMDEOF

echo "🚀 Iniciando serviços..."
sudo systemctl daemon-reload
sudo systemctl enable crud-app
sudo systemctl start crud-app

echo "📡 Configurando Nginx..."
sudo tee /etc/nginx/conf.d/crud-app.conf > /dev/null << 'NGINXEOF'
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://localhost:3001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
NGINXEOF

sudo systemctl enable nginx
sudo systemctl start nginx

echo "✅ Configuração completa!"
echo "🌐 Acesse: http://3.22.180.105:3001"
EOF

echo "📤 Enviando script para o servidor..."
scp -i $KEY_FILE -o StrictHostKeyChecking=no /tmp/server-setup.sh ec2-user@$EC2_IP:/tmp/

echo "🔧 Executando configuração no servidor..."
ssh -i $KEY_FILE -o StrictHostKeyChecking=no ec2-user@$EC2_IP "chmod +x /tmp/server-setup.sh && /tmp/server-setup.sh"

echo ""
echo "🎉 CONFIGURAÇÃO CONCLUÍDA!"
echo "🌐 Sua aplicação está disponível em: http://$EC2_IP:3001"
echo ""
echo "Para configurar o banco de dados, execute:"
echo "ssh -i $KEY_FILE ec2-user@$EC2_IP"
echo "mysql -h $RDS_ENDPOINT -u crudadmin -p"
echo "# Digite a senha: ChangeMe123!"
