const { exec } = require('child_process');
const path = require('path');
const http = require('http');

// Function to start Dart server
function startDartServer() {
  return new Promise((resolve, reject) => {
    const server = exec('dart run bin/main.dart', {
      cwd: path.resolve(__dirname)
    });

    server.stdout.on('data', (data) => {
      console.log(`stdout: ${data}`);
    });

    server.stderr.on('data', (data) => {
      console.error(`stderr: ${data}`);
    });

    // Wait for server to start
    setTimeout(() => resolve(server), 1000);
  });
}

// Export for Vercel
module.exports = async (req, res) => {
  try {
    const server = await startDartServer();
    
    // Forward request to Dart server
    const options = {
      hostname: 'localhost',
      port: 8080,
      path: req.url,
      method: req.method,
      headers: req.headers
    };

    const proxyReq = http.request(options, (proxyRes) => {
      res.writeHead(proxyRes.statusCode, proxyRes.headers);
      proxyRes.pipe(res, { end: true });
    });

    req.pipe(proxyReq, { end: true });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).send('Internal Server Error');
  }
}; 