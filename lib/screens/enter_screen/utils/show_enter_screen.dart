import 'package:flutter/material.dart';
import 'package:linum/core/balance/models/serial_transaction.dart';
import 'package:linum/core/balance/models/transaction.dart';
import 'package:linum/screens/enter_screen/enter_screen.dart';

void showEnterScreen(
  BuildContext context, {
    Transaction? transaction,
    SerialTransaction? serialTransaction,
}) {
  final enterScreen = EnterScreen(
      transaction: transaction,
      serialTransaction: serialTransaction
  );
  
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return enterScreen;
    },
  );
}
