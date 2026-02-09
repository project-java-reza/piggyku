import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../data/models/budget_model.dart';

class BudgetRepository {
  static BudgetRepository? _instance;
  static BudgetRepository get instance {
    _instance ??= BudgetRepository._();
    return _instance!;
  }

  BudgetRepository._();

  BudgetModel? _currentBudget;
  final List<BudgetModel> _allBudgets = [];

  // Mock storage - replace with actual database later
  BudgetModel? getCurrentBudget() {
    if (_currentBudget == null) {
      final now = DateTime.now();
      final currentMonth = DateTime(now.year, now.month, 1);

      _currentBudget = BudgetModel.createEmpty();
    }
    return _currentBudget;
  }

  Future<BudgetModel> setMonthlyBudget(double target) async {
    debugPrint('🔍 BudgetRepository.setMonthlyBudget - Target: $target (${target.runtimeType})');

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month, 1);

    _currentBudget = BudgetModel(
      id: 'budget_${now.millisecondsSinceEpoch}',
      monthlyTarget: target,
      currentSpent: 0.0, // Reset spent amount when setting new budget
      month: currentMonth,
      createdAt: now,
      updatedAt: now,
    );

    debugPrint('🔍 BudgetRepository.setMonthlyBudget - Created budget with target: ${_currentBudget!.monthlyTarget} (${_currentBudget!.monthlyTarget.runtimeType})');
    _allBudgets.add(_currentBudget!);

    return _currentBudget!;
  }

  Future<BudgetModel> addTransactionToBudget(double amount, {bool isIncome = false}) async {
    await Future.delayed(const Duration(milliseconds: 100));

    final budget = getCurrentBudget();
    if (budget != null && budget.hasBudgetSet) {
      // Only subtract expenses, not income
      double newSpent = budget.currentSpent;
      if (!isIncome) {
        newSpent += amount;
      }

      _currentBudget = budget.copyWith(
        currentSpent: newSpent,
        updatedAt: DateTime.now(),
      );

      return _currentBudget!;
    }

    return budget ?? BudgetModel.createEmpty();
  }

  Future<bool> needsBudgetSetup() async {
    final budget = getCurrentBudget();
    return budget?.monthlyTarget == 0.0;
  }

  Future<bool> isNewMonth() async {
    final budget = getCurrentBudget();
    if (budget == null) return true;

    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month, 1);

    return budget.month.isBefore(currentMonth);
  }

  Future<List<BudgetModel>> getAllBudgets() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_allBudgets);
  }

  void clearCache() {
    _currentBudget = null;
    _allBudgets.clear();
  }
}