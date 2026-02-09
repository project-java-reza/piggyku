/**
 * Contoh implementasi WhatsApp Webhook menggunakan Node.js/Express
 * File ini sebagai referensi untuk backend development
 *
 * Install dependencies:
 * npm install express body-parser dotenv cors
 */

const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(bodyParser.json());
app.use(cors());

// WhatsApp Configuration
const WHATSAPP_TOKEN = process.env.WHATSAPP_TOKEN;
const PHONE_NUMBER_ID = process.env.PHONE_NUMBER_ID;
const WEBHOOK_VERIFY_TOKEN = process.env.WEBHOOK_VERIFY_TOKEN || 'YOUR_VERIFY_TOKEN_HERE';

/**
 * Verifikasi Webhook (Setup WhatsApp Business API)
 * GET /webhook
 */
app.get('/webhook', (req, res) => {
  const mode = req.query['hub.mode'];
  const token = req.query['hub.verify_token'];
  const challenge = req.query['hub.challenge'];

  if (mode === 'subscribe' && token === WEBHOOK_VERIFY_TOKEN) {
    console.log('Webhook verified successfully!');
    res.status(200).send(challenge);
  } else {
    console.error('Webhook verification failed');
    res.sendStatus(403);
  }
});

/**
 * Terima pesan dari WhatsApp
 * POST /webhook
 */
app.post('/webhook', async (req, res) => {
  try {
    const webhookData = req.body;
    console.log('Received webhook:', JSON.stringify(webhookData, null, 2));

    // Forward ke Flutter API endpoint untuk diproses
    const response = await processWhatsAppMessage(webhookData);

    res.status(200).json({
      status: 'success',
      message: 'Webhook processed',
      data: response
    });

  } catch (error) {
    console.error('Error processing webhook:', error);
    res.status(500).json({
      status: 'error',
      message: 'Internal server error',
      error: error.message
    });
  }
});

/**
 * Forward pesan ke API Flutter untuk diproses
 */
async function processWhatsAppMessage(webhookData) {
  try {
    // Forward ke endpoint Flutter API
    const flutterApiUrl = process.env.FLUTTER_API_URL || 'http://localhost:8080/api/whatsapp/process';

    const response = await fetch(flutterApiUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${process.env.FLUTTER_API_TOKEN}`,
      },
      body: JSON.stringify(webhookData),
    });

    if (!response.ok) {
      throw new Error(`API request failed: ${response.status}`);
    }

    return await response.json();
  } catch (error) {
    console.error('Error forwarding to Flutter API:', error);
    throw error;
  }
}

/**
 * Manual testing endpoint
 * POST /test-whatsapp
 */
app.post('/test-whatsapp', async (req, res) => {
  try {
    const { phoneNumber, message } = req.body;

    if (!phoneNumber || !message) {
      return res.status(400).json({
        status: 'error',
        message: 'phoneNumber and message are required'
      });
    }

    // Kirim pesan test ke WhatsApp
    const result = await sendWhatsAppMessage(phoneNumber, message);

    res.json({
      status: 'success',
      message: 'Test message sent',
      data: result
    });

  } catch (error) {
    console.error('Error sending test message:', error);
    res.status(500).json({
      status: 'error',
      message: 'Failed to send test message',
      error: error.message
    });
  }
});

/**
 * Kirim pesan WhatsApp langsung
 */
async function sendWhatsAppMessage(phoneNumber, message) {
  try {
    const url = `https://graph.facebook.com/v18.0/${PHONE_NUMBER_ID}/messages`;
    const headers = {
      'Authorization': `Bearer ${WHATSAPP_TOKEN}`,
      'Content-Type': 'application/json',
    };

    const body = {
      messaging_product: 'whatsapp',
      to: phoneNumber,
      type: 'text',
      text: { body: message },
    };

    const response = await fetch(url, {
      method: 'POST',
      headers,
      body: JSON.stringify(body),
    });

    if (!response.ok) {
      throw new Error(`WhatsApp API error: ${response.status} - ${response.statusText}`);
    }

    return await response.json();
  } catch (error) {
    console.error('Error sending WhatsApp message:', error);
    throw error;
  }
}

/**
 * Health check endpoint
 */
app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime()
  });
});

/**
 * Sample webhook payload untuk testing
 */
app.get('/sample-webhook', (req, res) => {
  const samplePayload = {
    "object": "whatsapp_business_account",
    "entry": [{
      "id": "WHATSAPP_BUSINESS_ACCOUNT_ID",
      "changes": [{
        "field": "messages",
        "value": {
          "messaging_product": "whatsapp",
          "metadata": {
            "phone_number_id": PHONE_NUMBER_ID,
            "display_phone_number": "+62 812-3456-7890"
          },
          "contacts": [{
            "profile": {
              "name": "John Doe"
            },
            "wa_id": "6281234567890"
          }],
          "messages": [{
            "from": "6281234567890",
            "id": "wamid.HBgLNjI4MTIzNDU2Nzg5MFUC",
            "timestamp": "1691234567",
            "text": {
              "body": "beli ketoprak 5000"
            },
            "type": "text"
          }]
        }
      }]
    }]
  };

  res.json(samplePayload);
});

// Start server
app.listen(PORT, () => {
  console.log(`WhatsApp Webhook server running on port ${PORT}`);
  console.log(`Health check: http://localhost:${PORT}/health`);
  console.log(`Sample webhook: http://localhost:${PORT}/sample-webhook`);
});

module.exports = app;