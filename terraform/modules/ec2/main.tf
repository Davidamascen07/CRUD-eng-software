# Instância EC2 otimizada para Free Tier
resource "aws_instance" "app_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name
  
  # Configurações Free Tier
  monitoring                  = false
  associate_public_ip_address = true
  
  # Volume raiz otimizado para Free Tier
  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
    encrypted             = false
  }
  
  # Script de inicialização corrigido
  user_data = <<-EOF
              #!/bin/bash
              exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
              echo "Iniciando configuração da instância..."
              
              yum update -y
              yum install -y git nodejs npm sqlite3 htop
              
              echo "NODE_ENV=production" >> /etc/environment
              echo "PORT=3001" >> /etc/environment
              echo "USE_SQLITE=true" >> /etc/environment
              echo "SQLITE_PATH=/home/ec2-user/app/database.sqlite" >> /etc/environment
              
              mkdir -p /home/ec2-user/app
              cd /home/ec2-user/app
              
              cat > server.js << 'EOFJS'
const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const path = require('path');
const cors = require('cors');

const app = express();
const port = process.env.PORT || 3001;

app.use(cors());
app.use(express.json());

const dbPath = path.join(__dirname, 'database.sqlite');
const db = new sqlite3.Database(dbPath, (err) => {
  if (err) {
    console.error('Erro SQLite:', err);
  } else {
    console.log('SQLite conectado:', dbPath);
  }
});

db.serialize(() => {
  db.run("PRAGMA journal_mode = WAL");
  db.run("PRAGMA synchronous = NORMAL");
  db.run("PRAGMA cache_size = 1000");
  
  db.run(\`CREATE TABLE IF NOT EXISTS items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT,
    status TEXT DEFAULT 'active',
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
  )\`);
  
  db.run(\`INSERT OR IGNORE INTO items (id, name, description, status) VALUES 
    (1, 'Exemplo AWS Free Tier', 'Item criado automaticamente no deploy gratuito', 'active'),
    (2, 'SQLite na EC2', 'Banco de dados local sem custos adicionais', 'active'),
    (3, 'CRUD Completo', 'Todas as operações funcionando na nuvem', 'active')\`);
});

app.get('/health', (req, res) => {
  res.json({ 
    status: 'healthy', 
    timestamp: new Date(),
    uptime: process.uptime(),
    database: 'SQLite Local'
  });
});

app.get('/', (req, res) => {
  res.json({ 
    message: 'CRUD App funcionando na AWS Free Tier!', 
    timestamp: new Date(),
    database: 'SQLite',
    instance: 't2.micro',
    cost: 'Gratuito (Free Tier)'
  });
});

app.get('/api/items', (req, res) => {
  db.all("SELECT * FROM items ORDER BY createdAt DESC", [], (err, rows) => {
    if (err) {
      console.error('Erro ao buscar itens:', err);
      res.status(500).json({ error: err.message });
      return;
    }
    res.json(rows);
  });
});

app.get('/api/items/:id', (req, res) => {
  const { id } = req.params;
  db.get("SELECT * FROM items WHERE id = ?", [id], (err, row) => {
    if (err) {
      res.status(500).json({ error: err.message });
      return;
    }
    if (!row) {
      res.status(404).json({ error: 'Item não encontrado' });
      return;
    }
    res.json(row);
  });
});

app.post('/api/items', (req, res) => {
  const { name, description, status } = req.body;
  if (!name) {
    return res.status(400).json({ error: 'Nome é obrigatório' });
  }
  
  db.run("INSERT INTO items (name, description, status) VALUES (?, ?, ?)", 
    [name, description, status || 'active'], function(err) {
    if (err) {
      res.status(500).json({ error: err.message });
      return;
    }
    res.status(201).json({ 
      id: this.lastID, 
      name, 
      description, 
      status: status || 'active',
      message: 'Item criado com sucesso'
    });
  });
});

app.put('/api/items/:id', (req, res) => {
  const { name, description, status } = req.body;
  const { id } = req.params;
  
  if (!name) {
    return res.status(400).json({ error: 'Nome é obrigatório' });
  }
  
  db.run("UPDATE items SET name = ?, description = ?, status = ?, updatedAt = CURRENT_TIMESTAMP WHERE id = ?",
    [name, description, status, id], function(err) {
    if (err) {
      res.status(500).json({ error: err.message });
      return;
    }
    if (this.changes === 0) {
      return res.status(404).json({ error: 'Item não encontrado' });
    }
    res.json({ id: parseInt(id), name, description, status, message: 'Item atualizado' });
  });
});

app.delete('/api/items/:id', (req, res) => {
  const { id } = req.params;
  db.run("DELETE FROM items WHERE id = ?", id, function(err) {
    if (err) {
      res.status(500).json({ error: err.message });
      return;
    }
    if (this.changes === 0) {
      return res.status(404).json({ error: 'Item não encontrado' });
    }
    res.json({ message: 'Item excluído com sucesso', id: parseInt(id) });
  });
});

process.on('SIGTERM', () => {
  console.log('Encerrando aplicação...');
  db.close();
  process.exit(0);
});

app.listen(port, '0.0.0.0', () => {
  console.log('Servidor rodando na porta ' + port);
  console.log('Executando no AWS Free Tier');
  console.log('Usando SQLite local (sem custos)');
});
EOFJS
              
              cat > package.json << 'EOFJSON'
{
  "name": "crud-app-free-tier",
  "version": "1.0.0",
  "description": "CRUD App otimizado para AWS Free Tier",
  "main": "server.js",
  "dependencies": {
    "express": "^4.18.2",
    "sqlite3": "^5.1.6",
    "cors": "^2.8.5"
  }
}
EOFJSON
              
              npm install --production
              chown -R ec2-user:ec2-user /home/ec2-user/app
              
              cat > /etc/systemd/system/crud-app.service << 'EOFSVC'
[Unit]
Description=CRUD App - AWS Free Tier
After=network.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=/home/ec2-user/app
ExecStart=/usr/bin/node server.js
Restart=always
RestartSec=10
Environment=NODE_ENV=production
Environment=USE_SQLITE=true
Environment=PORT=3001

[Install]
WantedBy=multi-user.target
EOFSVC
              
              systemctl daemon-reload
              systemctl enable crud-app
              systemctl start crud-app
              
              echo "Instalação concluída com sucesso!"
              EOF
  
  tags = {
    Name = "${var.project_name}-free-tier-server"
    Environment = "Free-Tier"
  }
}

# AMI mais recente do Amazon Linux 2
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Elastic IP gratuito (1 por instância no Free Tier)
resource "aws_eip" "app_eip" {
  instance = aws_instance.app_server.id
  domain   = "vpc"
  
  tags = {
    Name = "${var.project_name}-free-eip"
    Environment = "Free-Tier"
  }
}
