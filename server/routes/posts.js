require('dotenv').config();

const express = require('express');
const router = express.Router();
const { Pool } = require('pg');

// PostgreSQL bağlantı ayarları
const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASS,
  port: process.env.DB_PORT,
});


// Bağlantıyı test et
pool.connect((err, client, release) => {
  if (err) {
    return console.error('Veritabanı bağlantı hatası:', err.stack);
  }
  console.log('PostgreSQL veritabanına başarıyla bağlandı');
  release();
});

// Tüm postları getir
router.get('/', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM posts ORDER BY created_at DESC');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Veritabanı hatası' });
  }
});

// Yeni post ekle
router.post('/', async (req, res) => {
  try {
    const { title, content, excerpt, tags, author } = req.body;
    
    const result = await pool.query(
      'INSERT INTO posts (title, content, excerpt, tags, author, created_at) VALUES ($1, $2, $3, $4, $5, NOW()) RETURNING *',
      [title, content, excerpt, tags, author || 'Gamze Bıçakçı']
    );
    
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Post eklenirken hata oluştu' });
  }
});

// Belirli bir post'u getir
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query('SELECT * FROM posts WHERE id = $1', [id]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Post bulunamadı' });
    }
    
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Veritabanı hatası' });
  }
});

// Post güncelle
router.put('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { title, content, excerpt, tags, author } = req.body;
    
    const result = await pool.query(
      'UPDATE posts SET title = $1, content = $2, excerpt = $3, tags = $4, author = $5, updated_at = NOW() WHERE id = $6 RETURNING *',
      [title, content, excerpt, tags, author, id]
    );
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Post bulunamadı' });
    }
    
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Post güncellenirken hata oluştu' });
  }
});

// Post sil
router.delete('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query('DELETE FROM posts WHERE id = $1 RETURNING *', [id]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Post bulunamadı' });
    }
    
    res.json({ message: 'Post başarıyla silindi', deletedPost: result.rows[0] });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Post silinirken hata oluştu' });
  }
});

module.exports = router;
