-- Site ayarları tablosu
CREATE TABLE IF NOT EXISTS site_settings (
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
    dark_mode BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Varsayılan ayarları ekle (eğer tablo boşsa)
INSERT INTO site_settings (site_title, site_description, default_author, author_bio, hero_title, hero_subtitle, hero_description, contact_email, social_links, theme_color)
SELECT 
    'Gamze Bıçakçı | Yaratıcı Portfolyo',
    'Yazmaya, üretmeye ve ilham olmaya gönül vermiş bir reklamcılık öğrencisi',
    'Gamze Bıçakçı',
    'Reklamcılık öğrencisi, yaratıcı içerik üreticisi.',
    'Gamze Bıçakçı',
    'Yaratıcı Portfolyo',
    'Yazmaya, üretmeye ve ilham olmaya gönül vermiş bir reklamcılık öğrencisi',
    'gamze@example.com',
    '{"instagram": "https://instagram.com/gamzebicakci", "twitter": "https://twitter.com/gamzebicakci", "linkedin": "https://linkedin.com/in/gamzebicakci"}',
    '#667eea'
WHERE NOT EXISTS (SELECT 1 FROM site_settings);

-- Güncelleme zamanı için trigger fonksiyonu
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger'ı site_settings tablosuna ekle
DROP TRIGGER IF EXISTS update_site_settings_updated_at ON site_settings;
CREATE TRIGGER update_site_settings_updated_at
    BEFORE UPDATE ON site_settings
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();
