require('dotenv').config();

const express = require('express');
const cors = require('cors');
const path = require('path');
const app = express();

// Request logging
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.url}`);
  next();
});

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Statik dosyaları serve et (ana dizindeki dosyalar için)
app.use(express.static(path.join(__dirname, '..')));

// Session ayarları (YENİ)
app.use(session({
  secret: process.env.SESSION_SECRET || 'your-secret-key',
  resave: false,
  saveUninitialized: false,
  cookie: { 
    secure: process.env.NODE_ENV === 'production',
    maxAge: 24 * 60 * 60 * 1000 // 24 saat
  }
}));

// ======= YENİ ÖZELLIKLER (AUTH SİSTEMİ) =======
const session = require('express-session');
const passport = require('passport');
const LocalStrategy = require('passport-local').Strategy;
const bcrypt = require('bcrypt');
const { Pool } = require('pg');

// PostgreSQL bağlantısı
const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASS,
  port: process.env.DB_PORT,
});

// Session ayarları
app.use(session({
  secret: process.env.SESSION_SECRET || 'your-secret-key', // .env'den al
  resave: false,
  saveUninitialized: false,
  cookie: { 
    secure: process.env.NODE_ENV === 'production',
    maxAge: 24 * 60 * 60 * 1000 // 24 saat
  }
}));

// Passport ayarları
app.use(passport.initialize());
app.use(passport.session());

passport.use(new LocalStrategy(async (username, password, done) => {
  try {
    const result = await pool.query('SELECT * FROM users WHERE username = $1', [username]);
    const user = result.rows[0];

    if (!user) {
      return done(null, false, { message: 'Kullanıcı bulunamadı.' });
    }

    const validPassword = await bcrypt.compare(password, user.password_hash);
    if (!validPassword) {
      return done(null, false, { message: 'Hatalı şifre.' });
    }

    return done(null, user);
  } catch (err) {
    return done(err);
  }
}));

passport.serializeUser((user, done) => {
  done(null, user.id);
});

passport.deserializeUser(async (id, done) => {
  try {
    const result = await pool.query('SELECT * FROM users WHERE id = $1', [id]);
    done(null, result.rows[0]);
  } catch (err) {
    done(err);
  }
});

// Auth middleware (YENİ)
const isAuthenticated = (req, res, next) => {
  if (req.isAuthenticated()) {
    return next();
  }
  res.redirect('/admin/login');
};

// Admin routes (GELİŞTİRİLDİ - Artık korumalı)
app.get('/admin', isAuthenticated, (req, res) => {
  res.sendFile(path.join(__dirname, 'views', 'admin.html'));
});

// Login sayfası route (YENİ)
app.get('/admin/login', (req, res) => {
  if (req.isAuthenticated()) {
    return res.redirect('/admin');
  }
  res.sendFile(path.join(__dirname, 'views', 'login.html'));
});

// Login işlemi (YENİ)
app.post('/admin/login', passport.authenticate('local', {
  successRedirect: '/admin',
  failureRedirect: '/admin/login',
  failureFlash: false
}));

// Logout (YENİ)
app.get('/admin/logout', (req, res) => {
  req.logout(() => {
    res.redirect('/');
  });
});

// Blog sayfası
app.get('/blog', (req, res) => {
  res.sendFile(path.join(__dirname, 'views', 'blog.html'));
});

// Ana sayfa route'u
app.get('/', (req, res) => {
  console.log('Ana sayfa isteği işleniyor...');
  res.sendFile(path.join(__dirname, '..', 'index.html'));
});

// Test endpoint
app.get('/test', (req, res) => {
  res.json({ 
    status: 'Server çalışıyor!', 
    timestamp: new Date(),
    message: 'Test başarılı'
  });
});

// İlk admin kullanıcısını oluşturma (YENİ)
app.post('/setup-admin', async (req, res) => {
  try {
    const hashedPassword = await bcrypt.hash('admin123', 10);
    await pool.query(
      'INSERT INTO users (username, password_hash) VALUES ($1, $2) ON CONFLICT (username) DO NOTHING',
      ['admin', hashedPassword]
    );
    res.json({ message: 'Admin kullanıcısı oluşturuldu' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 404 handler
app.use((req, res) => {
  console.log(`404 - Bulunamadı: ${req.url}`);
  res.status(404).send('Sayfa bulunamadı');
});

// Error handler
app.use((err, req, res, next) => {
  console.error('Server hatası:', err);
  res.status(500).send('Sunucu hatası');
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Sunucu http://localhost:${PORT} adresinde çalışıyor`);
  console.log(`Ana sayfa: http://localhost:${PORT}`);
  console.log(`Blog: http://localhost:${PORT}/blog`);
  console.log(`Admin: http://localhost:${PORT}/admin`);
});