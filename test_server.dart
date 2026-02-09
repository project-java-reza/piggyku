import 'dart:io';
import 'dart:convert';

/// Simple test server untuk simulasi WhatsApp webhook
/// Run dengan: dart test_server.dart

void main() async {
  final server = await HttpServer.bind('localhost', 8080);
  print('🚀 Test Server running on http://localhost:8080');
  print('\n📱 Cara testing:');
  print('1. Jalankan server ini');
  print('2. Buka browser ke http://localhost:8080');
  print('3. Atau gunakan curl untuk test webhook');
  print('\n🔗 Test endpoints:');
  print('- GET  / (Web interface)');
  print('- POST /webhook (WhatsApp webhook)');
  print('- POST /test/send (Test kirim pesan)');
  print('- GET  /sample-payload (Sample webhook data)');

  await for (HttpRequest request in server) {
    handleRequest(request);
  }
}

void handleRequest(HttpRequest request) async {
  final response = request.response;

  try {
    switch (request.method) {
      case 'GET':
        await handleGetRequest(request, response);
        break;
      case 'POST':
        await handlePostRequest(request, response);
        break;
      default:
        response.statusCode = HttpStatus.methodNotAllowed;
        response.write('Method not allowed');
        break;
    }
  } catch (e) {
    response.statusCode = HttpStatus.internalServerError;
    response.write('Internal server error: $e');
  }

  await response.close();
}

Future<void> handleGetRequest(HttpRequest request, HttpResponse response) async {
  response.headers.contentType = ContentType.html;

  if (request.uri.path == '/sample-payload') {
    response.headers.contentType = ContentType.json;
    response.write(getSampleWebhookPayload());
    return;
  }

  // HTML interface untuk testing
  response.write('''
<!DOCTYPE html>
<html>
<head>
    <title>FinAI WhatsApp Bot Test</title>
    <meta charset="UTF-8">
    <style>
        body { font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px; }
        .test-section { margin: 20px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
        input, textarea, button { padding: 10px; margin: 5px; }
        button { background: #007bff; color: white; border: none; border-radius: 3px; cursor: pointer; }
        button:hover { background: #0056b3; }
        .result { background: #f8f9fa; padding: 10px; margin: 10px 0; border-radius: 3px; font-family: monospace; }
        .success { background: #d4edda; color: #155724; }
        .error { background: #f8d7da; color: #721c24; }
    </style>
</head>
<body>
    <h1>🤖 FinAI WhatsApp Bot Test Interface</h1>

    <div class="test-section">
        <h2>📝 Test Message Parsing</h2>
        <input type="text" id="phoneNumber" placeholder="Phone Number (6281234567890)" value="6281234567890" style="width: 300px;">
        <input type="text" id="message" placeholder="Message (contoh: beli ketoprak 5000)" value="beli ketoprak 5000" style="width: 300px;">
        <button onclick="testParsing()">Test Parsing</button>
        <div id="parseResult" class="result"></div>
    </div>

    <div class="test-section">
        <h2>📨 Test Webhook</h2>
        <button onclick="testWebhook()">Send Sample Webhook</button>
        <button onclick="testCustomWebhook()">Send Custom Message</button>
        <div id="webhookResult" class="result"></div>
    </div>

    <div class="test-section">
        <h2>📋 Sample Messages</h2>
        <button onclick="setExample('beli ketoprak 5000')">beli ketoprak 5000</button>
        <button onclick="setExample('makan nasi 15000')">makan nasi 15000</button>
        <button onclick="setExample('gojek 12000')">gojek 12000</button>
        <button onclick="setExample('belanja 50000')">belanja 50000</button>
        <button onclick="setExample('jual kue 25000')">jual kue 25000</button>
        <button onclick="setExample('pemasukan 5000000 gaji')">pemasukan 5000000 gaji</button>
        <button onclick="setExample('beli laptop 5juta')">beli laptop 5juta</button>
        <button onclick="setExample('invalid message')">invalid message</button>
    </div>

    <div class="test-section">
        <h2>📊 Test Results</h2>
        <div id="allResults" class="result"></div>
    </div>

    <script>
        function setExample(message) {
            document.getElementById('message').value = message;
        }

        async function testParsing() {
            const phoneNumber = document.getElementById('phoneNumber').value;
            const message = document.getElementById('message').value;

            try {
                const response = await fetch('/test/parse', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ phoneNumber, message })
                });

                const result = await response.json();
                const resultDiv = document.getElementById('parseResult');

                if (result.success) {
                    resultDiv.className = 'result success';
                    resultDiv.innerHTML =
                        '<h4>✅ Parsing Success</h4>' +
                        '<strong>Type:</strong> ' + result.data.transactionType + '<br>' +
                        '<strong>Amount:</strong> Rp ' + result.data.amount.toLocaleString('id-ID') + '<br>' +
                        '<strong>Description:</strong> ' + result.data.description + '<br>' +
                        '<strong>Category:</strong> ' + result.data.category + '<br>' +
                        '<strong>Valid:</strong> ' + result.data.isValid + '<br><br>' +
                        '<strong>Confirmation Message:</strong><br>' + result.data.confirmationMessage.replace(/\\n/g, '<br>');
                } else {
                    resultDiv.className = 'result error';
                    resultDiv.innerHTML = '<h4>❌ Parsing Failed</h4><pre>' + JSON.stringify(result, null, 2) + '</pre>';
                }

                updateAllResults(result);
            } catch (error) {
                document.getElementById('parseResult').className = 'result error';
                document.getElementById('parseResult').innerHTML = '<h4>❌ Error</h4><pre>' + error.message + '</pre>';
            }
        }

        async function testWebhook() {
            try {
                const response = await fetch('/webhook', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: getSampleWebhookPayload()
                });

                const result = await response.json();
                const resultDiv = document.getElementById('webhookResult');
                resultDiv.className = result.status === 'success' ? 'result success' : 'result error';
                resultDiv.innerHTML = '<h4>' + (result.status === 'success' ? '✅' : '❌') + ' Webhook Processed</h4><pre>' + JSON.stringify(result, null, 2) + '</pre>';

                updateAllResults(result);
            } catch (error) {
                document.getElementById('webhookResult').className = 'result error';
                document.getElementById('webhookResult').innerHTML = '<h4>❌ Error</h4><pre>' + error.message + '</pre>';
            }
        }

        async function testCustomWebhook() {
            const phoneNumber = document.getElementById('phoneNumber').value;
            const message = document.getElementById('message').value;

            const customPayload = {
                object: "whatsapp_business_account",
                entry: [{
                    id: "TEST_ACCOUNT_ID",
                    changes: [{
                        field: "messages",
                        value: {
                            messaging_product: "whatsapp",
                            metadata: { phone_number_id: "TEST_PHONE_ID" },
                            contacts: [{ profile: { name: "Test User" }, wa_id: phoneNumber }],
                            messages: [{
                                from: phoneNumber,
                                id: "test_msg_" + Date.now(),
                                timestamp: Math.floor(Date.now() / 1000).toString(),
                                text: { body: message },
                                type: "text"
                            }]
                        }
                    }]
                }]
            };

            try {
                const response = await fetch('/webhook', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(customPayload)
                });

                const result = await response.json();
                const resultDiv = document.getElementById('webhookResult');
                resultDiv.className = result.status === 'success' ? 'result success' : 'result error';
                resultDiv.innerHTML = '<h4>' + (result.status === 'success' ? '✅' : '❌') + ' Custom Webhook Processed</h4><pre>' + JSON.stringify(result, null, 2) + '</pre>';

                updateAllResults(result);
            } catch (error) {
                document.getElementById('webhookResult').className = 'result error';
                document.getElementById('webhookResult').innerHTML = '<h4>❌ Error</h4><pre>' + error.message + '</pre>';
            }
        }

        function updateAllResults(result) {
            const allResults = document.getElementById('allResults');
            const timestamp = new Date().toLocaleTimeString();
            allResults.innerHTML = '<strong>[' + timestamp + ']</strong> Last Result:<br><pre>' + JSON.stringify(result, null, 2) + '</pre>';
        }

        function getSampleWebhookPayload() {
            return '${getSampleWebhookPayload()}';
        }
    </script>
</body>
</html>
  ''');
}

Future<void> handlePostRequest(HttpRequest request, HttpResponse response) async {
  response.headers.contentType = ContentType.json;

  if (request.uri.path == '/webhook') {
    await handleWebhook(request, response);
  } else if (request.uri.path == '/test/parse') {
    await handleParseTest(request, response);
  } else {
    response.statusCode = HttpStatus.notFound;
    response.write('{"error": "Endpoint not found"}');
  }
}

Future<void> handleWebhook(HttpRequest request, HttpResponse response) async {
  try {
    final body = await utf8.decoder.bind(request).join();
    final webhookData = jsonDecode(body) as Map<String, dynamic>;

    // Simulasi parsing WhatsApp message
    final result = simulateWhatsAppProcessing(webhookData);

    response.write(jsonEncode(result));
  } catch (e) {
    response.statusCode = HttpStatus.badRequest;
    response.write(jsonEncode({
      'status': 'error',
      'message': 'Failed to process webhook',
      'error': e.toString()
    }));
  }
}

Future<void> handleParseTest(HttpRequest request, HttpResponse response) async {
  try {
    final body = await utf8.decoder.bind(request).join();
    final data = jsonDecode(body) as Map<String, dynamic>;

    final phoneNumber = data['phoneNumber'] as String;
    final message = data['message'] as String;

    // Simulasi parsing menggunakan model
    final transaction = simulateTransactionParsing(phoneNumber, message);

    response.write(jsonEncode({
      'success': true,
      'data': {
        'phoneNumber': phoneNumber,
        'originalMessage': message,
        'transactionType': transaction['transactionType'],
        'description': transaction['description'],
        'amount': transaction['amount'],
        'category': transaction['category'],
        'isValid': transaction['isValid'],
        'confirmationMessage': transaction['confirmationMessage'],
      }
    }));
  } catch (e) {
    response.statusCode = HttpStatus.badRequest;
    response.write(jsonEncode({
      'success': false,
      'error': e.toString()
    }));
  }
}

Map<String, dynamic> simulateWhatsAppProcessing(Map<String, dynamic> webhookData) {
  try {
    final entry = webhookData['entry']?.first;
    final changes = entry?['changes']?.first;
    final messages = changes?['value']?['messages'];

    if (messages == null || messages.isEmpty) {
      return {'status': 'no_message', 'message': 'No message found'};
    }

    final message = messages.first;
    final String phoneNumber = message['from'] ?? '';
    final String textMessage = message['text']?['body'] ?? '';

    final transaction = simulateTransactionParsing(phoneNumber, textMessage);

    if (!transaction['isValid']) {
      return {
        'status': 'invalid_format',
        'message': 'Invalid message format',
        'original_message': textMessage,
      };
    }

    // Simulasi sukses menyimpan transaksi
    return {
      'status': 'success',
      'message': 'Transaction processed successfully',
      'transaction': transaction,
    };
  } catch (e) {
    return {
      'status': 'error',
      'message': 'Internal server error',
      'error': e.toString(),
    };
  }
}

Map<String, dynamic> simulateTransactionParsing(String phoneNumber, String message) {
  // Simulasi parsing logic (simplified version)
  final normalizedMessage = message.toLowerCase().trim();

  // Pattern untuk "beli [description] [amount]"
  final buyPattern = RegExp(r'^(beli|makan|pesan|jual|bayar)\s+(.+?)\s+(\d+(?:\.\d+)?)(?:ribu|rb|juta|jt)?$');
  final match = buyPattern.firstMatch(normalizedMessage);

  if (match != null) {
    String action = match.group(1)!;
    String description = match.group(2)!;
    String amountStr = match.group(3)!;

    double amount = double.parse(amountStr);

    // Cek suffix
    if (normalizedMessage.contains('ribu') || normalizedMessage.contains('rb')) {
      amount *= 1000;
    } else if (normalizedMessage.contains('juta') || normalizedMessage.contains('jt')) {
      amount *= 1000000;
    }

    String transactionType = (action == 'jual' || action == 'dapat') ? 'income' : 'expense';
    String? category = categorizeTransaction(description);

    return {
      'phoneNumber': phoneNumber,
      'message': message,
      'transactionType': transactionType,
      'description': description,
      'amount': amount,
      'category': category,
      'isValid': true,
      'confirmationMessage': generateConfirmationMessage(transactionType, description, amount, category),
    };
  }

  return {
    'phoneNumber': phoneNumber,
    'message': message,
    'transactionType': 'unknown',
    'description': message,
    'amount': 0.0,
    'category': null,
    'isValid': false,
    'confirmationMessage': '❌ Format tidak dikenali. Contoh: "beli ketoprak 5000"',
  };
}

String? categorizeTransaction(String description) {
  final desc = description.toLowerCase();

  if (desc.contains('makan') || desc.contains('nasi') || desc.contains('ketoprak') ||
      desc.contains('bakso') || desc.contains('sate') || desc.contains('ayam') ||
      desc.contains('mie') || desc.contains('kopi') || desc.contains('minum')) {
    return 'makanan';
  }

  if (desc.contains('ojek') || desc.contains('gojek') || desc.contains('grab') ||
      desc.contains('taxi') || desc.contains('bensin') || desc.contains('parkir')) {
    return 'transportasi';
  }

  if (desc.contains('belanja') || desc.contains('toko') || desc.contains('minuman') ||
      desc.contains('snack') || desc.contains('jajan')) {
    return 'belanja';
  }

  return 'lainnya';
}

String generateConfirmationMessage(String transactionType, String description, double amount, String? category) {
  if (transactionType == 'unknown') {
    return '❌ Format pesan tidak dikenali. Contoh: "beli ketoprak 5000"';
  }

  String typeText = transactionType == 'income' ? 'Pemasukan' : 'Pengeluaran';
  String categoryText = category != null ? ' ($category)' : '';

  String formattedAmount = formatAmount(amount);

  return '✅ *Transaksi Tercatat*\n\n'
         '📝 $typeText$categoryText\n'
         '💰 $formattedAmount\n'
         '📖 $description\n'
         '🕐 ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}\n\n'
         'Data akan tersimpan otomatis di aplikasi Anda.';
}

String formatAmount(double amount) {
  if (amount >= 1000000) {
    return 'Rp ${(amount / 1000000).toStringAsFixed(1)}jt';
  } else if (amount >= 1000) {
    return 'Rp ${(amount / 1000).toStringAsFixed(0)}rb';
  } else {
    return 'Rp ${amount.toStringAsFixed(0)}';
  }
}

String getSampleWebhookPayload() {
  return jsonEncode({
    "object": "whatsapp_business_account",
    "entry": [{
      "id": "WHATSAPP_BUSINESS_ACCOUNT_ID",
      "changes": [{
        "field": "messages",
        "value": {
          "messaging_product": "whatsapp",
          "metadata": {
            "phone_number_id": "YOUR_PHONE_NUMBER_ID",
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
  });
}