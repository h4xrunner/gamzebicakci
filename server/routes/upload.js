const express = require('express');
const router = express.Router();
const cloudinary = require('../cloudinary');
const multer = require('multer');
const { CloudinaryStorage } = require('multer-storage-cloudinary');

const storage = new CloudinaryStorage({
  cloudinary: cloudinary,
  params: {
    folder: 'blog-images', // Cloudinary'de klasör ismi
    allowed_formats: ['jpg', 'jpeg', 'png', 'webp'],
  },
});

const parser = multer({ storage: storage });

router.post('/image', parser.single('image'), (req, res) => {
  if (!req.file) {
    return res.status(400).json({ error: 'Dosya bulunamadı.' });
  }
  console.log('File object:', req.file); // Debug için
  res.json({ 
    url: req.file.path, 
    public_id: req.file.filename 
  });
});

module.exports = router;