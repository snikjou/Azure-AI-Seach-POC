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

const SEARCH_ENDPOINT = process.env.SEARCH_ENDPOINT;
const SEARCH_KEY = process.env.SEARCH_QUERY_KEY; // set in env
const SEMANTIC_CONFIGURATION = process.env.SEMANTIC_CONFIGURATION;
const STORAGE_ACCOUNT_URL = process.env.Storage_Account_URL;

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

// Serve configuration values to frontend
app.get('/api/config', (req, res) => {
  res.json({
    semanticConfiguration: SEMANTIC_CONFIGURATION,
    storageAccountUrl: STORAGE_ACCOUNT_URL
  });
});

// Serve the main HTML file at root
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'AzSearchGPT.html'));
});

const PORT = process.env.PORT || 3001;
app.listen(PORT, () => console.log(`Server running on port ${PORT} - Open in browser to test Azure AI Search`));
