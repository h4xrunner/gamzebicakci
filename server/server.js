const express = require('express');
const cors = require('cors');
const path = require('path');
const app = express();

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Request logging
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.url}`);
  next();
});

// Statik dosyaları serve et (ana dizindeki dosyalar için)
app.use(express.static(path.join(__dirname, '..')));

// API endpoint - güvenli şekilde yükle
try {
  const postsRouter = require('./routes/posts');
  app.use('/api/posts', postsRouter);
  console.log('Posts router başarıyla yüklendi');
} catch (error) {
  console.error('Posts router yüklenemedi:', error.message);
}

// Admin routes
app.get('/admin', (req, res) => {
  res.sendFile(path.join(__dirname, 'views', 'admin.html'));
});

app.get('/admin/login', (req, res) => {
  res.sendFile(path.join(__dirname, 'views', 'login.html'));
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

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Sunucu http://localhost:${PORT} adresinde çalışıyor`);
  console.log(`Ana sayfa: http://localhost:${PORT}`);
  console.log(`Blog: http://localhost:${PORT}/blog`);
  console.log(`Admin: http://localhost:${PORT}/admin`);
});