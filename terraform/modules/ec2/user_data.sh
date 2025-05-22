#!/bin/bash
apt-get update -y
apt-get install -y nodejs npm mysql-client git

# Clonar repositório (simulado)
mkdir -p /home/ubuntu/app
cd /home/ubuntu/app

cat <<EOF > index.js
const express = require('express');
const mysql = require('mysql2');
const app = express();
const port = 3000;

app.use(express.json());

const db = mysql.createConnection({
  host: "${db_host}",
  user: "${db_user}",
  password: "${db_pass}",
  database: "${db_name}"
});

db.connect();

app.get('/api/items', (req, res) => {
  db.query('SELECT * FROM items', (err, results) => {
    if (err) return res.status(500).send(err);
    res.json(results);
  });
});

app.listen(port, () => console.log(CRUD API rodando na porta ${port}));
EOF

npm init -y
npm install express mysql2
nohup node index.js &