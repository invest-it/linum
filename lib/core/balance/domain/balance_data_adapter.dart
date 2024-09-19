import 'package:linum/core/balance/domain/models/serial_transaction.dart';
import 'package:linum/core/balance/domain/models/transaction.dart';
import 'package:linum/core/budget/domain/models/changes.dart';

abstract class IBalanceDataAdapter {
  Future<List<SerialTransaction>> getAllSerialTransactions();
  Future<List<SerialTransaction>> getAllSerialTransactionsForMonth(DateTime month);

  Future<void> executeSerialTransactionChanges(List<ModelChange<SerialTransaction>> changes);

  Future<List<Transaction>> getAllTransactions();
  Future<List<Transaction>> getAllTransactionsForMonth(DateTime month);

  Future<void> executeTransactionChanges(List<ModelChange<Transaction>> changes);
}
