class TransactionAccountModel {
  final int id;
  final String name;
  final String type;

  TransactionAccountModel({
    required this.id,
    required this.name,
    required this.type,
  });

  factory TransactionAccountModel.fromJson(Map<String, dynamic> json) {
    return TransactionAccountModel(
      id: json['id'] as int,
      name: json['name'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
    };
  }
}

class TransactionCategoryModel {
  final int id;
  final String name;
  final String type;

  TransactionCategoryModel({
    required this.id,
    required this.name,
    required this.type,
  });

  factory TransactionCategoryModel.fromJson(Map<String, dynamic> json) {
    return TransactionCategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
    };
  }
}

class TransactionModel {
  final int id;
  final int userId;
  final int accountId;
  final int categoryId;
  final String type;
  final String date;
  final String amount;
  final String? note;
  final String? counterparty;
  final String? transferGroupId;
  final String createdAt;
  final String updatedAt;
  final TransactionAccountModel? account;
  final TransactionCategoryModel? category;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.accountId,
    required this.categoryId,
    required this.type,
    required this.date,
    required this.amount,
    this.note,
    this.counterparty,
    this.transferGroupId,
    required this.createdAt,
    required this.updatedAt,
    this.account,
    this.category,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      accountId: json['account_id'] as int,
      categoryId: json['category_id'] as int,
      type: json['type'] as String,
      date: json['date'] as String,
      amount: json['amount'].toString(),
      note: json['note'] as String?,
      counterparty: json['counterparty'] as String?,
      transferGroupId: json['transfer_group_id'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      account: json['account'] != null
          ? TransactionAccountModel.fromJson(
              json['account'] as Map<String, dynamic>)
          : null,
      category: json['category'] != null
          ? TransactionCategoryModel.fromJson(
              json['category'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'account_id': accountId,
      'category_id': categoryId,
      'type': type,
      'date': date,
      'amount': amount,
      'note': note,
      'counterparty': counterparty,
      'transfer_group_id': transferGroupId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'account': account?.toJson(),
      'category': category?.toJson(),
    };
  }
}

class TransactionPaginationModel {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final int from;
  final int to;

  TransactionPaginationModel({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.from,
    required this.to,
  });

  factory TransactionPaginationModel.fromJson(Map<String, dynamic> json) {
    return TransactionPaginationModel(
      currentPage: json['current_page'] as int,
      lastPage: json['last_page'] as int,
      perPage: json['per_page'] as int,
      total: json['total'] as int,
      from: json['from'] as int,
      to: json['to'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'last_page': lastPage,
      'per_page': perPage,
      'total': total,
      'from': from,
      'to': to,
    };
  }
}

class TransactionListResponseModel {
  final String message;
  final List<TransactionModel> data;
  final TransactionPaginationModel pagination;

  TransactionListResponseModel({
    required this.message,
    required this.data,
    required this.pagination,
  });

  factory TransactionListResponseModel.fromJson(Map<String, dynamic> json) {
    return TransactionListResponseModel(
      message: json['message'] as String,
      data: (json['data'] as List)
          .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: TransactionPaginationModel.fromJson(
          json['pagination'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

class TransactionCreateResponseModel {
  final String message;
  final TransactionModel data;

  TransactionCreateResponseModel({
    required this.message,
    required this.data,
  });

  factory TransactionCreateResponseModel.fromJson(Map<String, dynamic> json) {
    return TransactionCreateResponseModel(
      message: json['message'] as String,
      data: TransactionModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.toJson(),
    };
  }
}

class TransactionDeleteResponseModel {
  final String message;

  TransactionDeleteResponseModel({
    required this.message,
  });

  factory TransactionDeleteResponseModel.fromJson(Map<String, dynamic> json) {
    return TransactionDeleteResponseModel(
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}

class TransferResponseDataModel {
  final String transferGroupId;
  final TransactionModel fromTransaction;
  final TransactionModel toTransaction;

  TransferResponseDataModel({
    required this.transferGroupId,
    required this.fromTransaction,
    required this.toTransaction,
  });

  factory TransferResponseDataModel.fromJson(Map<String, dynamic> json) {
    return TransferResponseDataModel(
      transferGroupId: json['transfer_group_id'] as String,
      fromTransaction: TransactionModel.fromJson(
          json['from_transaction'] as Map<String, dynamic>),
      toTransaction: TransactionModel.fromJson(
          json['to_transaction'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transfer_group_id': transferGroupId,
      'from_transaction': fromTransaction.toJson(),
      'to_transaction': toTransaction.toJson(),
    };
  }
}

class TransferResponseModel {
  final String message;
  final TransferResponseDataModel data;

  TransferResponseModel({
    required this.message,
    required this.data,
  });

  factory TransferResponseModel.fromJson(Map<String, dynamic> json) {
    return TransferResponseModel(
      message: json['message'] as String,
      data: TransferResponseDataModel.fromJson(
          json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.toJson(),
    };
  }
}

class TransactionStatisticsDataModel {
  final String totalIncome;
  final String totalExpense;
  final int transactionCount;
  final int incomeCount;
  final int expenseCount;
  final String netAmount;

  TransactionStatisticsDataModel({
    required this.totalIncome,
    required this.totalExpense,
    required this.transactionCount,
    required this.incomeCount,
    required this.expenseCount,
    required this.netAmount,
  });

  factory TransactionStatisticsDataModel.fromJson(Map<String, dynamic> json) {
    return TransactionStatisticsDataModel(
      totalIncome: json['total_income'].toString(),
      totalExpense: json['total_expense'].toString(),
      transactionCount: json['transaction_count'] as int,
      incomeCount: json['income_count'] as int,
      expenseCount: json['expense_count'] as int,
      netAmount: json['net_amount'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_income': totalIncome,
      'total_expense': totalExpense,
      'transaction_count': transactionCount,
      'income_count': incomeCount,
      'expense_count': expenseCount,
      'net_amount': netAmount,
    };
  }
}

class TransactionStatisticsResponseModel {
  final String message;
  final TransactionStatisticsDataModel data;

  TransactionStatisticsResponseModel({
    required this.message,
    required this.data,
  });

  factory TransactionStatisticsResponseModel.fromJson(
      Map<String, dynamic> json) {
    return TransactionStatisticsResponseModel(
      message: json['message'] as String,
      data: TransactionStatisticsDataModel.fromJson(
          json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.toJson(),
    };
  }
}
