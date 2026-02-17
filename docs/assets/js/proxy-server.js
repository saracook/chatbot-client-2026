// proxy-server.js

// Use Node.js's built-in modules
//import http from 'node:http';
import http from 'http';

const TARGET_URL = 'https://ada-lovelace.stanford.edu/chatbot/api/v1/query/';
const LOCAL_ORIGIN = 'http://localhost:4000';
const PROXY_PORT = 5050; // A free port on your machine

const server = http.createServer((clientReq, clientRes) => {
  // --- Part 1: Handle CORS for the browser request ---
  // This tells the browser that your proxy server allows requests from your web app
  clientRes.setHeader('Access-Control-Allow-Origin', LOCAL_ORIGIN);
  clientRes.setHeader('Access-Control-Allow-Methods', 'POST, GET, OPTIONS');
  clientRes.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  // Handle the browser's preflight (OPTIONS) request
  if (clientReq.method === 'OPTIONS') {
    clientRes.writeHead(204); // 204 No Content
    clientRes.end();
    return;
  }
  
  // --- Part 2: Forward the actual POST request ---
  if (clientReq.method === 'POST') {
    let body = [];
    clientReq.on('data', (chunk) => {
      body.push(chunk);
    }).on('end', async () => {
      body = Buffer.concat(body);

      try {
        // Make the actual request to the target API
        const apiResponse = await fetch(TARGET_URL, {
          method: 'POST',
          headers: {
            // Forward necessary headers from the original request
            'Content-Type': clientReq.headers['content-type'] || 'application/json',
            // Forward authorization if it exists
            ...(clientReq.headers.authorization && { 'Authorization': clientReq.headers.authorization }),
          },
          body: body
        });

        // --- Part 3: Relay the API's response back to the browser ---
        const responseData = await apiResponse.text();
        
        // Send the API's headers and status code back to the client
        clientRes.writeHead(apiResponse.status, {
          'Content-Type': apiResponse.headers.get('content-type')
        });

        clientRes.end(responseData);

      } catch (error) {
        console.error('Proxy Error:', error);
        clientRes.writeHead(502, { 'Content-Type': 'application/json' });
        clientRes.end(JSON.stringify({ error: 'Proxy failed to connect to the target API.' }));
      }
    });
  } else {
    // Respond to any other methods (like GET) with a simple 404
    clientRes.writeHead(404, { 'Content-Type': 'text/plain' });
    clientRes.end('This proxy only supports POST and OPTIONS requests.');
  }
});

server.listen(PROXY_PORT, () => {
  console.log(`✅ CORS Proxy server running.`);
  console.log(`   Your app on ${LOCAL_ORIGIN} should make requests to:`);
  console.log(`   => http://localhost:${PROXY_PORT}`);
});
