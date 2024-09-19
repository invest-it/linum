import 'package:linum/common/interfaces/service_interface.dart';
import 'package:linum/core/balance/domain/enums/serial_transaction_change_type_enum.dart';
import 'package:linum/core/balance/domain/models/serial_transaction.dart';
import 'package:linum/core/balance/domain/models/transaction.dart';

abstract class IBalanceDataService extends IProvidableService with NotifyReady {
  Future<List<SerialTransaction>> getSerialTransactionsForMonth(DateTime month);
  Future<List<Transaction>> getTransactionsForMonth(DateTime month);

  Future<List<Transaction>> getAllTransactions();
  Future<List<SerialTransaction>> getAllSerialTransactions();

  Future<SerialTransaction?> getSerialTransactionById(String id);


  Future<void> addSerialTransaction(SerialTransaction serialTransaction);

  Future<void> updateSerialTransaction({
    required SerialTransaction update,
    required SerialTransactionChangeMode changeMode,
    DateTime? oldDate,
    DateTime? newDate,
    bool resetEndDate = false,
  });

  Future<void> removeSerialTransactionWithId({
    required String id,
    required SerialTransactionChangeMode removeType,
    DateTime? date,
  });

  Future<void> removeSerialTransaction({
    required SerialTransaction serialTransaction,
    required SerialTransactionChangeMode removeType,
    DateTime? date,
  });

  Future<void> addTransaction(Transaction transaction);
  Future<void> updateTransaction(Transaction update);
  Future<void> removeTransactionWithId(String id);
  Future<void> removeTransaction(Transaction transaction);
}

class BalanceStatistics {
  final num totalIncome;
  final num totalExpenses;

  BalanceStatistics({required this.totalIncome, required this.totalExpenses});
}
