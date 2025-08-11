# 🎛️ Blog Sitesi Ayarlar Sistemi

Bu sistem, blog sitenizin temel özelliklerini admin panelinden kolayca yönetmenizi sağlar.

## ✨ Özellikler

### 🌐 Site Temel Ayarları
- **Site Başlığı**: Tarayıcı sekmesinde görünen başlık
- **Site Açıklaması**: SEO için meta description
- **Tema Rengi**: Ana renk paleti

### 👤 Yazar Bilgileri
- **Varsayılan Yazar**: Yeni yazılarda otomatik doldurulacak yazar adı
- **Yazar Biyografisi**: Yazar hakkında kısa bilgi

### 🏠 Ana Sayfa Ayarları
- **Ana Başlık**: Hero section'daki büyük başlık
- **Alt Başlık**: Hero section'daki alt başlık
- **Ana Sayfa Açıklaması**: Hero section'da görünen açıklama metni

### 📧 İletişim & Sosyal Medya
- **İletişim E-posta**: İletişim formu için e-posta adresi
- **Instagram Linki**: Instagram profil linki
- **Twitter Linki**: Twitter profil linki
- **LinkedIn Linki**: LinkedIn profil linki

## 🚀 Kurulum

### 1. Veritabanı Kurulumu
```sql
-- database_setup.sql dosyasını PostgreSQL veritabanınızda çalıştırın
psql -U your_username -d your_database -f server/database_setup.sql
```

### 2. Server Başlatma
```bash
cd server
npm install
node server.js
```

### 3. Admin Paneline Erişim
- `/admin` adresine gidin
- Kullanıcı adı: `admin`, Şifre: `admin123`
- "Ayarlar" sekmesine tıklayın

## 📝 Kullanım

### Ayarları Güncelleme
1. Admin panelinde "⚙️ Ayarlar" sekmesine gidin
2. İstediğiniz alanları düzenleyin
3. "💾 Ayarları Kaydet" butonuna tıklayın
4. Değişiklikler anında ana sayfaya yansıyacaktır

### Varsayılan Değerleri Geri Yükleme
- "🔄 Sıfırla" butonuna tıklayarak tüm ayarları varsayılan değerlere döndürebilirsiniz

## 🔧 Teknik Detaylar

### API Endpoints
- `GET /api/settings` - Mevcut ayarları getir
- `PUT /api/settings` - Ayarları güncelle

### Veritabanı Tablosu
```sql
CREATE TABLE site_settings (
    id SERIAL PRIMARY KEY,
    site_title VARCHAR(255),
    site_description TEXT,
    default_author VARCHAR(255),
    author_bio TEXT,
    hero_title VARCHAR(255),
    hero_subtitle VARCHAR(255),
    hero_description TEXT,
    contact_email VARCHAR(255),
    social_links JSONB,
    theme_color VARCHAR(7),
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);
```

### Otomatik Güncelleme
- Ayarlar güncellendiğinde ana sayfa otomatik olarak yenilenir
- Tema rengi değişiklikleri anında uygulanır
- Meta etiketleri dinamik olarak güncellenir

## 🎨 Özelleştirme

### Yeni Ayar Alanı Ekleme
1. `server/routes/settings.js` dosyasında yeni alan ekleyin
2. `server/database_setup.sql` dosyasında veritabanı şemasını güncelleyin
3. `server/views/admin.html` dosyasında form alanını ekleyin
4. `index.html` dosyasında JavaScript'i güncelleyin

### CSS Değişkenleri
```css
:root {
    --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}
```

## 🐛 Sorun Giderme

### Ayarlar Kaydedilmiyor
- Veritabanı bağlantısını kontrol edin
- Console'da hata mesajlarını kontrol edin
- Server loglarını inceleyin

### Ana Sayfa Güncellenmiyor
- Tarayıcı cache'ini temizleyin
- Sayfayı yeniden yükleyin
- JavaScript console'da hata olup olmadığını kontrol edin

## 📱 Responsive Tasarım
- Tüm ayar formları mobil cihazlarda uyumlu
- Admin paneli responsive tasarıma sahip
- Ana sayfa tüm ekran boyutlarında optimize edilmiş

## 🔒 Güvenlik
- Ayarlar sadece admin kullanıcıları tarafından düzenlenebilir
- Session tabanlı kimlik doğrulama
- SQL injection koruması
- XSS koruması

## 📞 Destek
Herhangi bir sorun yaşarsanız:
1. Console loglarını kontrol edin
2. Server loglarını inceleyin
3. Veritabanı bağlantısını test edin
4. Gerekirse veritabanını yeniden oluşturun
