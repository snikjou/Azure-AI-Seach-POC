# Azure AI Search Demo

A Node.js proxy server for Azure AI Search with a web interface.

## Setup

1. Install dependencies:
   ```
   npm install
   ```

2. Copy the environment template and add your query key:
   ```
   copy .env.template .env
   ```
   
3. Edit `.env` and replace `your_query_key_here` with your actual Azure AI Search query key.

## Running

Start the server:
```
npm start
```

Then open http://localhost:3001 in your browser.

## Features

- Secure API key handling (server-side only)
- Azure AI Search query proxy
- Interactive web interface
- Support for semantic search, vector queries, and more
