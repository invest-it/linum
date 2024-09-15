import 'package:linum/common/interfaces/service_interface.dart';
import 'package:linum/core/balance/domain/models/serial_transaction.dart';
import 'package:linum/core/balance/domain/models/transaction.dart';
import 'package:linum/core/budget/domain/models/changes.dart';

abstract class IBalanceDataRepository with NotifyReady {


  Future<List<Transaction>> getAllTransactions();
  Future<List<SerialTransaction>> getAllSerialTransactions();
  Future<Transaction?> getTransactionById(String id);
  Future<SerialTransaction?> getSerialTransactionById(String id);

  Future<void> createSerialTransaction(SerialTransaction serialTransaction);
  Future<void> updateSerialTransaction(SerialTransaction serialTransaction);
  Future<void> removeSerialTransaction(SerialTransaction serialTransaction);

  Future<void> executeSerialTransactionChanges(List<ModelChange<SerialTransaction>> changes);

  Future<List<SerialTransaction>> getSerialTransactionsForMonth(DateTime month);
  Future<List<Transaction>> getTransactionsForMonth(DateTime month);

  Future<void> createTransaction(Transaction transaction);
  Future<void> updateTransaction(Transaction transaction);
  Future<void> removeTransaction(Transaction transaction);
  Future<void> executeTransactionChanges(List<ModelChange<Transaction>> changes);
}
