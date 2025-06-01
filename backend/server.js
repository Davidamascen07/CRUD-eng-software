const express = require('express');
const cors = require('cors');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3001;

// Middleware
app.use(cors());
app.use(express.json());

// Configuração do banco de dados - SQLite como padrão
const USE_SQLITE = process.env.USE_SQLITE !== 'false'; // SQLite por padrão
let db;

if (USE_SQLITE) {
  // Configuração SQLite
  const sqlite3 = require('sqlite3').verbose();
  const dbPath = process.env.SQLITE_PATH || path.join(__dirname, 'database.sqlite');
  
  db = new sqlite3.Database(dbPath, (err) => {
    if (err) {
      console.error('Erro ao conectar com SQLite:', err);
    } else {
      console.log('Conectado ao SQLite:', dbPath);
      // Criar tabela se não existir
      db.run(`CREATE TABLE IF NOT EXISTS items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        status TEXT DEFAULT 'active',
        createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
        updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
      )`);
    }
  });
} else {
  // Configuração MySQL
  const mysql = require('mysql2');
  
  db = mysql.createConnection({
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_NAME || 'crud_app'
  });
  
  db.connect((err) => {
    if (err) {
      console.error('Erro ao conectar com MySQL:', err);
    } else {
      console.log('Conectado ao MySQL');
    }
  });
}

// Funções helper para queries
const queryAsync = (sql, params = []) => {
  return new Promise((resolve, reject) => {
    if (USE_SQLITE) {
      if (sql.toLowerCase().includes('select')) {
        db.all(sql, params, (err, rows) => {
          if (err) reject(err);
          else resolve(rows);
        });
      } else {
        db.run(sql, params, function(err) {
          if (err) reject(err);
          else resolve({ insertId: this.lastID, affectedRows: this.changes });
        });
      }
    } else {
      db.query(sql, params, (err, results) => {
        if (err) reject(err);
        else resolve(results);
      });
    }
  });
};

// Rotas
app.get('/', (req, res) => {
  res.json({ 
    message: `CRUD App funcionando com ${USE_SQLITE ? 'SQLite' : 'MySQL'}!`, 
    timestamp: new Date(),
    database: USE_SQLITE ? 'SQLite' : 'MySQL'
  });
});

// GET - Listar todos os itens
app.get('/api/items', async (req, res) => {
  try {
    const items = await queryAsync('SELECT * FROM items ORDER BY createdAt DESC');
    res.json(items);
  } catch (error) {
    console.error('Erro ao buscar itens:', error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

// GET - Buscar item por ID
app.get('/api/items/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const sql = USE_SQLITE ? 
      'SELECT * FROM items WHERE id = ?' : 
      'SELECT * FROM items WHERE id = ?';
    
    const items = await queryAsync(sql, [id]);
    
    if (items.length === 0) {
      return res.status(404).json({ error: 'Item não encontrado' });
    }
    
    res.json(items[0]);
  } catch (error) {
    console.error('Erro ao buscar item:', error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

// POST - Criar novo item
app.post('/api/items', async (req, res) => {
  try {
    const { name, description, status } = req.body;
    
    if (!name) {
      return res.status(400).json({ error: 'Nome é obrigatório' });
    }
    
    const sql = USE_SQLITE ?
      'INSERT INTO items (name, description, status) VALUES (?, ?, ?)' :
      'INSERT INTO items (name, description, status) VALUES (?, ?, ?)';
    
    const result = await queryAsync(sql, [name, description, status || 'active']);
    
    res.status(201).json({
      id: result.insertId,
      name,
      description,
      status: status || 'active',
      message: 'Item criado com sucesso'
    });
  } catch (error) {
    console.error('Erro ao criar item:', error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

// PUT - Atualizar item
app.put('/api/items/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { name, description, status } = req.body;
    
    if (!name) {
      return res.status(400).json({ error: 'Nome é obrigatório' });
    }
    
    const sql = USE_SQLITE ?
      'UPDATE items SET name = ?, description = ?, status = ?, updatedAt = CURRENT_TIMESTAMP WHERE id = ?' :
      'UPDATE items SET name = ?, description = ?, status = ?, updatedAt = NOW() WHERE id = ?';
    
    const result = await queryAsync(sql, [name, description, status, id]);
    
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Item não encontrado' });
    }
    
    res.json({
      id: parseInt(id),
      name,
      description,
      status,
      message: 'Item atualizado com sucesso'
    });
  } catch (error) {
    console.error('Erro ao atualizar item:', error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

// DELETE - Excluir item
app.delete('/api/items/:id', async (req, res) => {
  try {
    const { id } = req.params;
    
    const result = await queryAsync('DELETE FROM items WHERE id = ?', [id]);
    
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Item não encontrado' });
    }
    
    res.json({ message: 'Item excluído com sucesso', id: parseInt(id) });
  } catch (error) {
    console.error('Erro ao excluir item:', error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

// Iniciar servidor
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
  console.log(`Usando banco de dados: ${USE_SQLITE ? 'SQLite' : 'MySQL'}`);
});

// Graceful shutdown
process.on('SIGINT', () => {
  console.log('Encerrando servidor...');
  if (USE_SQLITE && db) {
    db.close();
  } else if (db) {
    db.end();
  }
  process.exit(0);
});
