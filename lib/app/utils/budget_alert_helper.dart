import 'package:flutter/material.dart';
import '../data/models/budget_model.dart';
import '../data/repositories/budget_repository.dart';
import '../presentation/pages/budget/budget_setup_page.dart';

class BudgetAlertHelper {
  static const Color _primaryColor = Color(0xFF2196F3);
  static const Color _successColor = Color(0xFF4CAF50);
  static const Color _warningColor = Color(0xFFFF9800);
  static const Color _dangerColor = Color(0xFFF44336);

  static Future<void> showTransactionBudgetAlert({
    required BuildContext context,
    required String transactionTitle,
    required double amount,
    required bool isIncome,
  }) async {
    try {
      final updatedBudget = await BudgetRepository.instance.addTransactionToBudget(amount, isIncome: isIncome);

      if (updatedBudget.hasBudgetSet && context.mounted) {
        _showInteractiveBudgetAlert(
          context: context,
          budget: updatedBudget,
          transactionTitle: transactionTitle,
          transactionAmount: amount,
          isIncome: isIncome,
        );
      }
    } catch (e) {
      if (context.mounted) {
        // Show regular transaction success if budget update fails
        _showRegularTransactionAlert(context, transactionTitle, amount, isIncome);
      }
    }
  }

  static void _showInteractiveBudgetAlert({
    required BuildContext context,
    required BudgetModel budget,
    required String transactionTitle,
    required double transactionAmount,
    required bool isIncome,
  }) {
    final remainingBudget = budget.remainingBudget;
    final percentageUsed = budget.budgetPercentage;
    final isOverBudget = budget.isOverBudget;

    debugPrint('🔍 Budget Alert - Budget: $budget');
    debugPrint('🔍 Budget Alert - Remaining: $remainingBudget');
    debugPrint('🔍 Budget Alert - Percentage: $percentageUsed');
    debugPrint('🔍 Budget Alert - IsOverBudget: $isOverBudget');

    // Generate interactive message based on budget status
    String interactiveMessage;
    Color alertColor;
    IconData alertIcon;

    if (isIncome) {
      interactiveMessage = 'Uang kamu bertambah ${_formatAmount(transactionAmount)}! Budget tetap aman nih 😊';
      alertColor = _successColor;
      alertIcon = Icons.trending_up;
    } else if (isOverBudget) {
      interactiveMessage = 'Oops! Kamu sudah melebihi budget ${_formatAmount(remainingBudget.abs())}. Saatnya hemat! 💸';
      alertColor = _dangerColor;
      alertIcon = Icons.warning;
    } else if (percentageUsed >= 80) {
      interactiveMessage = 'Hati-hati! Uang kamu berkurang ${_formatAmount(transactionAmount)}, batas pengeluaran sisa ${_formatAmount(remainingBudget)} lagi nihh! ⚠️';
      alertColor = _warningColor;
      alertIcon = Icons.priority_high;
    } else if (percentageUsed >= 50) {
      interactiveMessage = 'Uang kamu berkurang ${_formatAmount(transactionAmount)}, batas pengeluaran sisa ${_formatAmount(remainingBudget)} lagi nihh!';
      alertColor = _warningColor;
      alertIcon = Icons.trending_down;
    } else {
      interactiveMessage = 'Uang kamu berkurang ${_formatAmount(transactionAmount)}, batas pengeluaran sisa ${_formatAmount(remainingBudget)} lagii nihh!';
      alertColor = _successColor;
      alertIcon = Icons.trending_down;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: alertColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(alertIcon, color: alertIcon == Icons.trending_up ? _successColor : alertColor, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Transaksi Berhasil Disimpan!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Interactive Message
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: alertColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: alertColor.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isIncome ? Icons.add_circle : Icons.remove_circle,
                            color: isIncome ? _successColor : alertColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              interactiveMessage,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: alertColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Budget Progress Bar
                if (!isIncome) ...[
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Progress Budget',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF757575),
                            ),
                          ),
                          Text(
                            '${percentageUsed.toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isOverBudget ? _dangerColor : alertColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0E0E0),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: (percentageUsed / 100).clamp(0.0, 1.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isOverBudget ? _dangerColor : alertColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 20),

                // Close Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('OK, Mengerti'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void _showRegularTransactionAlert(
    BuildContext context,
    String title,
    double amount,
    bool isIncome,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _successColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.check_circle, color: _successColor, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Transaksi Berhasil Disimpan!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('OK'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  
  static String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}jt';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}rb';
    } else {
      return amount.toStringAsFixed(0);
    }
  }

  
  static Future<bool> checkAndShowBudgetSetup(BuildContext context) async {
    final needsSetup = await BudgetRepository.instance.needsBudgetSetup();
    final isNewMonth = await BudgetRepository.instance.isNewMonth();

    if (needsSetup || isNewMonth) {
      if (context.mounted) {
        _showBudgetSetupPrompt(context, isNewMonth);
        return true;
      }
    }
    return false;
  }

  static void _showBudgetSetupPrompt(BuildContext context, bool isNewMonth) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Row(
            children: [
              Icon(Icons.account_balance_wallet, color: _primaryColor),
              const SizedBox(width: 12),
              Text(isNewMonth ? 'Bulan Baru, Budget Baru!' : 'Setup Budget Bulanan'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isNewMonth
                  ? 'Bulan baru sudah tiba! Yuk tetapkan target pengeluaran bulan ini agar keuangan lebih terkontrol.'
                  : 'Yuk tetapkan target pengeluaran bulanan agar keuangan kamu lebih terkontrol. Alert akan muncul setiap kali transaksi!',
                style: TextStyle(
                  height: 1.4,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Lewati dulu'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const BudgetSetupPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
              ),
              child: Text('Setup Budget'),
            ),
          ],
        );
      },
    );
  }
}