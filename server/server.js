const express = require('express');
const cors = require('cors');
const app = express();
const postsRouter = require('./routes/posts');

app.use(cors());
app.use(express.json());

// API endpoint
app.use('/api/posts', postsRouter);

// Sunucuyu başlat
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Sunucu http://localhost:${PORT} adresinde çalışıyor`);
});
