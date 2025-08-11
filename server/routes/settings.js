const express = require('express');
const router = express.Router();
const { Pool } = require('pg');

// PostgreSQL bağlantısı
const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASS,
  port: process.env.DB_PORT,
});

// Ayarları getir
router.get('/', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM site_settings ORDER BY id ASC LIMIT 1');
    
    if (result.rows.length === 0) {
      // Varsayılan ayarları oluştur
      const defaultSettings = {
        site_title: 'Gamze Bıçakçı | Yaratıcı Portfolyo',
        site_description: 'Yazmaya, üretmeye ve ilham olmaya gönül vermiş bir reklamcılık öğrencisi',
        default_author: 'Gamze Bıçakçı',
        author_bio: 'Reklamcılık öğrencisi, yaratıcı içerik üreticisi.',
        hero_title: 'Gamze Bıçakçı',
        hero_subtitle: 'Yaratıcı Portfolyo',
        hero_description: 'Yazmaya, üretmeye ve ilham olmaya gönül vermiş bir reklamcılık öğrencisi',
        contact_email: 'gamze@example.com',
        social_links: JSON.stringify({
          instagram: 'https://instagram.com/gamzebicakci',
          twitter: 'https://twitter.com/gamzebicakci',
          linkedin: 'https://linkedin.com/in/gamzebicakci'
        }),
        theme_color: '#667eea',
        created_at: new Date(),
        updated_at: new Date()
      };
      
      const insertResult = await pool.query(`
        INSERT INTO site_settings 
        (site_title, site_description, default_author, author_bio, hero_title, hero_subtitle, hero_description, contact_email, social_links, theme_color, created_at, updated_at)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
        RETURNING *
      `, [
        defaultSettings.site_title,
        defaultSettings.site_description,
        defaultSettings.default_author,
        defaultSettings.author_bio,
        defaultSettings.hero_title,
        defaultSettings.hero_subtitle,
        defaultSettings.hero_description,
        defaultSettings.contact_email,
        defaultSettings.social_links,
        defaultSettings.theme_color,
        defaultSettings.created_at,
        defaultSettings.updated_at
      ]);
      
      res.json(insertResult.rows[0]);
    } else {
      res.json(result.rows[0]);
    }
  } catch (error) {
    console.error('Ayarlar getirilemedi:', error);
    res.status(500).json({ error: 'Ayarlar getirilemedi' });
  }
});

// Ayarları güncelle
router.put('/', async (req, res) => {
  try {
    const {
      site_title,
      site_description,
      default_author,
      author_bio,
      hero_title,
      hero_subtitle,
      hero_description,
      contact_email,
      social_links,
      theme_color
    } = req.body;

    const result = await pool.query(`
      UPDATE site_settings 
      SET 
        site_title = $1,
        site_description = $2,
        default_author = $3,
        author_bio = $4,
        hero_title = $5,
        hero_subtitle = $6,
        hero_description = $7,
        contact_email = $8,
        social_links = $9,
        theme_color = $10,
        updated_at = $11
      WHERE id = (SELECT id FROM site_settings ORDER BY id ASC LIMIT 1)
      RETURNING *
    `, [
      site_title,
      site_description,
      default_author,
      author_bio,
      hero_title,
      hero_subtitle,
      hero_description,
      contact_email,
      social_links,
      theme_color,
      new Date()
    ]);

    if (result.rows.length > 0) {
      res.json({ 
        success: true, 
        message: 'Ayarlar başarıyla güncellendi',
        settings: result.rows[0]
      });
    } else {
      res.status(404).json({ error: 'Ayarlar bulunamadı' });
    }
  } catch (error) {
    console.error('Ayarlar güncellenemedi:', error);
    res.status(500).json({ error: 'Ayarlar güncellenemedi' });
  }
});

module.exports = router;
