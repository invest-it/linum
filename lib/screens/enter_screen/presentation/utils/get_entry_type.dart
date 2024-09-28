import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/core/balance/domain/models/serial_transaction.dart';
import 'package:linum/core/balance/domain/models/transaction.dart';
import 'package:linum/core/categories/core/domain/types/category_map.dart';

EntryType getEntryType({
  required CategoryMap categories,
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
    final category = categories[transaction.category];
    return category?.entryType ?? EntryType.unknown;
  }
  if (serialTransaction != null) {
    if (serialTransaction.amount.isNegative) {
      return EntryType.expense;
    }

    if (serialTransaction.amount > 0) {
      return EntryType.income;
    }
    final category = categories[serialTransaction.category];
    return category?.entryType ?? EntryType.unknown;
  }
  return EntryType.unknown;
}
