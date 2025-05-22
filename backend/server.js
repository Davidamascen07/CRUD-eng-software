const express = require('express');
const mysql = require('mysql2/promise');
const cors = require('cors');
const path = require('path');

const app = express();
const port = process.env.PORT || 3001;

// Middleware
app.use(cors());
app.use(express.json());

// Servir arquivos estáticos do React após o build
app.use(express.static(path.join(__dirname, '../frontend/build')));

// Configuração do banco de dados
const dbConfig = {
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'crud_app',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
};

// Criando pool de conexões
const pool = mysql.createPool(dbConfig);

// Testar conexão com o banco
async function testDatabaseConnection() {
  try {
    const connection = await pool.getConnection();
    console.log('Conexão com o banco de dados estabelecida com sucesso!');
    connection.release();
  } catch (error) {
    console.error('Erro ao conectar ao banco de dados:', error);
    process.exit(1);
  }
}

// Rotas da API
app.get('/api/items', async (req, res) => {
  try {
    const [rows] = await pool.execute('SELECT * FROM items ORDER BY id DESC');
    res.json(rows);
  } catch (error) {
    console.error('Erro ao buscar items:', error);
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
    console.error('Erro ao buscar item:', error);
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
    console.error('Erro ao criar item:', error);
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
    console.error('Erro ao atualizar item:', error);
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
    console.error('Erro ao excluir item:', error);
    res.status(500).json({ message: 'Erro ao excluir item' });
  }
});

// Rota fallback para o React Router
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, '../frontend/build', 'index.html'));
});

// Iniciar o servidor
async function startServer() {
  await testDatabaseConnection();
  app.listen(port, () => {
    console.log(`Servidor rodando na porta ${port}`);
  });
}

startServer();
