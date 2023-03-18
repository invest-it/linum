


import 'package:linum/core/balance/models/serial_transaction.dart';
import 'package:linum/core/balance/models/transaction.dart';

class BalanceDocument {
  final List<Transaction> transactions;
  final List<SerialTransaction> serialTransactions;
  Map<String, dynamic> settings;

  BalanceDocument({
    List<Transaction>? transactions,
    List<SerialTransaction>? serialTransactions,
    Map<String, dynamic>? settings,
  }) :
    transactions = transactions ?? <Transaction>[],
    serialTransactions = serialTransactions ?? <SerialTransaction>[],
    settings = settings ?? <String, dynamic>{};


  factory BalanceDocument.fromMap(Map<String, dynamic> map) {
    final rawTransactions = map['balanceData'] as List<dynamic>;
    final transactions = rawTransactions.map((data) => Transaction.fromMap(data as Map<String, dynamic>)).toList();
    final rawSerialTransactions = map['repeatedBalance'] as List<dynamic>;
    final serialTransactions = rawSerialTransactions.map((data) => SerialTransaction.fromMap(data as Map<String, dynamic>)).toList();
    return BalanceDocument(
      transactions: transactions,
      serialTransactions: serialTransactions,
      settings: map['settings'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'balanceData': transactions.map((e) => e.toMap()).toList(),
      'repeatedBalance': serialTransactions.map((e) => e.toMap()).toList(),
      'settings': settings,
    };
  }
}
