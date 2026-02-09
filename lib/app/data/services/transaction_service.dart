import 'package:finai_frontend/app/data/data_sources/transaction_remote_datasource.dart';
import 'package:finai_frontend/app/data/models/response/transaction_response_model.dart';

class TransactionService {
  final TransactionRemoteDataSource _remoteDataSource;

  TransactionService({TransactionRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? TransactionRemoteDataSource();

  /// Get all transactions with extensive filtering and pagination
  Future<TransactionListResponseModel> getTransactions({
    int? accountId,
    int? categoryId,
    String? type,
    String? fromDate,
    String? toDate,
    String? search,
    double? minAmount,
    double? maxAmount,
    String sortBy = 'date',
    String sortOrder = 'desc',
    int perPage = 15,
    int page = 1,
  }) async {
    return await _remoteDataSource.getTransactions(
      accountId: accountId,
      categoryId: categoryId,
      type: type,
      fromDate: fromDate,
      toDate: toDate,
      search: search,
      minAmount: minAmount,
      maxAmount: maxAmount,
      sortBy: sortBy,
      sortOrder: sortOrder,
      perPage: perPage,
      page: page,
    );
  }

  /// Get transaction details by ID
  Future<TransactionModel> getTransactionById(int id) async {
    return await _remoteDataSource.getTransactionById(id);
  }

  /// Create a new transaction (income or expense)
  Future<TransactionCreateResponseModel> createTransaction({
    required int accountId,
    required int categoryId,
    required String type,
    required String date,
    required double amount,
    String? note,
    String? counterparty,
  }) async {
    return await _remoteDataSource.createTransaction(
      accountId: accountId,
      categoryId: categoryId,
      type: type,
      date: date,
      amount: amount,
      note: note,
      counterparty: counterparty,
    );
  }

  /// Update an existing transaction
  Future<TransactionCreateResponseModel> updateTransaction({
    required int id,
    int? accountId,
    int? categoryId,
    String? type,
    String? date,
    double? amount,
    String? note,
    String? counterparty,
  }) async {
    return await _remoteDataSource.updateTransaction(
      id: id,
      accountId: accountId,
      categoryId: categoryId,
      type: type,
      date: date,
      amount: amount,
      note: note,
      counterparty: counterparty,
    );
  }

  /// Delete a transaction
  Future<TransactionDeleteResponseModel> deleteTransaction(int id) async {
    return await _remoteDataSource.deleteTransaction(id);
  }

  /// Create a transfer between two accounts
  Future<TransferResponseModel> createTransfer({
    required int fromAccountId,
    required int toAccountId,
    required double amount,
    required String date,
    String? note,
  }) async {
    return await _remoteDataSource.createTransfer(
      fromAccountId: fromAccountId,
      toAccountId: toAccountId,
      amount: amount,
      date: date,
      note: note,
    );
  }

  /// Get transaction statistics
  Future<TransactionStatisticsResponseModel> getTransactionStatistics({
    String? fromDate,
    String? toDate,
    int? accountId,
    int? categoryId,
  }) async {
    return await _remoteDataSource.getTransactionStatistics(
      fromDate: fromDate,
      toDate: toDate,
      accountId: accountId,
      categoryId: categoryId,
    );
  }
}
