class BudgetModel {
  final String id;
  final double monthlyTarget;
  final double currentSpent;
  final DateTime month;
  final DateTime createdAt;
  final DateTime updatedAt;

  BudgetModel({
    required this.id,
    required this.monthlyTarget,
    required this.currentSpent,
    required this.month,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BudgetModel.createEmpty() {
    final now = DateTime.now();
    return BudgetModel(
      id: 'budget_${now.millisecondsSinceEpoch}',
      monthlyTarget: 0.0,
      currentSpent: 0.0,
      month: DateTime(now.year, now.month, 1),
      createdAt: now,
      updatedAt: now,
    );
  }

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      id: json['id'] ?? '',
      monthlyTarget: (json['monthly_target'] ?? 0.0).toDouble(),
      currentSpent: (json['current_spent'] ?? 0.0).toDouble(),
      month: DateTime.parse(json['month']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'monthly_target': monthlyTarget,
      'current_spent': currentSpent,
      'month': month.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  BudgetModel copyWith({
    String? id,
    double? monthlyTarget,
    double? currentSpent,
    DateTime? month,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      monthlyTarget: monthlyTarget ?? this.monthlyTarget,
      currentSpent: currentSpent ?? this.currentSpent,
      month: month ?? this.month,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  double get remainingBudget => monthlyTarget - currentSpent;
  double get budgetPercentage => monthlyTarget > 0 ? (currentSpent / monthlyTarget) * 100 : 0;
  bool get isOverBudget => currentSpent > monthlyTarget;
  bool get hasBudgetSet => monthlyTarget > 0;

  String formatBudget() {
    if (monthlyTarget >= 1000000) {
      return 'Rp ${(monthlyTarget / 1000000).toStringAsFixed(1)}jt';
    } else if (monthlyTarget >= 1000) {
      return 'Rp ${(monthlyTarget / 1000).toStringAsFixed(0)}rb';
    } else {
      return 'Rp ${monthlyTarget.toStringAsFixed(0)}';
    }
  }

  String formatRemainingBudget() {
    if (remainingBudget >= 1000000) {
      return 'Rp ${(remainingBudget / 1000000).toStringAsFixed(1)}jt';
    } else if (remainingBudget >= 1000) {
      return 'Rp ${(remainingBudget / 1000).toStringAsFixed(0)}rb';
    } else {
      return 'Rp ${remainingBudget.toStringAsFixed(0)}';
    }
  }

  String formatSpent() {
    if (currentSpent >= 1000000) {
      return 'Rp ${(currentSpent / 1000000).toStringAsFixed(1)}jt';
    } else if (currentSpent >= 1000) {
      return 'Rp ${(currentSpent / 1000).toStringAsFixed(0)}rb';
    } else {
      return 'Rp ${currentSpent.toStringAsFixed(0)}';
    }
  }
}