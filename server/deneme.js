console.log('Script başladı');

const http = require('http');
console.log('HTTP modülü yüklendi');

const server = http.createServer((req, res) => {
  console.log('Request alındı:', req.url);
  res.writeHead(200, {'Content-Type': 'text/html'});
  res.end('Minimal server çalışıyor!');
});

console.log('Server oluşturuldu');

server.listen(3000, () => {
  console.log('Server 3000 portunda dinliyor');
});

console.log('Listen komutu verildi');
