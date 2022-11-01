


import 'package:linum/models/serial_transaction.dart';
import 'package:linum/models/transaction.dart';

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
    final rawBalanceData = map['balanceData'] as List<dynamic>;
    final balanceData = rawBalanceData.map((data) => Transaction.fromMap(data as Map<String, dynamic>)).toList();
    final rawRepeatedBalance = map['repeatedBalance'] as List<dynamic>;
    final repeatedBalance = rawRepeatedBalance.map((data) => SerialTransaction.fromMap(data as Map<String, dynamic>)).toList();
    return BalanceDocument(
      transactions: balanceData,
      serialTransactions: repeatedBalance,
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
