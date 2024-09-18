import 'package:jiffy/jiffy.dart';
import 'package:linum/common/interfaces/time_span.dart';
import 'package:linum/core/balance/domain/balance_data_adapter.dart';
import 'package:linum/core/balance/domain/models/serial_transaction.dart';
import 'package:linum/core/balance/domain/models/transaction.dart';
import 'package:linum/core/balance/ports/firebase/balance_document.dart';
import 'package:linum/core/budget/domain/models/changes.dart';

class FirebaseTestBalanceAdapter implements IBalanceDataAdapter {
  final BalanceDocument doc;
  FirebaseTestBalanceAdapter({required this.doc});

  @override
  Future<void> executeSerialTransactionChanges(List<ModelChange<SerialTransaction>> changes) async {
    final data = doc;
    for (final change in changes) {
      switch (change.type) {
        case ChangeType.create:
          data.serialTransactions.add(change.model);
        case ChangeType.update:
          final index = data.serialTransactions.indexWhere((s) => s.id == change.model.id);
          if (index < 0) {
            data.serialTransactions.add(change.model);
            break;
          }
          data.serialTransactions[index] = change.model;
        case ChangeType.delete:
          data.serialTransactions.removeWhere((s) => s.id == change.model.id);
      }
    }
  }

  @override
  Future<void> executeTransactionChanges(List<ModelChange<Transaction>> changes) async {
    final data = doc;
    for (final change in changes) {
      switch (change.type) {
        case ChangeType.create:
          data.transactions.add(change.model);
        case ChangeType.update:
          final index = data.transactions.indexWhere((s) => s.id == change.model.id);
          if (index < 0) {
            data.transactions.add(change.model);
            break;
          }
          data.transactions[index] = change.model;
        case ChangeType.delete:
          data.transactions.removeWhere((s) => s.id == change.model.id);
      }
    }
  }

  @override
  Future<List<SerialTransaction>> getAllSerialTransactions() async {
    final data = doc;
    if (data == null) {
      return [];
    }
    return data.serialTransactions;
  }

  @override
  Future<List<SerialTransaction>> getAllSerialTransactionsForMonth(DateTime month) async {
    final data = doc;

    if (data == null) {
      return [];
    }
    return data.serialTransactions
        .where((s) => s.containsDate(month))
        .toList();
  }

  @override
  Future<List<Transaction>> getAllTransactions() async {
    final data = doc;
    if (data == null) {
      return [];
    }
    return data.transactions;
  }

  @override
  Future<List<Transaction>> getAllTransactionsForMonth(DateTime month) async {
    final data = doc;
    if (data == null) {
      return [];
    }
    final yMMM = Jiffy.parseFromDateTime(month).yMMM;
    return data.transactions
        .where((t) => Jiffy.parseFromDateTime(t.date).yMMM == yMMM)
        .toList();
  }
}