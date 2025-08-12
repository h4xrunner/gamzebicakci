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

// Misafir yazıları tablosunu oluştur
pool.query(`
    CREATE TABLE IF NOT EXISTS guest_posts (
        id SERIAL PRIMARY KEY,
        guest_name VARCHAR(255) NOT NULL,
        guest_email VARCHAR(255),
        guest_title VARCHAR(500) NOT NULL,
        guest_excerpt TEXT,
        guest_content TEXT NOT NULL,
        guest_category VARCHAR(100) DEFAULT 'Genel',
        guest_tags TEXT,
        status VARCHAR(50) DEFAULT 'pending',
        rejection_reason TEXT,
        submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        approved_at TIMESTAMP,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
`).catch(err => console.error('Guest posts tablosu oluşturulamadı:', err));

// Tüm misafir yazılarını getir (admin için)
router.get('/', async (req, res) => {
    try {
        const query = `
            SELECT * FROM guest_posts 
            ORDER BY submitted_at DESC
        `;
        
        const result = await pool.query(query);
        res.json(result.rows);
    } catch (err) {
        console.error('Misafir yazıları getirme hatası:', err);
        res.status(500).json({ error: 'Veritabanı hatası' });
    }
});

// Yeni misafir yazısı ekle
router.post('/', async (req, res) => {
    const { guest_name, guest_email, guest_title, guest_excerpt, guest_content, guest_category, guest_tags } = req.body;
    
    // Validation
    if (!guest_name || !guest_title || !guest_content) {
        return res.status(400).json({ error: 'Ad, başlık ve içerik zorunludur' });
    }
    
    try {
        const query = `
            INSERT INTO guest_posts (guest_name, guest_email, guest_title, guest_excerpt, guest_content, guest_category, guest_tags)
            VALUES ($1, $2, $3, $4, $5, $6, $7)
            RETURNING id
        `;
        
        const params = [guest_name, guest_email || '', guest_title, guest_excerpt || '', guest_content, guest_category || 'Genel', guest_tags || ''];
        
        const result = await pool.query(query, params);
        
        res.status(200).json({ 
            message: 'Misafir yazısı başarıyla eklendi',
            id: result.rows[0].id 
        });
    } catch (err) {
        console.error('Misafir yazısı ekleme hatası:', err);
        res.status(500).json({ error: 'Veritabanı hatası' });
    }
});

// Misafir yazısını onayla
router.put('/:id/approve', async (req, res) => {
    const { id } = req.params;
    
    try {
        // Önce misafir yazısını al
        const guestPostResult = await pool.query('SELECT * FROM guest_posts WHERE id = $1', [id]);
        
        if (guestPostResult.rows.length === 0) {
            return res.status(404).json({ error: 'Misafir yazısı bulunamadı' });
        }
        
        const guestPost = guestPostResult.rows[0];
        
        // Ana posts tablosuna ekle
        const insertQuery = `
            INSERT INTO posts (title, content, excerpt, author, category, tags, status, created_at, featured, comments_enabled, language)
            VALUES ($1, $2, $3, $4, $5, $6, 'public', CURRENT_TIMESTAMP, false, true, 'tr')
            RETURNING id
        `;
        
        const insertParams = [
            guestPost.guest_title,
            guestPost.guest_content,
            guestPost.guest_excerpt || '',
            guestPost.guest_name,
            guestPost.guest_category || 'Genel',
            guestPost.guest_tags || ''
        ];
        
        const insertResult = await pool.query(insertQuery, insertParams);
        
        // Misafir yazısını onaylandı olarak işaretle
        const updateQuery = `
            UPDATE guest_posts 
            SET status = 'approved', approved_at = CURRENT_TIMESTAMP 
            WHERE id = $1
        `;
        
        await pool.query(updateQuery, [id]);
        
        res.json({ 
            message: 'Misafir yazısı onaylandı ve blog\'a eklendi',
            post_id: insertResult.rows[0].id
        });
        
    } catch (err) {
        console.error('Misafir yazısı onaylama hatası:', err);
        res.status(500).json({ error: 'Veritabanı hatası' });
    }
});

// Misafir yazısını reddet
router.put('/:id/reject', async (req, res) => {
    const { id } = req.params;
    const { reason } = req.body;
    
    try {
        const query = `
            UPDATE guest_posts 
            SET status = 'rejected', rejection_reason = $1 
            WHERE id = $2
        `;
        
        const result = await pool.query(query, [reason || 'Belirtilmedi', id]);
        
        if (result.rowCount === 0) {
            return res.status(404).json({ error: 'Misafir yazısı bulunamadı' });
        }
        
        res.json({ message: 'Misafir yazısı reddedildi' });
    } catch (err) {
        console.error('Misafir yazısı reddetme hatası:', err);
        res.status(500).json({ error: 'Veritabanı hatası' });
    }
});

// Misafir yazısını sil
router.delete('/:id', async (req, res) => {
    const { id } = req.params;
    
    try {
        const query = 'DELETE FROM guest_posts WHERE id = $1';
        
        const result = await pool.query(query, [id]);
        
        if (result.rowCount === 0) {
            return res.status(404).json({ error: 'Misafir yazısı bulunamadı' });
        }
        
        res.json({ message: 'Misafir yazısı silindi' });
    } catch (err) {
        console.error('Misafir yazısı silme hatası:', err);
        res.status(500).json({ error: 'Veritabanı hatası' });
    }
});

module.exports = router;
