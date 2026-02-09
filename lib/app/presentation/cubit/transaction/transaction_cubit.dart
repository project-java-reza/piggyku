import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/services/transaction_service.dart';
import 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final TransactionService _transactionService;

  TransactionCubit({TransactionService? transactionService})
      : _transactionService = transactionService ?? TransactionService(),
        super(const TransactionInitial());

  // Load all transactions
  Future<void> loadTransactions({
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
    emit(const TransactionLoading());

    try {
      final response = await _transactionService.getTransactions(
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

      emit(TransactionLoaded(
        transactions: response.data,
        pagination: response.pagination,
      ));
    } catch (e) {
      emit(TransactionError(message: e.toString()));
    }
  }

  // Load transaction by ID
  Future<void> loadTransactionById(int id) async {
    emit(const TransactionLoading());

    try {
      final transaction = await _transactionService.getTransactionById(id);

      emit(TransactionDetailLoaded(transaction: transaction));
    } catch (e) {
      emit(TransactionError(message: e.toString()));
    }
  }

  // Create new transaction
  Future<void> createTransaction({
    required int accountId,
    required int categoryId,
    required String type,
    required String date,
    required double amount,
    String? note,
    String? counterparty,
  }) async {
    emit(const TransactionLoading());

    try {
      final response = await _transactionService.createTransaction(
        accountId: accountId,
        categoryId: categoryId,
        type: type,
        date: date,
        amount: amount,
        note: note,
        counterparty: counterparty,
      );

      emit(TransactionOperationSuccess(message: response.message));

      // Reload transactions after creation
      await loadTransactions();
    } catch (e) {
      emit(TransactionError(message: e.toString()));
    }
  }

  // Update existing transaction
  Future<void> updateTransaction({
    required int id,
    int? accountId,
    int? categoryId,
    String? type,
    String? date,
    double? amount,
    String? note,
    String? counterparty,
  }) async {
    emit(const TransactionLoading());

    try {
      final response = await _transactionService.updateTransaction(
        id: id,
        accountId: accountId,
        categoryId: categoryId,
        type: type,
        date: date,
        amount: amount,
        note: note,
        counterparty: counterparty,
      );

      emit(TransactionOperationSuccess(message: response.message));

      // Reload transactions after update
      await loadTransactions();
    } catch (e) {
      emit(TransactionError(message: e.toString()));
    }
  }

  // Delete transaction
  Future<void> deleteTransaction(int id) async {
    emit(const TransactionLoading());

    try {
      final response = await _transactionService.deleteTransaction(id);

      emit(TransactionOperationSuccess(message: response.message));

      // Reload transactions after deletion
      await loadTransactions();
    } catch (e) {
      emit(TransactionError(message: e.toString()));
    }
  }

  // Create transfer transaction
  Future<void> createTransfer({
    required int fromAccountId,
    required int toAccountId,
    required double amount,
    required String date,
    String? note,
  }) async {
    emit(const TransactionLoading());

    try {
      final response = await _transactionService.createTransfer(
        fromAccountId: fromAccountId,
        toAccountId: toAccountId,
        amount: amount,
        date: date,
        note: note,
      );

      emit(TransactionOperationSuccess(message: response.message));

      // Reload transactions after transfer creation
      await loadTransactions();
    } catch (e) {
      emit(TransactionError(message: e.toString()));
    }
  }

  // Load transaction statistics
  Future<void> loadTransactionStatistics({
    String? fromDate,
    String? toDate,
    int? accountId,
    int? categoryId,
  }) async {
    emit(const TransactionLoading());

    try {
      final response = await _transactionService.getTransactionStatistics(
        fromDate: fromDate,
        toDate: toDate,
        accountId: accountId,
        categoryId: categoryId,
      );

      emit(TransactionStatisticsLoaded(statistics: response.data));
    } catch (e) {
      emit(TransactionError(message: e.toString()));
    }
  }

  // Refresh transactions
  Future<void> refreshTransactions() async {
    try {
      final response = await _transactionService.getTransactions();

      emit(TransactionLoaded(
        transactions: response.data,
        pagination: response.pagination,
      ));
    } catch (e) {
      emit(TransactionError(message: e.toString()));
    }
  }

  // Helper method to load all transactions with default parameters
  Future<void> loadAllTransactions() async {
    await loadTransactions();
  }
}