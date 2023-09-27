import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/core/balance/models/serial_transaction.dart';
import 'package:linum/core/balance/models/transaction.dart';
import 'package:linum/core/categories/core/constants/standard_categories.dart';

EntryType getEntryType({
  Transaction? transaction,
  SerialTransaction? serialTransaction,
}) {
  if (transaction != null) {
    if (transaction.amount.isNegative) {
      return EntryType.expense;
    }
    if (transaction.amount > 0) {
      return EntryType.income;
    }
    final category = standardCategories[transaction.category];
    return category?.entryType ?? EntryType.unknown;
  }
  if (serialTransaction != null) {
    if (serialTransaction.amount.isNegative) {
      return EntryType.expense;
    }

    if (serialTransaction.amount > 0) {
      return EntryType.income;
    }
    final category = standardCategories[serialTransaction.category];
    return category?.entryType ?? EntryType.unknown;
  }
  return EntryType.unknown;
}
