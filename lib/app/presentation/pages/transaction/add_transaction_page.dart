import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../utils/budget_alert_helper.dart';

// Temporary mock models until real ones are available
class AccountModel {
  final int id;
  final String name;
  final String type;

  AccountModel({required this.id, required this.name, required this.type});
}

class CategoryModel {
  final int id;
  final String name;
  final String type;

  CategoryModel({required this.id, required this.name, required this.type});
}

// Temporary colors until AppColors is available
class _AppColors {
  static const Color primary = Color(0xFF2196F3);
  static const Color income = Color(0xFF4CAF50);
  static const Color expense = Color(0xFFF44336);
  static const Color textPrimary = Color(0xFF212121);
  static const Color surface = Color(0xFFF5F5F5);
  static const Color border = Color(0xFFE0E0E0);
}

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();
  final _counterpartyController = TextEditingController();
  final _amountController = TextEditingController();

  String _selectedType = 'income';
  int? _selectedCategoryId;
  int? _selectedAccountId;
  DateTime _selectedDate = DateTime.now();

  List<AccountModel> _accounts = [];
  List<CategoryModel> _incomeCategories = [];
  List<CategoryModel> _expenseCategories = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMockData();
    // Check if budget setup is needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BudgetAlertHelper.checkAndShowBudgetSetup(context);
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    _counterpartyController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _loadMockData() {
    // Mock data for demonstration
    setState(() {
      _accounts = [
        AccountModel(id: 1, name: 'Cash', type: 'cash'),
        AccountModel(id: 2, name: 'Bank Account', type: 'bank'),
        AccountModel(id: 3, name: 'E-Wallet', type: 'digital'),
      ];

      _incomeCategories = [
        CategoryModel(id: 1, name: 'Salary', type: 'income'),
        CategoryModel(id: 2, name: 'Freelance', type: 'income'),
        CategoryModel(id: 3, name: 'Business', type: 'income'),
        CategoryModel(id: 4, name: 'Investment', type: 'income'),
      ];

      _expenseCategories = [
        CategoryModel(id: 5, name: 'Food & Beverages', type: 'expense'),
        CategoryModel(id: 6, name: 'Transportation', type: 'expense'),
        CategoryModel(id: 7, name: 'Shopping', type: 'expense'),
        CategoryModel(id: 8, name: 'Bills & Utilities', type: 'expense'),
        CategoryModel(id: 9, name: 'Entertainment', type: 'expense'),
      ];

      if (_accounts.isNotEmpty && _selectedAccountId == null) {
        _selectedAccountId = _accounts.first.id;
      }
      if (_incomeCategories.isNotEmpty && _selectedCategoryId == null) {
        _selectedCategoryId = _incomeCategories.first.id;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
        backgroundColor: _AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Transaction Type
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Transaction Type',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedType = 'income';
                                    if (_incomeCategories.isNotEmpty) {
                                      _selectedCategoryId =
                                          _incomeCategories.first.id;
                                    }
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: _selectedType == 'income'
                                        ? _AppColors.income.withValues(
                                            alpha: 0.1,
                                          )
                                        : Colors.grey[100],
                                    border: Border.all(
                                      color: _selectedType == 'income'
                                          ? _AppColors.income
                                          : Colors.grey[300]!,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.arrow_upward,
                                        color: _AppColors.income,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Income',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedType = 'expense';
                                    if (_expenseCategories.isNotEmpty) {
                                      _selectedCategoryId =
                                          _expenseCategories.first.id;
                                    }
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: _selectedType == 'expense'
                                        ? _AppColors.expense.withValues(
                                            alpha: 0.1,
                                          )
                                        : Colors.grey[100],
                                    border: Border.all(
                                      color: _selectedType == 'expense'
                                          ? _AppColors.expense
                                          : Colors.grey[300]!,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.arrow_downward,
                                        color: _AppColors.expense,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Expense',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Amount
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Rp',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _AppColors.textPrimary,
                        ),
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(minWidth: 50),
                    border: const OutlineInputBorder(),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(12),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Amount is required';
                    }
                    // Remove all non-digit characters (including dots/commas)
                    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
                    if (digitsOnly.isEmpty || double.tryParse(digitsOnly) == null) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Note
                TextFormField(
                  controller: _noteController,
                  decoration: const InputDecoration(
                    labelText: 'Note',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Counterparty
                TextFormField(
                  controller: _counterpartyController,
                  decoration: const InputDecoration(
                    labelText: 'Counterparty (Optional)',
                    border: OutlineInputBorder(),
                    hintText: 'Client/Supplier name',
                  ),
                ),
                const SizedBox(height: 16),

                // Category
                DropdownButtonFormField<int>(
                  value: _selectedCategoryId,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      (_selectedType == 'income'
                              ? _incomeCategories
                              : _expenseCategories)
                          .map(
                            (category) => DropdownMenuItem<int>(
                              value: category.id,
                              child: Text(category.name),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategoryId = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Account
                DropdownButtonFormField<int>(
                  value: _selectedAccountId,
                  decoration: const InputDecoration(
                    labelText: 'Account',
                    border: OutlineInputBorder(),
                  ),
                  items: _accounts
                      .map(
                        (account) => DropdownMenuItem<int>(
                          value: account.id,
                          child: Text(account.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedAccountId = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select an account';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Date
                InkWell(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null && picked != _selectedDate) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Save Button
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });

                            // Parse amount
                            final amount = double.parse(_amountController.text);

                            // Format date to yyyy-MM-dd
                            final formattedDate = DateFormat(
                              'yyyy-MM-dd',
                            ).format(_selectedDate);

                            // Simulate API call
                            await Future.delayed(const Duration(seconds: 1));

                            // Create transaction
                            _createTransaction(amount, formattedDate);

                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Save Transaction',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      );
  }

  void _createTransaction(double amount, String formattedDate) {
    // For now, we'll create a mock transaction since we're using Cubit pattern
    // This would normally call the TransactionCubit create method

    // Get category and account names
    final categories = _selectedType == 'income' ? _incomeCategories : _expenseCategories;
    final selectedCategory = categories.firstWhere(
      (cat) => cat.id == _selectedCategoryId,
      orElse: () => categories.first,
    );
    final selectedAccount = _accounts.firstWhere(
      (acc) => acc.id == _selectedAccountId,
      orElse: () => _accounts.first,
    );

    // Simulate API call delay then show budget alert
    Future.delayed(const Duration(milliseconds: 1000), () async {
      if (mounted) {
        await BudgetAlertHelper.showTransactionBudgetAlert(
          context: context,
          transactionTitle: selectedCategory.name,
          amount: amount,
          isIncome: _selectedType == 'income',
        );
      }
    });
  }

  void _showSwaggerStyleAlert(double amount, CategoryModel category, AccountModel account) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.shade400, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green.shade700,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'POST /api/v1/transactions',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const Text(
                          '201 Created',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Response Section
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Response Body:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildSwaggerField('id', 'txn_${DateTime.now().millisecondsSinceEpoch}'),
                      _buildSwaggerField('status', 'success'),
                      _buildSwaggerField('message', 'Transaction created successfully'),
                      const SizedBox(height: 8),
                      const Text(
                        'data:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                      _buildSwaggerField('transaction_id', _selectedAccountId.toString()),
                      _buildSwaggerField('type', _selectedType),
                      _buildSwaggerField('amount', amount.toString()),
                      _buildSwaggerField('description', _noteController.text.isNotEmpty ? _noteController.text : 'No description'),
                      _buildSwaggerField('category', category.name),
                      _buildSwaggerField('account', account.name),
                      _buildSwaggerField('date', DateFormat('yyyy-MM-dd HH:mm:ss').format(_selectedDate)),
                      _buildSwaggerField('counterparty', _counterpartyController.text.isNotEmpty ? _counterpartyController.text : 'null'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Footer Section
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.grey.shade600,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Transaction successfully saved to database. You can view it in your transaction history.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop(); // Go back to dashboard
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green.shade50,
                        foregroundColor: Colors.green.shade700,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.green.shade300),
                        ),
                      ),
                      child: const Text(
                        'Close',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSwaggerField(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$key: ',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Flexible(
            child: Text(
              '"$value"',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green.shade700,
                fontFamily: 'monospace',
              ),
            ),
          ),
          const Text(',', style: TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }
}