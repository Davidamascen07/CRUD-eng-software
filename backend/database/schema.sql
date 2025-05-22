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

-- Inserir dados de exemplo
INSERT INTO items (name, description, status, createdAt) VALUES
('Item 1', 'Primeiro item de exemplo', 'active', NOW()),
('Item 2', 'Segundo item de exemplo', 'active', NOW()),
('Item 3', 'Terceiro item de exemplo com uma descrição mais longa para testar o layout da tabela', 'inactive', NOW()),
('Item 4', 'Quarto item de exemplo', 'active', NOW()),
('Item 5', 'Quinto item de exemplo', 'inactive', NOW()),
('Item 6', 'Sexto item de exemplo', 'active', NOW()),
('Item 7', 'Sétimo item de exemplo', 'inactive', NOW()),
('Item 8', 'Oitavo item de exemplo', 'active', NOW()),
('Item 9', 'Nono item de exemplo', 'inactive', NOW()),
('Item 10', 'Décimo item de exemplo', 'active', NOW());
