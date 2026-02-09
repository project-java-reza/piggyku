import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../utils/budget_alert_helper.dart';

// Top-level class definitions
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class TransactionData {
  final String description;
  final double amount;
  final bool isIncome;
  final String categoryName;
  final String accountName;
  final int categoryId;
  final int accountId;

  TransactionData({
    required this.description,
    required this.amount,
    required this.isIncome,
    required this.categoryName,
    required this.accountName,
    required this.categoryId,
    required this.accountId,
  });
}

class AccountModel {
  final int id;
  final String name;
  final String type;

  AccountModel({
    required this.id,
    required this.name,
    required this.type,
  });
}

class CategoryModel {
  final int id;
  final String name;
  final String type;

  CategoryModel({
    required this.id,
    required this.name,
    required this.type,
  });
}

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  // Mock data for accounts and categories
  final List<AccountModel> _accounts = [
    AccountModel(id: 1, name: 'Cash', type: 'cash'),
    AccountModel(id: 2, name: 'BCA', type: 'bank'),
    AccountModel(id: 3, name: 'GoPay', type: 'ewallet'),
  ];

  final List<CategoryModel> _incomeCategories = [
    CategoryModel(id: 1, name: 'Salary', type: 'income'),
    CategoryModel(id: 2, name: 'Freelance', type: 'income'),
    CategoryModel(id: 3, name: 'Business', type: 'income'),
    CategoryModel(id: 4, name: 'Investment', type: 'income'),
  ];

  final List<CategoryModel> _expenseCategories = [
    CategoryModel(id: 5, name: 'Food & Beverages', type: 'expense'),
    CategoryModel(id: 6, name: 'Shopping', type: 'expense'),
    CategoryModel(id: 7, name: 'Transportation', type: 'expense'),
    CategoryModel(id: 8, name: 'Bills & Utilities', type: 'expense'),
    CategoryModel(id: 9, name: 'Healthcare', type: 'expense'),
    CategoryModel(id: 10, name: 'Education', type: 'expense'),
  ];

  @override
  void initState() {
    super.initState();
    // Add welcome message
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    setState(() {
      _messages.add(ChatMessage(
        text: '🎤 Halo! Saya FinAI, asisten finansial Anda.\n\n'
            'Saya bisa membantu Anda mencatat transaksi dengan mudah. Coba:\n\n'
            '💬 **Teks:**\n'
            '• "Income: gaji bulanan 8 juta"\n'
            '• "Expense: beli bakso 25 ribu"\n'
            '• "Food: nasi goreng 15rb"\n'
            '• "Shopping: baju baru 200rb"\n\n'
            'Atau gunakan tombol Quick Actions di bawah!',
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF2196F3),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.smart_toy, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FinAI Assistant',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Catat transaksi dengan mudah',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Quick Actions
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2196F3),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickAction(
                        icon: Icons.trending_up,
                        label: 'Income',
                        color: Colors.green,
                        onTap: () => _handleQuickAction('income'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildQuickAction(
                        icon: Icons.trending_down,
                        label: 'Expense',
                        color: Colors.red,
                        onTap: () => _handleQuickAction('expense'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildQuickAction(
                        icon: Icons.restaurant,
                        label: 'Food',
                        color: Colors.orange,
                        onTap: () => _handleQuickAction('food'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildQuickAction(
                        icon: Icons.shopping_bag,
                        label: 'Shopping',
                        color: Colors.purple,
                        onTap: () => _handleQuickAction('shopping'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Chat messages
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _buildMessageBubble(message);
                },
              ),
            ),
          ),

          // Message input
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.smart_toy,
                color: Color(0xFF2196F3),
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser ? const Color(0xFF2196F3) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: message.isUser
                      ? const Color(0xFF2196F3)
                      : Colors.grey.withValues(alpha: 0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: message.isUser ? Colors.white : Colors.black87,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatTime(message.timestamp),
                    style: TextStyle(
                      color: message.isUser ? Colors.white70 : Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.person,
                color: Colors.grey[600],
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Ketik atau tekan mic untuk voice...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                style: const TextStyle(fontSize: 14),
                onSubmitted: (text) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFF2196F3),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: _sendMessage,
              icon: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    // Add user message
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
    });

    _messageController.clear();
    _scrollToBottom();

    // Process the message and generate AI response
    _processMessage(text);
  }

  void _processMessage(String message) {
    // Simulate AI processing
    Future.delayed(const Duration(milliseconds: 1000), () {
      final response = _generateAIResponse(message);

      setState(() {
        _messages.add(ChatMessage(
          text: response,
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });

      _scrollToBottom();
    });
  }

  String _generateAIResponse(String message) {
    // Extract transaction information
    final transaction = _parseTransaction(message);

    if (transaction != null) {
      // Save transaction to database
      saveTransactionToDatabase(transaction);

      // Generate confirmation response
      return '✅ Transaksi berhasil dicatat!\n\n'
          '📝 ${transaction.isIncome ? "Pemasukan" : "Pengeluaran"}: ${transaction.description}\n'
          '💰 Jumlah: ${formatCurrency(transaction.amount)}\n'
          '📂 Kategori: ${transaction.categoryName}\n'
          '💳 Akun: ${transaction.accountName}\n'
          '📅 Tanggal: ${formatDate(DateTime.now())}\n\n'
          'Apakah ada yang lain bisa saya bantu?';
    } else {
      // Generate help response
      return 'Maaf, saya tidak mengenali format tersebut. Silakan coba dengan format:\n\n'
          '• "saya beli [nama barang] seharga [jumlah]"\n'
          '• "[nama barang] [jumlah]"\n'
          '• "income [jumlah] dari [sumber]"\n'
          '• "expense [jumlah] untuk [tujuan]"\n\n'
          'Contoh: "saya beli botol air seharga 5000"';
    }
  }

  TransactionData? _parseTransaction(String message) {
    final lowerMessage = message.toLowerCase();

    // Check for "Category: description" format
    String categoryPrefix = '';
    String actualMessage = message;

    if (message.contains(':')) {
      final colonIndex = message.indexOf(':');
      if (colonIndex != -1) {
        categoryPrefix = message.substring(0, colonIndex).trim();
        actualMessage = message.substring(colonIndex + 1).trim();
      }
    }

    // Common keywords for amounts
    final amountRegex = RegExp(
        r'(\d+\.?\d*)\s*(ribu|juta|rb|jt|k|thousand|million|miliar|mil)?');
    final match = amountRegex.firstMatch(actualMessage.toLowerCase());

    if (match != null) {
      double amount = double.parse(match.group(1)!);
      final unit = match.group(2);

      // Convert units to actual amounts
      switch (unit) {
        case 'ribu':
        case 'rb':
          amount *= 1000;
          break;
        case 'juta':
        case 'jt':
          amount *= 1000000;
          break;
        case 'k':
        case 'thousand':
          amount *= 1000;
          break;
        case 'million':
        case 'mil':
          amount *= 1000000;
          break;
        case 'miliar':
          amount *= 1000000000;
          break;
      }

      // Determine if it's income or expense
      bool isIncome = false;
      String description = '';

      // Check category prefix first
      if (categoryPrefix.toLowerCase() == 'income') {
        isIncome = true;
        description = actualMessage.isNotEmpty ? actualMessage : 'Pemasukan';
      } else if (categoryPrefix.toLowerCase() == 'expense') {
        isIncome = false;
        description = actualMessage.isNotEmpty ? actualMessage : 'Pengeluaran';
      } else {
        // Fallback to keyword detection for legacy messages
        if (lowerMessage.contains('gaji') ||
            lowerMessage.contains('income') ||
            lowerMessage.contains('pemasukan') ||
            lowerMessage.contains('dapat') ||
            lowerMessage.contains('terima')) {
          isIncome = true;
        }

        // Extract description for legacy messages
        if (actualMessage.contains('beli')) {
          description = extractAfterKeyword(actualMessage, 'beli');
        } else if (actualMessage.contains('makan') ||
            actualMessage.contains('makanan')) {
          description = 'Makanan';
        } else if (lowerMessage.contains('minum')) {
          description = 'Minuman';
        } else if (lowerMessage.contains('transport') ||
            lowerMessage.contains('ojek') ||
            lowerMessage.contains('grab')) {
          description = 'Transportasi';
        } else if (lowerMessage.contains('listrik') ||
            lowerMessage.contains('pln')) {
          description = 'Listrik';
        } else if (lowerMessage.contains('internet') ||
            lowerMessage.contains('wifi')) {
          description = 'Internet';
        } else {
          // Try to extract item name before amount
          final beforeAmount = lowerMessage.split(RegExp(r'\d+'))[0].trim();
          if (beforeAmount.isNotEmpty) {
            description = beforeAmount;
          } else {
            description = 'Transaksi';
          }
        }
      }

      // Intelligent category assignment
      String categoryName = '';
      String accountName = 'Cash'; // Default account

      // Priority: Use category prefix if available
      if (categoryPrefix.isNotEmpty) {
        switch (categoryPrefix.toLowerCase()) {
          case 'income':
            categoryName = 'Salary';
            break;
          case 'expense':
            categoryName = 'Shopping';
            break;
          case 'food':
            categoryName = 'Food & Beverages';
            break;
          case 'shopping':
            categoryName = 'Shopping';
            break;
          default:
            // Fallback to keyword detection for unknown categories
            if (categoryPrefix.toLowerCase().contains('makan') ||
                categoryPrefix.toLowerCase().contains('makanan')) {
              categoryName = 'Food & Beverages';
            } else {
              categoryName = categoryPrefix;
            }
        }
      } else {
        // Legacy keyword-based category assignment
        if (lowerMessage.contains('makan') ||
            lowerMessage.contains('makanan')) {
          categoryName = 'Food & Beverages';
        } else if (lowerMessage.contains('minum')) {
          categoryName = 'Food & Beverages';
        } else if (lowerMessage.contains('transport') ||
            lowerMessage.contains('ojek') ||
            lowerMessage.contains('grab') ||
            lowerMessage.contains('gojek') ||
            lowerMessage.contains('taxi')) {
          categoryName = 'Transportation';
        } else if (lowerMessage.contains('listrik') ||
            lowerMessage.contains('pln')) {
          categoryName = 'Bills & Utilities';
        } else if (lowerMessage.contains('internet') ||
            lowerMessage.contains('wifi')) {
          categoryName = 'Bills & Utilities';
        } else if (lowerMessage.contains('baju') ||
            lowerMessage.contains('pakaian') ||
            lowerMessage.contains('shopping') ||
            lowerMessage.contains('belanja')) {
          categoryName = 'Shopping';
        } else if (lowerMessage.contains('freelance') ||
            lowerMessage.contains('project')) {
          categoryName = 'Freelance';
          isIncome = true;
        } else if (lowerMessage.contains('gaji') ||
            lowerMessage.contains('salary')) {
          categoryName = 'Salary';
          isIncome = true;
        } else if (lowerMessage.contains('bisnis') ||
            lowerMessage.contains('business')) {
          categoryName = 'Business';
          isIncome = true;
        } else {
          // Default category based on income/expense
          categoryName = isIncome ? 'Freelance' : 'Shopping';
        }
      }

      // Get appropriate category and account IDs
      final categories = isIncome ? _incomeCategories : _expenseCategories;
      final selectedCategory = categories.firstWhere(
        (cat) => cat.name.toLowerCase() == categoryName.toLowerCase(),
        orElse: () => categories.first,
      );

      final selectedAccount = _accounts.firstWhere(
        (acc) => acc.name.toLowerCase() == accountName.toLowerCase(),
        orElse: () => _accounts.first,
      );

      return TransactionData(
        description: description,
        amount: amount,
        isIncome: isIncome,
        categoryName: selectedCategory.name,
        accountName: selectedAccount.name,
        categoryId: selectedCategory.id,
        accountId: selectedAccount.id,
      );
    }

    return null;
  }

  void _handleQuickAction(String type) {
    String template = '';
    switch (type) {
      case 'income':
        template = 'Income: ';
        break;
      case 'expense':
        template = 'Expense: ';
        break;
      case 'food':
        template = 'Food: ';
        break;
      case 'shopping':
        template = 'Shopping: ';
        break;
    }

    _messageController.text = template;
    _messageController.selection = TextSelection.fromPosition(
      TextPosition(offset: _messageController.text.length),
    );
    // Focus on text input so user can continue typing
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String formatCurrency(double amount) {
    if (amount >= 1000000000) {
      return 'Rp ${(amount / 1000000000).toStringAsFixed(1)} Miliar';
    } else if (amount >= 1000000) {
      return 'Rp ${(amount / 1000000).toStringAsFixed(1)} Juta';
    } else if (amount >= 1000) {
      return 'Rp ${(amount / 1000).toStringAsFixed(0)} Ribu';
    } else {
      return 'Rp ${amount.toStringAsFixed(0)}';
    }
  }

  String formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  String extractAfterKeyword(String text, String keyword) {
    final index = text.indexOf(keyword);
    if (index != -1) {
      final afterKeyword = text.substring(index + keyword.length).trim();
      final amountMatch = RegExp(r'\d+').firstMatch(afterKeyword);
      if (amountMatch != null) {
        final beforeAmount =
            afterKeyword.substring(0, amountMatch.start).trim();
        if (beforeAmount.isNotEmpty) {
          return beforeAmount;
        }
      }
    }
    return 'Barang';
  }

  void saveTransactionToDatabase(TransactionData transaction) {
    // Create transaction data in the same format as AddTransactionPage
    final transactionData = {
      'accountId': transaction.accountId,
      'categoryId': transaction.categoryId,
      'type': transaction.isIncome ? 'income' : 'expense',
      'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'amount': transaction.amount,
      'note': transaction.description,
      'counterparty': null, // Can be extracted from message in future
    };

    // Simulate API call delay then show budget alert
    Future.delayed(const Duration(milliseconds: 800), () async {
      if (mounted) {
        await BudgetAlertHelper.showTransactionBudgetAlert(
          context: context,
          transactionTitle: transaction.description,
          amount: transaction.amount,
          isIncome: transaction.isIncome,
        );
      }
    });

    // For debugging: log the transaction data
    debugPrint('🔍 FinAI Transaction Saved: $transactionData');
    debugPrint(
        '📊 Category: ${transaction.categoryName} (${transaction.categoryId})');
    debugPrint(
        '💳 Account: ${transaction.accountName} (${transaction.accountId})');
    debugPrint('💰 Amount: Rp ${transaction.amount.toStringAsFixed(0)}');
    debugPrint('📝 Description: ${transaction.description}');
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
