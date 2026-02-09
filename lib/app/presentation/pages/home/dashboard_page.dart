import 'package:flutter/material.dart';
import '../../../../design/design.dart';
import '../chat/ai_chat_page.dart';
import '../transaction/add_transaction_page.dart';
import '../transaction/transactions_page.dart';
import '../budget/budget_setup_page.dart';
import '../category/categories_page.dart';
import '../account/accounts_page.dart';
import '../../../../core/navigation/navigation_service.dart';
// import '../../../utils/budget_alert_helper.dart'; // Temporarily disabled

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Check if budget setup is needed - temporarily disabled for debugging
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   BudgetAlertHelper.checkAndShowBudgetSetup(context);
    // });
  }

  // Temporary constants until AppColors and AppStrings are available
  static const Color _primaryColor = Color(0xFF2196F3);
  static const Color _textSecondaryColor = Color(0xFF757575);
  static const Color _incomeColor = Color(0xFF4CAF50);
  static const Color _expenseColor = Color(0xFFF44336);
  static const Color _savingsColor = Color(0xFFFF9800);

  // Mock data for demonstration
  final List<Map<String, dynamic>> _mockTransactions = [
    {
      'title': 'Grocery Shopping',
      'description': 'Supermart Store',
      'amount': 250000,
      'isIncome': false,
      'date': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'title': 'Salary',
      'description': 'Monthly Income',
      'amount': 8000000,
      'isIncome': true,
      'date': DateTime.now().subtract(const Duration(days: 3)),
    },
    {
      'title': 'Electric Bill',
      'description': 'PLN Payment',
      'amount': 150000,
      'isIncome': false,
      'date': DateTime.now().subtract(const Duration(days: 5)),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // TODO: Refresh data
            },
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AiChatPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Simulate refresh
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: SingleChildScrollView(
          padding: AppSpacing.allMD,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Summary Cards
              Row(
                children: [
                  Flexible(
                    child: _buildSummaryCard(
                      title: 'Net Amount',
                      amount: 5000000,
                      color: _primaryColor,
                      icon: Icons.account_balance_wallet,
                    ),
                  ),
                  const HGap.md(),
                  Flexible(
                    child: _buildSummaryCard(
                      title: 'Transactions',
                      amount: _mockTransactions.length.toDouble(),
                      color: _textSecondaryColor,
                      icon: Icons.receipt_long,
                      isCount: true,
                    ),
                  ),
                ],
              ),
              const VGap.md(),
              Row(
                children: [
                  Flexible(
                    child: _buildSummaryCard(
                      title: 'Total Income',
                      amount: 8000000,
                      color: _incomeColor,
                      icon: Icons.trending_up,
                    ),
                  ),
                  const HGap.md(),
                  Flexible(
                    child: _buildSummaryCard(
                      title: 'Total Expense',
                      amount: 3000000,
                      color: _expenseColor,
                      icon: Icons.trending_down,
                    ),
                  ),
                ],
              ),
              const VGap.lg(),

              // Recent Transactions Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Transactions',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextButton(
                    onPressed: () {
                      NavigationService.push(const TransactionsPage());
                    },
                    child: const Text('View All'),
                  ),
                ],
              ),
              const VGap.md(),

              // Recent Transactions List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _mockTransactions.length,
                itemBuilder: (context, index) {
                  final transaction = _mockTransactions[index];
                  return _buildTransactionItem(
                    title: transaction['title'],
                    description: transaction['description'],
                    amount: transaction['amount'].toDouble(),
                    isIncome: transaction['isIncome'],
                    date: transaction['date'],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          // Navigate to respective pages
          switch (index) {
            case 0:
              // Already on dashboard
              break;
            case 1:
              NavigationService.push(const TransactionsPage());
              break;
            case 2:
              NavigationService.push(const CategoriesPage());
              break;
            case 3:
              NavigationService.push(const AccountsPage());
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: _primaryColor,
        unselectedItemColor: _textSecondaryColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'Accounts',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showActionMenu,
        backgroundColor: _primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required double amount,
    required Color color,
    required IconData icon,
    bool isCount = false,
  }) {
    return Card(
      elevation: 4,
      child: Container(
        height: 120, // Fixed height for consistency
        padding: AppSpacing.allMD,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.1),
              color.withValues(alpha: 0.05)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(icon, color: color, size: 24),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: _textSecondaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const VGap.xs(),
                Text(
                  isCount ? amount.toInt().toString() : _formatCurrency(amount),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem({
    required String title,
    required String description,
    required double amount,
    required bool isIncome,
    required DateTime date,
  }) {
    return Card(
      margin: AppSpacing.bottomSM,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isIncome ? _incomeColor : _expenseColor,
          child: Icon(
            isIncome ? Icons.arrow_upward : Icons.arrow_downward,
            color: Colors.white,
          ),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(description),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${isIncome ? '+' : '-'}${_formatCurrency(amount)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isIncome ? _incomeColor : _expenseColor,
              ),
            ),
            Text(
              _formatDate(date),
              style: TextStyle(
                color: _textSecondaryColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
        onTap: () {
          NavigationService.push(const TransactionsPage());
        },
      ),
    );
  }

  String _formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match.group(1)}.')}';
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _showActionMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: AppSpacing.allMD,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: AppSpacing.bottomMD,
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: _primaryColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const HGap.md(),
                  const Text(
                    'Pilih Aksi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Action items
            _buildActionItem(
              icon: Icons.chat_bubble,
              title: 'Chat dengan FinAI',
              subtitle: 'Tambah transaksi dengan natural language',
              color: Colors.blue,
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AiChatPage()),
                );
              },
            ),
            _buildActionItem(
              icon: Icons.add_circle,
              title: 'Tambah Transaksi Manual',
              subtitle: 'Isi form transaksi manual',
              color: Colors.green,
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const AddTransactionPage()),
                );
              },
            ),
            _buildActionItem(
              icon: Icons.account_balance_wallet,
              title: 'Setup Budget Bulanan',
              subtitle: 'Tentukan target pengeluaran bulanan',
              color: Colors.purple,
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const BudgetSetupPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: AppSpacing.allMD,
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.1),
              child: Icon(icon, color: color),
            ),
            const HGap.md(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const VGap.xs(),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
