import 'package:linum/core/balance/enums/serial_transaction_change_type_enum.dart';
import 'package:linum/core/balance/models/serial_transaction.dart';
import 'package:linum/core/balance/models/transaction.dart';

typedef OnSaveCallback = void Function({
  Transaction? transaction,
  SerialTransaction? serialTransaction,
  SerialTransactionChangeMode? changeMode,
});
typedef OnDeleteCallback = void Function({
  Transaction? transaction,
  SerialTransaction? serialTransaction,
  SerialTransactionChangeMode? changeMode,
});
