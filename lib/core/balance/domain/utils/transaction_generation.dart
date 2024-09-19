import 'package:linum/core/balance/domain/models/serial_transaction.dart';
import 'package:linum/core/balance/domain/models/transaction.dart';


List<Transaction> generateTransactions(List<SerialTransaction> serialTransactions, DateTime till) {
  final List<Transaction> transactions = [];

  for (final serialTransaction in serialTransactions) {
    transactions.addAll(serialTransaction.generateTransactions(till));
  }

  return transactions;
}
