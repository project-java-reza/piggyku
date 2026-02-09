import 'package:equatable/equatable.dart';
import '../../../data/models/response/transaction_response_model.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

class TransactionInitial extends TransactionState {
  const TransactionInitial();
}

class TransactionLoading extends TransactionState {
  const TransactionLoading();
}

class TransactionLoaded extends TransactionState {
  final List<TransactionModel> transactions;
  final TransactionPaginationModel pagination;

  const TransactionLoaded({
    required this.transactions,
    required this.pagination,
  });

  @override
  List<Object?> get props => [transactions, pagination];
}

class TransactionDetailLoaded extends TransactionState {
  final TransactionModel transaction;

  const TransactionDetailLoaded({required this.transaction});

  @override
  List<Object?> get props => [transaction];
}

class TransactionStatisticsLoaded extends TransactionState {
  final TransactionStatisticsDataModel statistics;

  const TransactionStatisticsLoaded({required this.statistics});

  @override
  List<Object?> get props => [statistics];
}

class TransactionOperationSuccess extends TransactionState {
  final String message;

  const TransactionOperationSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class TransactionError extends TransactionState {
  final String message;

  const TransactionError({required this.message});

  @override
  List<Object?> get props => [message];
}