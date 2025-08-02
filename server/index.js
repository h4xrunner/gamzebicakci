const express = require('express');
const { Pool } = require('pg'); // pg paketinden Pool'u dahil et
const app = express();
const port = 3000;

// JSON desteği için
app.use(express.json());

// PostgreSQL bağlantı havuzu oluştur
const pool = new Pool({
  user: 'gamze',
  host: 'localhost',
  database: 'gamze_db',
  password: '2344',
  port: 5432,
});

// Basit ana sayfa
app.get('/', (req, res) => {
  res.send('Merhaba Gamze! Express ve PostgreSQL sunucusu çalışıyor.');
});

// Test amaçlı veritabanı sorgusu
app.get('/dbtest', async (req, res) => {
  try {
    const result = await pool.query('SELECT NOW()');
    res.json({ time: result.rows[0].now });
  } catch (err) {
    console.error(err);
    res.status(500).send('Veritabanı bağlantı hatası');
  }
});

app.listen(port, () => {
  console.log(`Sunucu http://localhost:${port} adresinde çalışıyor.`);
});
