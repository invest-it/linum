import 'package:linum/core/balance/models/serial_transaction.dart';
import 'package:linum/core/balance/models/transaction.dart';

typedef OnSaveCallback = void Function({
  Transaction? transaction,
  SerialTransaction? serialTransaction,
});
typedef OnDeleteCallback = void Function({
  Transaction? transaction,
  SerialTransaction? serialTransaction,
});