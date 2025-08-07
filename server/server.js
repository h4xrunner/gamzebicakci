require('dotenv').config();

// ========= TÜM IMPORT'LAR BAŞTA =========
const express = require('express');
const cors = require('cors');
const path = require('path');
const session = require('express-session');
const passport = require('passport');
const LocalStrategy = require('passport-local').Strategy;
const bcrypt = require('bcrypt');
const { Pool } = require('pg');

const app = express();

// PostgreSQL bağlantısı
const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASS,
  port: process.env.DB_PORT,
});

// ========= MIDDLEWARE CONFIGURATION =========
// Request logging
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.url}`);
  next();
});

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Statik dosyaları serve et
app.use(express.static(path.join(__dirname, '..')));

// Session ayarları
app.use(session({
  secret: process.env.SESSION_SECRET || 'your-secret-key',
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

// ========= PASSPORT CONFIGURATION =========
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

// ========= AUTH MIDDLEWARE =========
const isAuthenticated = (req, res, next) => {
  if (req.isAuthenticated()) {
    return next();
  }
  res.redirect('/admin/login');
};

// ========= API ROUTES =========
// API endpoint - güvenli şekilde yükle
try {
  const postsRouter = require('./routes/posts');
  app.use('/api/posts', postsRouter);
  console.log('Posts router başarıyla yüklendi');
} catch (error) {
  console.error('Posts router yüklenemedi:', error.message);
}

// ========= AUTH ROUTES =========
// Login sayfası
app.get('/admin/login', (req, res) => {
  if (req.isAuthenticated()) {
    return res.redirect('/admin');
  }
  res.sendFile(path.join(__dirname, 'views', 'login.html'));
});

// Login işlemi
app.post('/admin/login', passport.authenticate('local', {
  successRedirect: '/admin',
  failureRedirect: '/admin/login',
  failureFlash: false
}));

// Logout
app.get('/admin/logout', (req, res) => {
  req.logout(() => {
    res.redirect('/');
  });
});

// ========= PROTECTED ROUTES =========
// Admin paneli (korumalı)
app.get('/admin', isAuthenticated, (req, res) => {
  res.sendFile(path.join(__dirname, 'views', 'admin.html'));
});

// İlk admin kullanıcısını oluşturma
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

// ========= PUBLIC ROUTES =========
// Ana sayfa
app.get('/', (req, res) => {
  console.log('Ana sayfa isteği işleniyor...');
  res.sendFile(path.join(__dirname, '..', 'index.html'));
});

// Blog sayfası
app.get('/blog', (req, res) => {
  res.sendFile(path.join(__dirname, 'views', 'blog.html'));
});

// Test endpoint
app.get('/test', (req, res) => {
  res.json({ 
    status: 'Server çalışıyor!', 
    timestamp: new Date(),
    message: 'Test başarılı'
  });
});

// ========= ERROR HANDLERS =========
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

// ========= SERVER START =========
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Sunucu http://localhost:${PORT} adresinde çalışıyor`);
  console.log(`Ana sayfa: http://localhost:${PORT}`);
  console.log(`Blog: http://localhost:${PORT}/blog`);
  console.log(`Admin: http://localhost:${PORT}/admin`);
});