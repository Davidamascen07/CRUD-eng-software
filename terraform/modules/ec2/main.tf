# Instância EC2 para a aplicação
resource "aws_instance" "app_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name
  
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y git nodejs npm sqlite3
              
              # Configurar variáveis de ambiente do sistema
              echo "NODE_ENV=production" >> /etc/environment
              echo "PORT=3001" >> /etc/environment
              echo "USE_SQLITE=true" >> /etc/environment
              echo "SQLITE_PATH=/home/ec2-user/app/database.sqlite" >> /etc/environment
              
              # Criar diretório da aplicação
              mkdir -p /home/ec2-user/app
              cd /home/ec2-user/app
              
              # Clonar o repositório (ajuste a URL conforme necessário)
              # git clone https://github.com/seu-usuario/CRUD-eng-software.git .
              
              # Por enquanto, criar servidor básico com SQLite
              cat > server.js << 'EOL'
const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const path = require('path');
const cors = require('cors');
const app = express();
const port = process.env.PORT || 3001;

app.use(cors());
app.use(express.json());

// Configurar SQLite
const dbPath = path.join(__dirname, 'database.sqlite');
const db = new sqlite3.Database(dbPath);

// Criar tabela se não existir
db.serialize(() => {
  db.run(`CREATE TABLE IF NOT EXISTS items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT,
    status TEXT DEFAULT 'active',
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
  )`);
  
  // Inserir dados de exemplo
  db.run(`INSERT OR IGNORE INTO items (id, name, description, status) VALUES 
    (1, 'Item de Exemplo', 'Este é um item de exemplo criado automaticamente', 'active')`);
});

// Rotas da API
app.get('/', (req, res) => {
  res.json({ 
    message: 'CRUD App funcionando com SQLite na AWS!', 
    timestamp: new Date(),
    database: 'SQLite'
  });
});

app.get('/api/items', (req, res) => {
  db.all("SELECT * FROM items ORDER BY createdAt DESC", [], (err, rows) => {
    if (err) {
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
    res.json({ id: parseInt(id), name, description, status, message: 'Item atualizado com sucesso' });
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

app.listen(port, '0.0.0.0', () => {
  console.log(`Servidor rodando na porta ${port} com SQLite`);
});
EOL
              
              # Criar package.json
              cat > package.json << 'EOL'
{
  "name": "crud-app-aws",
  "version": "1.0.0",
  "main": "server.js",
  "dependencies": {
    "express": "^4.18.2",
    "sqlite3": "^5.1.6",
    "cors": "^2.8.5"
  }
}
EOL
              
              # Instalar dependências
              npm install
              
              # Alterar proprietário dos arquivos
              chown -R ec2-user:ec2-user /home/ec2-user/app
              
              # Criar serviço systemd
              cat > /etc/systemd/system/crud-app.service << 'EOL'
[Unit]
Description=CRUD App with SQLite
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
EOL
              
              # Habilitar e iniciar o serviço
              systemctl enable crud-app
              systemctl start crud-app
              EOF
  
  tags = {
    Name = "${var.project_name}-app-server"
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

# Elastic IP para a instância EC2
resource "aws_eip" "app_eip" {
  instance = aws_instance.app_server.id
  domain   = "vpc"  # Alterado de 'vpc = true' para 'domain = "vpc"'
  
  tags = {
    Name = "${var.project_name}-app-eip"
  }
}
