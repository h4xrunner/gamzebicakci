#!/bin/bash

echo "🗄️  Blog sitesi veritabanı kurulumu başlatılıyor..."

# PostgreSQL bağlantı bilgilerini al
read -p "PostgreSQL kullanıcı adı: " DB_USER
read -p "Veritabanı adı: " DB_NAME
read -p "Host (varsayılan: localhost): " DB_HOST
DB_HOST=${DB_HOST:-localhost}
read -p "Port (varsayılan: 5432): " DB_PORT
DB_PORT=${DB_PORT:-5432}

echo "📝 .env dosyası oluşturuluyor..."

# .env dosyası oluştur
cat > .env << EOF
DB_USER=$DB_USER
DB_HOST=$DB_HOST
DB_NAME=$DB_NAME
DB_PORT=$DB_PORT
DB_PASS=your_password_here
SESSION_SECRET=your_session_secret_here
NODE_ENV=development
EOF

echo "✅ .env dosyası oluşturuldu"
echo "⚠️  Lütfen .env dosyasında DB_PASS değerini gerçek şifrenizle güncelleyin"

echo "🗃️  Veritabanı tabloları oluşturuluyor..."

# Veritabanı kurulum scriptini çalıştır
psql -U $DB_USER -h $DB_HOST -p $DB_PORT -d $DB_NAME -f database_setup.sql

if [ $? -eq 0 ]; then
    echo "✅ Veritabanı kurulumu tamamlandı!"
    echo "🚀 Server'ı başlatmak için: node server.js"
else
    echo "❌ Veritabanı kurulumunda hata oluştu"
    echo "📋 Manuel kurulum için database_setup.sql dosyasını çalıştırın"
fi
