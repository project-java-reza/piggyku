import 'package:flutter/material.dart';

class AccountModel {
  final int id;
  final String name;
  final String type;
  final double balance;
  final String icon;
  final Color color;

  AccountModel({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    required this.icon,
    required this.color,
  });
}

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  // Mock data for accounts
  final List<AccountModel> _accounts = [
    AccountModel(
      id: 1,
      name: 'Cash',
      type: 'Cash',
      balance: 2500000,
      icon: '💵',
      color: Colors.green,
    ),
    AccountModel(
      id: 2,
      name: 'BCA',
      type: 'Bank Account',
      balance: 15000000,
      icon: '🏦',
      color: Colors.blue,
    ),
    AccountModel(
      id: 3,
      name: 'Mandiri',
      type: 'Bank Account',
      balance: 8000000,
      icon: '🏦',
      color: Colors.indigo,
    ),
    AccountModel(
      id: 4,
      name: 'GoPay',
      type: 'E-Wallet',
      balance: 750000,
      icon: '📱',
      color: Colors.green,
    ),
    AccountModel(
      id: 5,
      name: 'OVO',
      type: 'E-Wallet',
      balance: 500000,
      icon: '📱',
      color: Colors.purple,
    ),
    AccountModel(
      id: 6,
      name: 'DANA',
      type: 'E-Wallet',
      balance: 350000,
      icon: '📱',
      color: Colors.blue,
    ),
    AccountModel(
      id: 7,
      name: 'Credit Card',
      type: 'Credit Card',
      balance: -2500000,
      icon: '💳',
      color: Colors.red,
    ),
  ];

  double get _totalBalance {
    return _accounts.fold(0, (sum, account) => sum + account.balance);
  }

  double get _totalAssets {
    return _accounts
        .where((account) => account.type != 'Credit Card')
        .fold(0, (sum, account) => sum + account.balance);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddAccountDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Cards
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSummaryCard(
                  title: 'Total Balance',
                  amount: _totalBalance,
                  color: const Color(0xFF2196F3),
                  icon: Icons.account_balance_wallet,
                ),
                const SizedBox(height: 12),
                _buildSummaryCard(
                  title: 'Total Assets',
                  amount: _totalAssets,
                  color: Colors.green,
                  icon: Icons.savings,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Accounts List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _accounts.length,
              itemBuilder: (context, index) {
                final account = _accounts[index];
                return _buildAccountCard(account);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required double amount,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.1),
            color.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatCurrency(amount),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard(AccountModel account) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          _showAccountOptions(account);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                account.color.withValues(alpha: 0.05),
                Colors.white,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: account.color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  account.icon,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      account.type,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatCurrency(account.balance),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: account.balance >= 0 ? Colors.black : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (account.balance < 0)
                    Text(
                      'Debt',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.red[400],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddAccountDialog() {
    final nameController = TextEditingController();
    String selectedType = 'Bank Account';
    String selectedIcon = '🏦';
    Color selectedColor = Colors.blue;
    double initialBalance = 0;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Account'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Account Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Account Type',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                    DropdownMenuItem(value: 'Bank Account', child: Text('Bank Account')),
                    DropdownMenuItem(value: 'E-Wallet', child: Text('E-Wallet')),
                    DropdownMenuItem(value: 'Credit Card', child: Text('Credit Card')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedType = value!;
                      // Auto-select icon based on type
                      switch (value) {
                        case 'Cash':
                          selectedIcon = '💵';
                          selectedColor = Colors.green;
                          break;
                        case 'Bank Account':
                          selectedIcon = '🏦';
                          selectedColor = Colors.blue;
                          break;
                        case 'E-Wallet':
                          selectedIcon = '📱';
                          selectedColor = Colors.purple;
                          break;
                        case 'Credit Card':
                          selectedIcon = '💳';
                          selectedColor = Colors.red;
                          break;
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Initial Balance',
                    border: OutlineInputBorder(),
                    prefixText: 'Rp ',
                  ),
                  onChanged: (value) {
                    initialBalance = double.tryParse(value) ?? 0;
                  },
                ),
                const SizedBox(height: 16),
                const Text('Icon'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ['💵', '🏦', '📱', '💳', '💰', '🏧', '💎']
                      .map((icon) => GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIcon = icon;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: selectedIcon == icon
                                ? const Color(0xFF2196F3)
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(icon, style: const TextStyle(fontSize: 20)),
                        ),
                      ))
                      .toList(),
                ),
                const SizedBox(height: 16),
                const Text('Color'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Colors.red,
                    Colors.pink,
                    Colors.purple,
                    Colors.blue,
                    Colors.green,
                    Colors.orange,
                    Colors.amber,
                    Colors.grey,
                  ]
                      .map((color) => GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedColor = color;
                          });
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: selectedColor == color
                                ? Border.all(color: Colors.black, width: 2)
                                : null,
                          ),
                        ),
                      ))
                      .toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  // TODO: Save account to database
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Account added successfully')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAccountOptions(AccountModel account) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: const Text('Edit Account'),
              onTap: () {
                Navigator.of(context).pop();
                // TODO: Show edit dialog
              },
            ),
            ListTile(
              leading: const Icon(Icons.history, color: Colors.green),
              title: const Text('View Transactions'),
              onTap: () {
                Navigator.of(context).pop();
                // TODO: Navigate to account transactions
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Account'),
              onTap: () {
                Navigator.of(context).pop();
                _showDeleteConfirmation(account);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(AccountModel account) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: Text('Are you sure you want to delete "${account.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Delete account from database
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account deleted successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    if (amount < 0) {
      return '-Rp ${(-amount).toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match.group(1)}.')}';
    }
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match.group(1)}.')}';
  }
}