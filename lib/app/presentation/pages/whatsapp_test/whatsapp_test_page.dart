import 'package:flutter/material.dart';
import '../../../data/models/whatsapp_transaction_model.dart';

class WhatsAppTestPage extends StatefulWidget {
  const WhatsAppTestPage({super.key});

  @override
  State<WhatsAppTestPage> createState() => _WhatsAppTestPageState();
}

class _WhatsAppTestPageState extends State<WhatsAppTestPage> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController(text: '6281234567890');

  WhatsAppTransactionModel? _lastTransaction;
  List<Map<String, dynamic>> _testHistory = [];

  final List<String> _sampleMessages = [
    'beli ketoprak 5000',
    'makan nasi 15000',
    'gojek 12000',
    'belanja 50000',
    'jual kue 25000',
    'pemasukan 5000000 gaji',
    'beli laptop 5juta',
    'beli kopi 15ribu',
    'bensin 50000',
    'parkir 5000',
  ];

  void _testMessage() {
    final message = _messageController.text.trim();
    final phoneNumber = _phoneController.text.trim();

    if (message.isEmpty) {
      _showSnackBar('Silakan masukkan pesan untuk di-test', isError: true);
      return;
    }

    final transaction = WhatsAppTransactionModel.fromWhatsAppMessage(
      phoneNumber: phoneNumber,
      message: message,
    );

    setState(() {
      _lastTransaction = transaction;
      _testHistory.insert(0, {
        'timestamp': DateTime.now(),
        'message': message,
        'transaction': transaction,
      });
    });

    _showSnackBar(
      transaction.isValid ? '✅ Pesan berhasil diparsing' : '❌ Format tidak dikenali',
      isError: !transaction.isValid,
    );
  }

  void _testSampleMessage(String message) {
    setState(() {
      _messageController.text = message;
    });
    _testMessage();
  }

  void _clearHistory() {
    setState(() {
      _testHistory.clear();
      _lastTransaction = null;
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤖 WhatsApp Bot Test'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _clearHistory,
            icon: const Icon(Icons.clear_all),
            tooltip: 'Clear History',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input Section
            _buildInputSection(),

            const SizedBox(height: 24),

            // Sample Messages
            _buildSampleMessagesSection(),

            const SizedBox(height: 24),

            // Result Section
            if (_lastTransaction != null) _buildResultSection(),

            const SizedBox(height: 24),

            // History Section
            if (_testHistory.isNotEmpty) _buildHistorySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📝 Test Message Parsing',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                hintText: '6281234567890',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Message',
                hintText: 'Contoh: beli ketoprak 5000',
                prefixIcon: Icon(Icons.message),
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onSubmitted: (_) => _testMessage(),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _testMessage,
                icon: const Icon(Icons.send),
                label: const Text('Test Parsing'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSampleMessagesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🎯 Sample Messages',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _sampleMessages.map((message) {
                return ActionChip(
                  label: Text(message),
                  onPressed: () => _testSampleMessage(message),
                  backgroundColor: Colors.grey[100],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultSection() {
    if (_lastTransaction == null) return const SizedBox.shrink();

    final transaction = _lastTransaction!;
    final isValid = transaction.isValid;

    return Card(
      color: isValid ? Colors.green[50] : Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isValid ? Icons.check_circle : Icons.error,
                  color: isValid ? Colors.green : Colors.red,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  isValid ? '✅ Parsing Success' : '❌ Parsing Failed',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: isValid ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (isValid) ...[
              _buildInfoRow('Type', transaction.transactionType),
              _buildInfoRow('Amount', transaction.formattedAmount),
              _buildInfoRow('Description', transaction.description),
              _buildInfoRow('Category', transaction.category ?? 'Tidak dikategorikan'),
              _buildInfoRow('Time', '${transaction.timestamp.day}/${transaction.timestamp.month}/${transaction.timestamp.year} ${transaction.timestamp.hour.toString().padLeft(2, '0')}:${transaction.timestamp.minute.toString().padLeft(2, '0')}'),
            ] else ...[
              Text(
                transaction.confirmationMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ],

            if (isValid) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '💬 Confirmation Message Preview:',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      transaction.confirmationMessage,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHistorySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '📊 Test History (${_testHistory.length})',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            ..._testHistory.take(10).map((item) {
              final timestamp = item['timestamp'] as DateTime;
              final message = item['message'] as String;
              final transaction = item['transaction'] as WhatsAppTransactionModel;
              final isValid = transaction.isValid;

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isValid ? Colors.green[50] : Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isValid ? Colors.green[200]! : Colors.red[200]!,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isValid ? Icons.check_circle : Icons.error,
                          color: isValid ? Colors.green : Colors.red,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (isValid) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '${transaction.formattedAmount}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(' • '),
                          Text(
                            transaction.category ?? 'Lainnya',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),

            if (_testHistory.length > 10)
              TextButton(
                onPressed: () {
                  // Scroll to top or show full history dialog
                },
                child: Text('Show ${_testHistory.length - 10} more...'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}