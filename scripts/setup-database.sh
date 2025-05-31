#!/bin/bash

EC2_IP="3.22.180.105"
RDS_ENDPOINT="crud-app-mysql.c1c6gg8miu1e.us-east-2.rds.amazonaws.com"
KEY_FILE="~/.ssh/crud-app-key.pem"

echo "🗄️ Configurando banco de dados..."

# Script SQL para executar no servidor
cat > /tmp/setup-db.sql << 'EOF'
CREATE DATABASE IF NOT EXISTS crud_app;
USE crud_app;

CREATE TABLE IF NOT EXISTS items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  status ENUM('active', 'inactive') DEFAULT 'active',
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  updatedAt DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO items (name, description, status, createdAt) VALUES
('Produto A', 'Primeira demonstração do sistema CRUD', 'active', NOW()),
('Produto B', 'Segunda demonstração com status ativo', 'active', NOW()),
('Produto C', 'Terceira demonstração com status inativo', 'inactive', NOW()),
('Serviço X', 'Exemplo de serviço cadastrado no sistema', 'active', NOW()),
('Serviço Y', 'Outro exemplo de serviço', 'inactive', NOW());

SELECT 'Banco configurado com sucesso!' as message;
SELECT COUNT(*) as total_items FROM items;
SELECT * FROM items ORDER BY id;
EOF

echo "📤 Enviando script SQL..."
scp -i $KEY_FILE -o StrictHostKeyChecking=no /tmp/setup-db.sql ec2-user@$EC2_IP:/tmp/

echo "🔧 Executando configuração do banco..."
ssh -i $KEY_FILE -o StrictHostKeyChecking=no ec2-user@$EC2_IP \
    "mysql -h $RDS_ENDPOINT -u crudadmin -pChangeMe123! < /tmp/setup-db.sql"

echo "✅ Banco de dados configurado!"
echo "🌐 Teste a aplicação em: http://$EC2_IP:3001"
