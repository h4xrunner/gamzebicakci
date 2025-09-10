-- Posts tablosuna featured alanı ekle (eğer yoksa)
ALTER TABLE posts ADD COLUMN IF NOT EXISTS featured BOOLEAN DEFAULT false;

-- Mevcut postları güncelle (opsiyonel)
-- UPDATE posts SET featured = false WHERE featured IS NULL;
