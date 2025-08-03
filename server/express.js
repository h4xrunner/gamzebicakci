console.log('Express test başlıyor');

try {
  const express = require('express');
  console.log('Express yüklendi');
  
  const app = express();
  console.log('App oluşturuldu');
  
  app.get('/', (req, res) => {
    console.log('GET / isteği alındı');
    res.send('Express çalışıyor!');
  });
  
  console.log('Route tanımlandı');
  
  app.listen(3000, () => {
    console.log('Express server 3000 portunda çalışıyor');
  });
  
} catch (error) {
  console.error('Hata:', error);
}
