// server.js
import express from 'express';
import fetch from 'node-fetch';
import path from 'path';
import { fileURLToPath } from 'url';
import { config } from 'dotenv';

// Load environment variables
config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
app.use(express.json());

// Serve static files
app.use(express.static(__dirname));

const SEARCH_ENDPOINT = 'https://mta-ny-search2.search.windows.net/indexes/multimodal-rag-1749487327154/docs/search?api-version=2024-11-01-preview';
const SEARCH_KEY = process.env.SEARCH_QUERY_KEY; // set in env

app.post('/api/search', async (req, res) => {
  try {
    const r = await fetch(SEARCH_ENDPOINT, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'api-key': SEARCH_KEY },
      body: JSON.stringify(req.body)
    });
    const json = await r.json();
    res.status(r.status).json(json);
  } catch (e) {
    res.status(500).json({ error: String(e) });
  }
});

// Serve the main HTML file at root
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'AzSearchGPT.html'));
});

app.listen(3001, () => console.log('Server running on http://localhost:3001 - Open in browser to test Azure AI Search'));
