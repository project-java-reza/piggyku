import 'package:dio/dio.dart';
import '../models/whatsapp_transaction_model.dart';
import '../../../core/helper/api_helper.dart';
import '../../../core/errors/exceptions.dart';

class WhatsAppService {
  static const String _baseUrl = 'https://graph.facebook.com/v18.0';
  static const Duration _timeout = Duration(seconds: 30);

  final ApiHelper _apiHelper;
  final String _whatsappToken;
  final String _phoneNumberId;

  WhatsAppService({
    required ApiHelper apiHelper,
    required String whatsappToken,
    required String phoneNumberId,
  })  : _apiHelper = apiHelper,
        _whatsappToken = whatsappToken,
        _phoneNumberId = phoneNumberId;

  /// Verify webhook dari WhatsApp (untuk setup awal)
  Future<bool> verifyWebhook({
    required String mode,
    required String token,
    required String challenge,
  }) async {
    // Verifikasi token dari WhatsApp
    const String verifyToken = 'YOUR_VERIFY_TOKEN_HERE'; // Harus sama dengan yang di WhatsApp Business API

    if (mode == 'subscribe' && token == verifyToken) {
      return true;
    }
    return false;
  }

  /// Process incoming WhatsApp message
  Future<Map<String, dynamic>> processIncomingMessage({
    required Map<String, dynamic> webhookData,
  }) async {
    try {
      // Extract message dari webhook
      final entry = webhookData['entry']?.first;
      final changes = entry?['changes']?.first;
      final messages = changes?['value']?['messages'];

      if (messages == null || messages.isEmpty) {
        return {'status': 'no_message', 'message': 'No message found'};
      }

      final message = messages.first;
      final String? messageType = message['type'];

      if (messageType != 'text') {
        return {'status': 'unsupported_message', 'message': 'Only text messages are supported'};
      }

      final String phoneNumber = message['from'] ?? '';
      final String textMessage = message['text']?['body'] ?? '';
      // final String messageId = message['id'] ?? ''; // unused for now

      // Parse transaksi dari pesan
      final whatsappTransaction = WhatsAppTransactionModel.fromWhatsAppMessage(
        phoneNumber: phoneNumber,
        message: textMessage,
        timestamp: DateTime.now(),
      );

      if (!whatsappTransaction.isValid) {
        await sendWhatsAppMessage(
          phoneNumber: phoneNumber,
          message: '❌ Format tidak dikenali. Contoh penggunaan:\n\n'
                 '• *beli ketoprak 5000*\n'
                 '• *makan nasi 15000*\n'
                 '• *pengeluaran 20000 belanja*\n'
                 '• *pemasukan 5000000 gaji*\n\n'
                 'Format mendukung *ribu* atau *rb* untuk ribuan, dan *juta* atau *jt* untuk jutaan.',
        );
        return {
          'status': 'invalid_format',
          'message': 'Invalid message format',
          'original_message': textMessage,
        };
      }

      // Simpan transaksi ke database
      final result = await _saveTransaction(whatsappTransaction);

      if (result['success']) {
        // Kirim konfirmasi ke WhatsApp
        await sendWhatsAppMessage(
          phoneNumber: phoneNumber,
          message: whatsappTransaction.confirmationMessage,
        );

        return {
          'status': 'success',
          'message': 'Transaction saved successfully',
          'transaction': whatsappTransaction.toJson(),
          'database_result': result,
        };
      } else {
        // Kirim pesan error
        await sendWhatsAppMessage(
          phoneNumber: phoneNumber,
          message: '❌ Gagal menyimpan transaksi. Silakan coba lagi atau hubungi admin.\n\n'
                 'Error: ${result['error']}',
        );

        return {
          'status': 'save_failed',
          'message': 'Failed to save transaction',
          'error': result['error'],
          'transaction': whatsappTransaction.toJson(),
        };
      }
    } catch (e) {
      // Error handling for WhatsApp message processing
      return {
        'status': 'error',
        'message': 'Internal server error',
        'error': e.toString(),
      };
    }
  }

  /// Kirim pesan WhatsApp ke user
  Future<void> sendWhatsAppMessage({
    required String phoneNumber,
    required String message,
  }) async {
    try {
      final dio = Dio();
      final url = '$_baseUrl/$_phoneNumberId/messages';

      final headers = {
        'Authorization': 'Bearer $_whatsappToken',
        'Content-Type': 'application/json',
      };

      final body = {
        'messaging_product': 'whatsapp',
        'to': phoneNumber,
        'type': 'text',
        'text': {'body': message},
      };

      final response = await dio.post(
        url,
        data: body,
        options: Options(
          headers: headers,
        ),
      ).timeout(_timeout);

      if (response.statusCode != 200) {
        throw const WhatsAppException(
          message: 'Failed to send WhatsApp message',
        );
      }
    } on DioException catch (e) {
      throw WhatsAppException(
        message: 'Failed to send WhatsApp message: ${e.message}',
      );
    } catch (e) {
      throw const WhatsAppException(
        message: 'Failed to send WhatsApp message',
      );
    }
  }

  /// Simpan transaksi ke database melalui API
  Future<Map<String, dynamic>> _saveTransaction(
    WhatsAppTransactionModel whatsappTransaction,
  ) async {
    try {
      // Default values - ini bisa diatur berdasarkan user preferences
      const int defaultUserId = 1; // Ambil dari auth user
      const int defaultAccountId = 1; // Default account
      const int defaultExpenseCategoryId = 1; // Default expense category
      const int defaultIncomeCategoryId = 2; // Default income category

      final categoryId = whatsappTransaction.transactionType == 'income'
          ? defaultIncomeCategoryId
          : defaultExpenseCategoryId;

      final transactionData = whatsappTransaction.toTransactionRequest(
        userId: defaultUserId,
        accountId: defaultAccountId,
        categoryId: categoryId,
      );

      // Gunakan API helper untuk menyimpan transaksi
      final response = await _apiHelper.post(
        '/transactions',
        transactionData,
        null,
      );

      return {
        'success': true,
        'data': response.data,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Kirim pesan bantuan/daftar perintah
  Future<void> sendHelpMessage(String phoneNumber) async {
    const helpMessage = '''
🤖 *FinAI WhatsApp Bot - Bantuan*

Saya bisa membantu Anda mencatat transaksi keuangan secara otomatis melalui WhatsApp!

📝 *Format yang didukung:*

1. *Format Sederhana:*
   • beli ketoprak 5000
   • makan nasi 15000
   • jual kue 25000

2. *Format Detail:*
   • pengeluaran 20000 belanja kebutuhan
   • pemasukan 5000000 gaji bulanan

3. *Mendukung Satuan:*
   • beli kopi 15ribu (15.000)
   • beli laptop 5juta (5.000.000)

💡 *Tips:*
• Gunakan format yang konsisten agar bot dapat memahami pesan Anda
• Transaksi akan otomatis tercatat di aplikasi FinAI Anda
• Anda akan menerima konfirmasi setiap transaksi berhasil dicatat

🔒 *Keamanan:*
• Hanya nomor telepon terverifikasi yang dapat menggunakan layanan ini
• Semua data transaksi dienkripsi dan aman

Perlu bantuan lebih lanjut? Hubungi admin kami! 📞
    ''';

    await sendWhatsAppMessage(
      phoneNumber: phoneNumber,
      message: helpMessage,
    );
  }

  /// Kirim ringkasan transaksi hari ini
  Future<void> sendDailySummary(String phoneNumber) async {
    try {
      // Ambil data transaksi hari ini dari API
      final today = DateTime.now();
      final startDate = DateTime(today.year, today.month, today.day);
      final endDate = startDate.add(const Duration(days: 1));

      final response = await _apiHelper.get(
        '/transactions/statistics',
        {
          'start_date': startDate.toIso8601String().split('T')[0],
          'end_date': endDate.toIso8601String().split('T')[0],
        },
        null,
      );

      if (response.statusCode == 200 && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;
        final stats = (responseData['data'] ?? responseData) as Map<String, dynamic>;
        final totalExpense = double.tryParse(stats['total_expense'].toString()) ?? 0;
        final totalIncome = double.tryParse(stats['total_income'].toString()) ?? 0;
        final transactionCount = stats['transaction_count'] ?? 0;

        String summaryMessage = '📊 *Ringkasan Transaksi Hari Ini*\n\n';
        summaryMessage += '📅 ${today.day}/${today.month}/${today.year}\n\n';
        summaryMessage += '💰 *Pemasukan*: Rp ${totalIncome.toStringAsFixed(0)}\n';
        summaryMessage += '💸 *Pengeluaran*: Rp ${totalExpense.toStringAsFixed(0)}\n';
        summaryMessage += '📈 *Saldo Net*: Rp ${(totalIncome - totalExpense).toStringAsFixed(0)}\n';
        summaryMessage += '🔢 *Jumlah Transaksi*: $transactionCount\n\n';

        if (totalExpense > 0) {
          summaryMessage += 'Kontrol pengeluaran Anda agar tetap dalam anggaran ya! 💪';
        } else {
          summaryMessage += 'Belum ada transaksi hari ini. Ajak teman makan siang! 😊';
        }

        await sendWhatsAppMessage(
          phoneNumber: phoneNumber,
          message: summaryMessage,
        );
      } else {
        await sendWhatsAppMessage(
          phoneNumber: phoneNumber,
          message: '❌ Gagal mengambil data ringkasan. Silakan coba lagi nanti.',
        );
      }
    } catch (e) {
      await sendWhatsAppMessage(
        phoneNumber: phoneNumber,
        message: '❌ Terjadi kesalahan saat mengambil data. Silakan coba lagi nanti.',
      );
    }
  }
}