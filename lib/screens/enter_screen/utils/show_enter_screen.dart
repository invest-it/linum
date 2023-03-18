import 'package:flutter/material.dart';
import 'package:linum/core/balance/models/serial_transaction.dart';
import 'package:linum/core/balance/models/transaction.dart';
import 'package:linum/screens/enter_screen/enter_screen.dart';

void showEnterScreen(
  BuildContext context, {
    Transaction? transaction,
    SerialTransaction? serialTransaction,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return EnterScreen(
        transaction: transaction,
        serialTransaction: serialTransaction,
      );
    },
  );
}