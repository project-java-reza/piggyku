import 'package:dio/dio.dart';
import 'package:finai_frontend/app/data/models/response/transaction_response_model.dart';
import 'package:finai_frontend/app/data/services/api_service.dart';
import 'package:finai_frontend/core/constants/app_constants.dart';

class TransactionRemoteDataSource {
  final ApiService _apiService;

  TransactionRemoteDataSource({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Get all transactions with extensive filtering and pagination
  /// GET /api/transactions
  Future<TransactionListResponseModel> getTransactions({
    int? accountId,
    int? categoryId,
    String? type, // income or expense
    String? fromDate, // YYYY-MM-DD
    String? toDate, // YYYY-MM-DD
    String? search, // search in note or counterparty
    double? minAmount,
    double? maxAmount,
    String sortBy = 'date', // date, amount, created_at
    String sortOrder = 'desc', // asc or desc
    int perPage = 15,
    int page = 1,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'sort_by': sortBy,
        'sort_order': sortOrder,
        'per_page': perPage,
        'page': page,
      };

      if (accountId != null) queryParameters['account_id'] = accountId;
      if (categoryId != null) queryParameters['category_id'] = categoryId;
      if (type != null) queryParameters['type'] = type;
      if (fromDate != null) queryParameters['from_date'] = fromDate;
      if (toDate != null) queryParameters['to_date'] = toDate;
      if (search != null && search.isNotEmpty) queryParameters['q'] = search;
      if (minAmount != null) queryParameters['min_amount'] = minAmount;
      if (maxAmount != null) queryParameters['max_amount'] = maxAmount;

      final response = await _apiService.get(
        AppConstants.transactionsEndpoint,
        queryParameters: queryParameters,
      );

      return TransactionListResponseModel.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get transaction details by ID
  /// GET /api/transactions/{id}
  Future<TransactionModel> getTransactionById(int id) async {
    try {
      final response = await _apiService.get(
        AppConstants.transactionDetailsEndpoint(id),
      );

      return TransactionModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Create a new transaction (income or expense)
  /// POST /api/transactions
  Future<TransactionCreateResponseModel> createTransaction({
    required int accountId,
    required int categoryId,
    required String type, // income or expense
    required String date, // YYYY-MM-DD
    required double amount,
    String? note,
    String? counterparty,
  }) async {
    try {
      final data = <String, dynamic>{
        'account_id': accountId,
        'category_id': categoryId,
        'type': type,
        'date': date,
        'amount': amount,
      };

      if (note != null && note.isNotEmpty) data['note'] = note;
      if (counterparty != null && counterparty.isNotEmpty) {
        data['counterparty'] = counterparty;
      }

      final response = await _apiService.post(
        AppConstants.transactionsEndpoint,
        data: data,
      );

      return TransactionCreateResponseModel.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update an existing transaction
  /// PUT /api/transactions/{id}
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
    try {
      final data = <String, dynamic>{};

      if (accountId != null) data['account_id'] = accountId;
      if (categoryId != null) data['category_id'] = categoryId;
      if (type != null) data['type'] = type;
      if (date != null) data['date'] = date;
      if (amount != null) data['amount'] = amount;
      if (note != null) data['note'] = note;
      if (counterparty != null) data['counterparty'] = counterparty;

      final response = await _apiService.put(
        AppConstants.transactionDetailsEndpoint(id),
        data: data,
      );

      return TransactionCreateResponseModel.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete a transaction
  /// DELETE /api/transactions/{id}
  Future<TransactionDeleteResponseModel> deleteTransaction(int id) async {
    try {
      final response = await _apiService.delete(
        AppConstants.transactionDetailsEndpoint(id),
      );

      return TransactionDeleteResponseModel.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Create a transfer between two accounts
  /// POST /api/transactions/transfer
  Future<TransferResponseModel> createTransfer({
    required int fromAccountId,
    required int toAccountId,
    required double amount,
    required String date, // YYYY-MM-DD
    String? note,
  }) async {
    try {
      final data = <String, dynamic>{
        'from_account_id': fromAccountId,
        'to_account_id': toAccountId,
        'amount': amount,
        'date': date,
      };

      if (note != null && note.isNotEmpty) data['note'] = note;

      final response = await _apiService.post(
        AppConstants.transferEndpoint,
        data: data,
      );

      return TransferResponseModel.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get transaction statistics
  /// GET /api/transactions-statistics
  Future<TransactionStatisticsResponseModel> getTransactionStatistics({
    String? fromDate, // YYYY-MM-DD
    String? toDate, // YYYY-MM-DD
    int? accountId,
    int? categoryId,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};

      if (fromDate != null) queryParameters['from_date'] = fromDate;
      if (toDate != null) queryParameters['to_date'] = toDate;
      if (accountId != null) queryParameters['account_id'] = accountId;
      if (categoryId != null) queryParameters['category_id'] = categoryId;

      final response = await _apiService.get(
        AppConstants.transactionStatisticsEndpoint,
        queryParameters: queryParameters,
      );

      return TransactionStatisticsResponseModel.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle DioException and return appropriate error message
  String _handleError(DioException error) {
    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final data = error.response!.data;

      // Handle validation errors
      if (statusCode == 422 && data is Map<String, dynamic>) {
        if (data.containsKey('errors')) {
          final errors = data['errors'] as Map<String, dynamic>;
          final firstError = errors.values.first;
          if (firstError is List && firstError.isNotEmpty) {
            return firstError.first.toString();
          }
        }
        if (data.containsKey('message')) {
          return data['message'].toString();
        }
      }

      // Handle other errors
      if (data is Map<String, dynamic> && data.containsKey('message')) {
        return data['message'].toString();
      }

      return 'Server error: $statusCode';
    }

    // Handle network errors
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Connection timeout. Please check your internet connection.';
    }

    if (error.type == DioExceptionType.connectionError) {
      return 'No internet connection. Please check your network.';
    }

    return 'An unexpected error occurred: ${error.message}';
  }
}
