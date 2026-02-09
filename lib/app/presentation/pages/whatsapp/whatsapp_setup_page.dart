import 'package:flutter/material.dart';
import '../../../../core/config/app_config.dart';

class WhatsAppSetupPage extends StatefulWidget {
  const WhatsAppSetupPage({super.key});

  @override
  State<WhatsAppSetupPage> createState() => _WhatsAppSetupPageState();
}

class _WhatsAppSetupPageState extends State<WhatsAppSetupPage> {
  bool _isConnected = false;
  bool _isConnecting = false;
  String _phoneNumber = '';
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    _checkConnectionStatus();
  }

  Future<void> _checkConnectionStatus() async {
    setState(() {
      _isConnecting = true;
      _statusMessage = 'Memeriksa koneksi WhatsApp...';
    });

    // Simulasi pengecekan koneksi
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isConnecting = false;
      _isConnected = false; // Ganti dengan logic pengecekan actual
      _statusMessage = _isConnected
          ? 'Terhubung dengan WhatsApp Business'
          : 'Belum terhubung dengan WhatsApp Business';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WhatsApp Integration'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildConnectionStatus(),
            const SizedBox(height: 24),
            _buildSetupInstructions(),
            const SizedBox(height: 24),
            _buildMessageFormats(),
            const SizedBox(height: 24),
            _buildTestSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionStatus() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _isConnected ? Icons.check_circle : Icons.warning,
                  color: _isConnected ? Colors.green : Colors.orange,
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Status Koneksi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_isConnecting)
              const CircularProgressIndicator()
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _statusMessage,
                    style: TextStyle(
                      fontSize: 14,
                      color: _isConnected ? Colors.green : Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (!_isConnected)
                    ElevatedButton(
                      onPressed: _isConnecting ? null : _setupWhatsApp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Hubungkan Sekarang'),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetupInstructions() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📋 Cara Setup',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildInstructionStep(
              '1',
              'Daftar WhatsApp Business API di Meta for Developers',
            ),
            _buildInstructionStep(
              '2',
              'Setup webhook URL: https://your-domain.com/webhook',
            ),
            _buildInstructionStep(
              '3',
              'Configure phone number dan dapatkan credentials',
            ),
            _buildInstructionStep(
              '4',
              'Input credentials di bawah ini',
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'WhatsApp Business Token',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.key),
              ),
              onChanged: (value) {
                // TODO: Simpan token
              },
              obscureText: true,
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Phone Number ID',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              onChanged: (value) {
                // TODO: Simpan phone number ID
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionStep(String step, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Color(0xFF2196F3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                step,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              description,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageFormats() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '💬 Format Pesan yang Didukung',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildMessageFormatExample('beli ketoprak 5000', 'Pengeluaran makanan'),
            _buildMessageFormatExample('makan nasi 15000', 'Pengeluaran makanan'),
            _buildMessageFormatExample('pengeluaran 20000 belanja', 'Pengeluaran belanja'),
            _buildMessageFormatExample('pemasukan 5000000 gaji', 'Pemasukan gaji'),
            _buildMessageFormatExample('jual kue 25000', 'Pemasukan lainnya'),
            const SizedBox(height: 8),
            const Text(
              '💡 Tips: Gunakan "ribu" atau "rb" untuk ribuan, "juta" atau "jt" untuk jutaan',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageFormatExample(String format, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    format,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'monospace',
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy, size: 16),
              onPressed: () {
                // TODO: Copy to clipboard
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🧪 Test WhatsApp Bot',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Nomor WhatsApp (62xx)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                _phoneNumber = value;
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isConnected && _phoneNumber.isNotEmpty
                        ? _sendTestMessage
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Kirim Test Message'),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isConnected ? _sendHelpMessage : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Kirim Help'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _setupWhatsApp() async {
    setState(() {
      _isConnecting = true;
      _statusMessage = 'Menghubungkan ke WhatsApp Business...';
    });

    try {
      // TODO: Implement actual WhatsApp setup logic
      await Future.delayed(const Duration(seconds: 3));

      setState(() {
        _isConnecting = false;
        _isConnected = true;
        _statusMessage = 'Berhasil terhubung dengan WhatsApp Business!';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('WhatsApp Business berhasil dihubungkan!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isConnecting = false;
        _statusMessage = 'Gagal menghubungkan WhatsApp Business';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _sendTestMessage() async {
    try {
      // TODO: Implement sending test message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Test message terkirim!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengirim pesan: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _sendHelpMessage() async {
    try {
      // TODO: Implement sending help message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Help message terkirim!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengirim pesan: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}