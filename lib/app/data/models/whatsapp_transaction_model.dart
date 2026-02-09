class WhatsAppTransactionModel {
  final String? phoneNumber;
  final String message;
  final String transactionType;
  final String description;
  final double amount;
  final DateTime timestamp;
  final String? category;

  WhatsAppTransactionModel({
    this.phoneNumber,
    required this.message,
    required this.transactionType,
    required this.description,
    required this.amount,
    required this.timestamp,
    this.category,
  });

  factory WhatsAppTransactionModel.fromWhatsAppMessage({
    required String phoneNumber,
    required String message,
    DateTime? timestamp,
  }) {
    final parsedTransaction = _parseMessage(message);

    return WhatsAppTransactionModel(
      phoneNumber: phoneNumber,
      message: message,
      transactionType: parsedTransaction['type'] ?? 'expense',
      description: parsedTransaction['description'] ?? '',
      amount: parsedTransaction['amount'] ?? 0.0,
      timestamp: timestamp ?? DateTime.now(),
      category: parsedTransaction['category'],
    );
  }

  static Map<String, dynamic> _parseMessage(String message) {
    final normalizedMessage = message.toLowerCase().trim();

    // Pattern untuk format: "beli ketoprak 5000" atau "makan nasi 15000"
    final buyPattern = RegExp(r'^(beli|makan|pesan|jual|bayar)\s+(.+?)\s+(\d+(?:\.\d+)?)\s*(?:ribu|rb|ribu|juta|jt)?$');
    final match = buyPattern.firstMatch(normalizedMessage);

    if (match != null) {
      String action = match.group(1)!;
      String description = match.group(2)!;
      String amountStr = match.group(3)!;

      double amount = double.parse(amountStr);

      // Cek suffix ribu/juta
      if (normalizedMessage.contains('ribu') || normalizedMessage.contains('rb')) {
        amount *= 1000;
      } else if (normalizedMessage.contains('juta') || normalizedMessage.contains('jt')) {
        amount *= 1000000;
      }

      String transactionType = (action == 'jual' || action == 'dapat') ? 'income' : 'expense';
      String? category = _categorizeTransaction(description);

      return {
        'type': transactionType,
        'description': description,
        'amount': amount,
        'category': category,
      };
    }

    // Pattern untuk format: "pengeluaran 5000 makan ketoprak"
    final expensePattern = RegExp(r'^(pengeluaran|expense|pengeluaran:\s*)(\d+(?:\.\d+)?)\s*(.+?)$');
    final expenseMatch = expensePattern.firstMatch(normalizedMessage);

    if (expenseMatch != null) {
      String amountStr = expenseMatch.group(2)!;
      String description = expenseMatch.group(3)!;

      double amount = double.parse(amountStr);
      if (normalizedMessage.contains('ribu') || normalizedMessage.contains('rb')) {
        amount *= 1000;
      } else if (normalizedMessage.contains('juta') || normalizedMessage.contains('jt')) {
        amount *= 1000000;
      }

      return {
        'type': 'expense',
        'description': description,
        'amount': amount,
        'category': _categorizeTransaction(description),
      };
    }

    // Pattern untuk format: "pemasukan 50000 gaji"
    final incomePattern = RegExp(r'^(pemasukan|income|pemasukan:\s*)(\d+(?:\.\d+)?)\s*(.+?)$');
    final incomeMatch = incomePattern.firstMatch(normalizedMessage);

    if (incomeMatch != null) {
      String amountStr = incomeMatch.group(2)!;
      String description = incomeMatch.group(3)!;

      double amount = double.parse(amountStr);
      if (normalizedMessage.contains('ribu') || normalizedMessage.contains('rb')) {
        amount *= 1000;
      } else if (normalizedMessage.contains('juta') || normalizedMessage.contains('jt')) {
        amount *= 1000000;
      }

      return {
        'type': 'income',
        'description': description,
        'amount': amount,
        'category': _categorizeTransaction(description),
      };
    }

    // Jika tidak ada pattern yang cocok
    return {
      'type': 'unknown',
      'description': message,
      'amount': 0.0,
      'category': null,
    };
  }

  static String? _categorizeTransaction(String description) {
    final desc = description.toLowerCase();

    // Kategori makanan
    if (desc.contains('makan') || desc.contains('nasi') || desc.contains('ketoprak') ||
        desc.contains('bakso') || desc.contains('sate') || desc.contains('ayam') ||
        desc.contains('mie') || desc.contains('kopi') || desc.contains('minum')) {
      return 'makanan';
    }

    // Kategori transportasi
    if (desc.contains('ojek') || desc.contains('gojek') || desc.contains('grab') ||
        desc.contains('taxi') || desc.contains('bensin') || desc.contains('parkir')) {
      return 'transportasi';
    }

    // Kategori belanja
    if (desc.contains('belanja') || desc.contains('toko') || desc.contains('minuman') ||
        desc.contains('snack') || desc.contains('jajan')) {
      return 'belanja';
    }

    // Kategori tagihan
    if (desc.contains('listrik') || desc.contains('pdam') || desc.contains('internet') ||
        desc.contains('pulsa') || desc.contains('tagihan')) {
      return 'tagihan';
    }

    // Kategori hiburan
    if (desc.contains('film') || desc.contains('bioskop') || desc.contains('game') ||
        desc.contains('hiburan')) {
      return 'hiburan';
    }

    // Kategori kesehatan
    if (desc.contains('obat') || desc.contains('dokter') || desc.contains('rumah sakit')) {
      return 'kesehatan';
    }

    // Kategori pendapatan
    if (desc.contains('gaji') || desc.contains('bonus') || desc.contains(' THR ') ||
        desc.contains('tunjangan')) {
      return 'pendapatan';
    }

    return 'lainnya';
  }

  Map<String, dynamic> toJson() {
    return {
      'phone_number': phoneNumber,
      'message': message,
      'transaction_type': transactionType,
      'description': description,
      'amount': amount,
      'timestamp': timestamp.toIso8601String(),
      'category': category,
    };
  }

  // Konversi ke TransactionModel untuk integrasi dengan sistem yang ada
  Map<String, dynamic> toTransactionRequest({
    required int userId,
    required int accountId,
    required int categoryId,
  }) {
    return {
      'user_id': userId,
      'account_id': accountId,
      'category_id': categoryId,
      'type': transactionType,
      'date': timestamp.toIso8601String().split('T')[0], // Format YYYY-MM-DD
      'amount': amount.toString(),
      'note': 'Dari WhatsApp: $message',
      'counterparty': phoneNumber,
    };
  }

  bool get isValid => transactionType != 'unknown' && amount > 0 && description.isNotEmpty;

  String get formattedAmount {
    if (amount >= 1000000) {
      return 'Rp ${(amount / 1000000).toStringAsFixed(1)}jt';
    } else if (amount >= 1000) {
      return 'Rp ${(amount / 1000).toStringAsFixed(0)}rb';
    } else {
      return 'Rp ${amount.toStringAsFixed(0)}';
    }
  }

  String get confirmationMessage {
    if (!isValid) {
      return '❌ Format pesan tidak dikenali. Contoh: "beli ketoprak 5000"';
    }

    String typeText = transactionType == 'income' ? 'Pemasukan' : 'Pengeluaran';
    String categoryText = category != null ? ' ($category)' : '';

    return '✅ *Transaksi Tercatat*\n\n'
           '📝 $typeText$categoryText\n'
           '💰 $formattedAmount\n'
           '📖 $description\n'
           '🕐 ${_formatDateTime(timestamp)}\n\n'
           'Data akan tersimpan otomatis di aplikasi Anda.';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}