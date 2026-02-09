import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/repositories/budget_repository.dart';
import '../../../data/models/budget_model.dart';

class BudgetSetupPage extends StatefulWidget {
  const BudgetSetupPage({super.key});

  @override
  State<BudgetSetupPage> createState() => _BudgetSetupPageState();
}

class _BudgetSetupPageState extends State<BudgetSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  bool _isLoading = false;

  // Color constants
  static const Color _primaryColor = Color(0xFF2196F3);
  static const Color _successColor = Color(0xFF4CAF50);
  static const Color _warningColor = Color(0xFFFF9800);
  static const Color _dangerColor = Color(0xFFF44336);

  final List<Map<String, dynamic>> _budgetSuggestions = [
    {'amount': 1000000, 'label': '1 juta', 'description': 'Budget hemat'},
    {'amount': 2000000, 'label': '2 juta', 'description': 'Budget standar'},
    {'amount': 3000000, 'label': '3 juta', 'description': 'Budget nyaman'},
    {'amount': 5000000, 'label': '5 juta', 'description': 'Budget fleksibel'},
    {'amount': 10000000, 'label': '10 juta', 'description': 'Budget premium'},
  ];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  String _formatAmount(dynamic input) {
    if (input is String) {
      // Jika input adalah string (dari form field), parse dulu
      final cleanValue = input.replaceAll(RegExp(r'[^\d]'), '');
      if (cleanValue.isEmpty) return '';
      final doubleValue = double.parse(cleanValue);

      if (doubleValue >= 1000000) {
        return '${(doubleValue / 1000000).toStringAsFixed(1)}jt';
      } else if (doubleValue >= 1000) {
        return '${(doubleValue / 1000).toStringAsFixed(0)}rb';
      } else {
        return doubleValue.toStringAsFixed(0);
      }
    } else {
      // Jika input adalah number (dari suggestion)
      final doubleValue = (input is int) ? input.toDouble() : (input as double);
      if (doubleValue >= 1000000) {
        return '${(doubleValue / 1000000).toStringAsFixed(1)}jt';
      } else if (doubleValue >= 1000) {
        return '${(doubleValue / 1000).toStringAsFixed(0)}rb';
      } else {
        return doubleValue.toStringAsFixed(0);
      }
    }
  }

  void _setSuggestedBudget(dynamic amount) {
    final doubleValue = (amount is int) ? amount.toDouble() : (amount as double);
    _amountController.text = doubleValue.toStringAsFixed(0);
  }

  Future<void> _saveBudget() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final inputText = _amountController.text.trim();
      debugPrint('🔍 Budget Setup - Input text: "$inputText"');

      if (inputText.isEmpty) {
        throw Exception('Jumlah tidak boleh kosong');
      }

      // Hapus semua non-digit (termasuk titik dan koma) untuk parsing yang konsisten
      final cleanValue = inputText.replaceAll(RegExp(r'[^\d]'), '');
      debugPrint('🔍 Budget Setup - Clean value: "$cleanValue"');

      if (cleanValue.isEmpty) {
        throw Exception('Format jumlah tidak valid');
      }

      final amount = double.parse(cleanValue);
      debugPrint('🔍 Budget Setup - Converted to double: $amount (${amount.runtimeType})');

      final budget = await BudgetRepository.instance.setMonthlyBudget(amount);

      if (mounted) {
        // Show success alert
        _showBudgetSetSuccessAlert(budget);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan budget: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showBudgetSetSuccessAlert(BudgetModel budget) {
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
                        color: _successColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.check_circle, color: _successColor, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Budget Berhasil Ditetapkan!',
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

                // Info Message
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: _primaryColor, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Sekarang kamu bisa tracking pengeluaran bulan ini. Alert akan muncul setiap kali transaksi!',
                          style: TextStyle(
                            color: _primaryColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

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
                    child: const Text('Mengerti'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Budget Bulanan'),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Card(
                elevation: 4,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [_primaryColor.withOpacity(0.1), _primaryColor.withOpacity(0.05)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.account_balance_wallet, color: _primaryColor, size: 28),
                          const SizedBox(width: 12),
                          const Text(
                            'Tentukan Target Pengeluaran',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Setiap awal bulan, tetapkan target pengeluaran agar keuangan kamu lebih terkontrol. Alert akan muncul setiap kali transaksi!',
                        style: TextStyle(
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Budget Input
              Text(
                'Masukkan Target Budget',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  labelText: 'Target Pengeluaran Bulanan',
                  hintText: 'Contoh: 2000000',
                  prefixIcon: Icon(Icons.wallet, color: _primaryColor),
                  prefixText: 'Rp ',
                  suffixText: _amountController.text.trim().isNotEmpty
                    ? _formatAmount(_amountController.text.trim())
                    : '',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: _primaryColor, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Target budget harus diisi';
                  }

                  // Hapus semua non-digit (termasuk titik dan koma)
                  String cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');

                  debugPrint('🔍 Validator - Input: "$value", Clean value: "$cleanValue"');

                  if (cleanValue.isNotEmpty) {
                    // Parse sebagai double untuk handle trailing zeros
                    final amount = double.tryParse(cleanValue);
                    debugPrint('🔍 Validator - Parsed amount: $amount');

                    if (amount == null || amount <= 0) {
                      return 'Masukkan jumlah yang valid';
                    }
                    if (amount < 100000) {
                      return 'Minimal budget Rp 100.000';
                    }
                  } else {
                    return 'Masukkan jumlah yang valid';
                  }

                  return null;
                },
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 24),

              // Quick Suggestions
              Text(
                'Pilih Cepat',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _budgetSuggestions.map((suggestion) {
                  return GestureDetector(
                    onTap: () => _setSuggestedBudget(suggestion['amount']),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: _primaryColor.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(25),
                        color: _primaryColor.withOpacity(0.05),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            suggestion['label'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _primaryColor,
                            ),
                          ),
                          Text(
                            suggestion['description'],
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveBudget,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Simpan Budget',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                ),
              ),

              const SizedBox(height: 16),

              // Skip for now
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Lewati dulu',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}