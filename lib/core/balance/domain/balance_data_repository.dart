import 'dart:async';

import 'package:linum/common/interfaces/service_interface.dart';
import 'package:linum/core/balance/domain/models/serial_transaction.dart';
import 'package:linum/core/balance/domain/models/transaction.dart';
import 'package:linum/core/budget/domain/models/changes.dart';

abstract class IBalanceDataRepository with NotifyReady {
  FutureOr<List<Transaction>> getAllTransactions();
  FutureOr<List<SerialTransaction>> getAllSerialTransactions();
  FutureOr<Transaction?> getTransactionById(String id);
  FutureOr<SerialTransaction?> getSerialTransactionById(String id);

  FutureOr<void> createSerialTransaction(SerialTransaction serialTransaction);
  FutureOr<void> updateSerialTransaction(SerialTransaction serialTransaction);
  FutureOr<void> removeSerialTransaction(SerialTransaction serialTransaction);

  FutureOr<void> executeSerialTransactionChanges(List<ModelChange<SerialTransaction>> changes);

  FutureOr<List<SerialTransaction>> getSerialTransactionsForMonth(DateTime month);
  FutureOr<List<Transaction>> getTransactionsForMonth(DateTime month);

  FutureOr<void> createTransaction(Transaction transaction);
  FutureOr<void> updateTransaction(Transaction transaction);
  FutureOr<void> removeTransaction(Transaction transaction);
  FutureOr<void> executeTransactionChanges(List<ModelChange<Transaction>> changes);
}
