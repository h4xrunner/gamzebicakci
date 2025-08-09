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
    const {
      title, content, excerpt, tags, author,
      category, status, publish_at, featured,
      comments_enabled, language, password, image
    } = req.body;
    
    const result = await pool.query(
      `INSERT INTO posts
        (title, content, excerpt, tags, author, category, status, publish_at, featured, comments_enabled, language, password, image, created_at)
       VALUES
        ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,NOW())
       RETURNING *`,
      [
        title, content, excerpt, tags, author || 'Gamze Bıçakçı',
        category, status || 'public', publish_at, featured || false,
        comments_enabled !== false, language || 'tr', password, image
      ]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Post eklenirken hata oluştu' });
  }
});

// Post güncelle
router.put('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const {
      title, content, excerpt, tags, author,
      category, status, publish_at, featured,
      comments_enabled, language, password, image
    } = req.body;
    const result = await pool.query(
      `UPDATE posts SET
        title = $1,
        content = $2,
        excerpt = $3,
        tags = $4,
        author = $5,
        category = $6,
        status = $7,
        publish_at = $8,
        featured = $9,
        comments_enabled = $10,
        language = $11,
        password = $12,
        image = $13,
        updated_at = NOW()
      WHERE id = $14 RETURNING *`,
      [
        title, content, excerpt, tags, author,
        category, status, publish_at, featured,
        comments_enabled, language, password, image, id
      ]
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
