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
          linkedin: 'https://linkedin.com/in/gamzebicakci',
          youtube: '',
          facebook: '',
          tiktok: '',
          snapchat: '',
          pinterest: ''
        }),
        theme_color: '#667eea',
        dark_mode: false,
        
        // Ana sayfa içerik alanları
        about_title: 'GAMZE BIÇAKÇI KİMDİR?',
        about_content: '2004 yılının sıcak bir yaz gününde 14 Ağustos\'ta dünyaya gelmiştir. Kendisinden 2 yaş büyük bir abisi vardır. 4 kişilik çekirdek bir aileyle büyümüştür.\n\nİlkokuldan beri yazmayla ilgilenmiştir. Kısa hikayeler, deneme yazıları, milli bayramlarla ilgili yazılar yazıp yarışmalara katılmıştır. Yazdıklarıyla insanları etkilemeyi sever.\n\nÖdüller aldıkça ve insanları etkilediğini hissettikçe bu yönünün kuvvetli olduğuna inanmış ve geleceğinin bir parçasının bu olmasını istemiştir. Yaratıcı yönüne inandığı için üniversitede reklamcılık okumaya karar vermiştir.',
        hobbies_title: 'HOBİLER',
        hobbies_content: 'Son birkaç yıldır olmasa da bir dönem kitap kurduydu :(\nMüzik dinlemeyi ve dans etmeyi sever.\nBir şeyler pişirmeyi (özellikle tatlı) sever.\nBasketbol oynamayı sever.\nBir dönem pilates ve yogaya ilgiliydi.\nPsikolojiyle ilgili kitaplar okumayı ve filmler izlemeyi sever.\nYeni yerler keşfetmeye bayılır. (Özellikle az insanın olduğu)\nYürüyüş yapmayı sever.\nTam olarak bilmese de yüzmeyi sever.\nMüzik aletleri çalmayı deniyor, umarım bir gün başarır.\nOrganizasyonlar yapmaya bayılır. (doğum günleri, özel günler vs.)\nSesini kullanmayı sever. (şiir okumak, dinleti vb. etkinlikler)\nDans ve müzik tutkusu ile hayatı renklendirir.\nKahve tutkusu ile her güne enerji dolu başlar.',
        courses_title: 'ALDIĞIM DERSLER:',
        courses_content: 'fotoğrafçılık | internet programcılığı | iletişim tarihi\nreklama giriş 2 | siyaset bilimine giriş | iktisat\npsikoloji | kariyer planlama | ingilizce',
        dream_title: 'enbüyükhayalim',
        dream_content: '🎬 YouTube\'da izle',
        dream_video_url: 'https://youtu.be/LIZ1KxOVBSI?si=e1QrT9Y5QR8LPJvL',
        contact_title: '💌 İletişime Geç',
        contact_description: 'Her türlü soru, fikir ya da işbirliği için benimle iletişime geçebilirsin.',
        
        created_at: new Date(),
        updated_at: new Date()
      };
      
      const insertResult = await pool.query(`
        INSERT INTO site_settings 
        (site_title, site_description, default_author, author_bio, hero_title, hero_subtitle, hero_description, contact_email, social_links, theme_color, dark_mode, about_title, about_content, hobbies_title, hobbies_content, courses_title, courses_content, dream_title, dream_content, dream_video_url, contact_title, contact_description, created_at, updated_at)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, $24)
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
        defaultSettings.dark_mode,
        defaultSettings.about_title,
        defaultSettings.about_content,
        defaultSettings.hobbies_title,
        defaultSettings.hobbies_content,
        defaultSettings.courses_title,
        defaultSettings.courses_content,
        defaultSettings.dream_title,
        defaultSettings.dream_content,
        defaultSettings.dream_video_url,
        defaultSettings.contact_title,
        defaultSettings.contact_description,
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
    // Önce mevcut ayarları al
    const currentSettings = await pool.query('SELECT * FROM site_settings ORDER BY id ASC LIMIT 1');
    const current = currentSettings.rows[0];

    // Gönderilen verilerle mevcut verileri birleştir
    const updateData = {
      site_title: req.body.site_title !== undefined ? req.body.site_title : current.site_title,
      site_description: req.body.site_description !== undefined ? req.body.site_description : current.site_description,
      default_author: req.body.default_author !== undefined ? req.body.default_author : current.default_author,
      author_bio: req.body.author_bio !== undefined ? req.body.author_bio : current.author_bio,
      hero_title: req.body.hero_title !== undefined ? req.body.hero_title : current.hero_title,
      hero_subtitle: req.body.hero_subtitle !== undefined ? req.body.hero_subtitle : current.hero_subtitle,
      hero_description: req.body.hero_description !== undefined ? req.body.hero_description : current.hero_description,
      contact_email: req.body.contact_email !== undefined ? req.body.contact_email : current.contact_email,
      social_links: req.body.social_links !== undefined ? req.body.social_links : current.social_links,
      theme_color: req.body.theme_color !== undefined ? req.body.theme_color : current.theme_color,
      dark_mode: req.body.dark_mode !== undefined ? req.body.dark_mode : current.dark_mode,
      about_title: req.body.about_title !== undefined ? req.body.about_title : current.about_title,
      about_content: req.body.about_content !== undefined ? req.body.about_content : current.about_content,
      hobbies_title: req.body.hobbies_title !== undefined ? req.body.hobbies_title : current.hobbies_title,
      hobbies_content: req.body.hobbies_content !== undefined ? req.body.hobbies_content : current.hobbies_content,
      courses_title: req.body.courses_title !== undefined ? req.body.courses_title : current.courses_title,
      courses_content: req.body.courses_content !== undefined ? req.body.courses_content : current.courses_content,
      dream_title: req.body.dream_title !== undefined ? req.body.dream_title : current.dream_title,
      dream_content: req.body.dream_content !== undefined ? req.body.dream_content : current.dream_content,
      dream_video_url: req.body.dream_video_url !== undefined ? req.body.dream_video_url : current.dream_video_url,
      contact_title: req.body.contact_title !== undefined ? req.body.contact_title : current.contact_title,
      contact_description: req.body.contact_description !== undefined ? req.body.contact_description : current.contact_description
    };

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
        dark_mode = $11,
        about_title = $12,
        about_content = $13,
        hobbies_title = $14,
        hobbies_content = $15,
        courses_title = $16,
        courses_content = $17,
        dream_title = $18,
        dream_content = $19,
        dream_video_url = $20,
        contact_title = $21,
        contact_description = $22,
        updated_at = NOW()
      WHERE id = (SELECT id FROM site_settings ORDER BY id ASC LIMIT 1)
      RETURNING *
    `, [
      updateData.site_title,
      updateData.site_description,
      updateData.default_author,
      updateData.author_bio,
      updateData.hero_title,
      updateData.hero_subtitle,
      updateData.hero_description,
      updateData.contact_email,
      updateData.social_links,
      updateData.theme_color,
      updateData.dark_mode,
      updateData.about_title,
      updateData.about_content,
      updateData.hobbies_title,
      updateData.hobbies_content,
      updateData.courses_title,
      updateData.courses_content,
      updateData.dream_title,
      updateData.dream_content,
      updateData.dream_video_url,
      updateData.contact_title,
      updateData.contact_description
    ]);

    if (result.rows.length > 0) {
      res.json(result.rows[0]);
    } else {
      res.status(404).json({ error: 'Ayarlar bulunamadı' });
    }
  } catch (error) {
    console.error('Ayarlar güncellenemedi:', error);
    res.status(500).json({ error: 'Ayarlar güncellenemedi' });
  }
});

module.exports = router;
