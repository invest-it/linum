import 'package:flutter/material.dart';
import 'package:linum/core/balance/domain/models/serial_transaction.dart';
import 'package:linum/core/balance/domain/models/transaction.dart';
import 'package:linum/core/navigation/get_delegate.dart';
import 'package:linum/screens/enter_screen/enter_screen.dart';

void showEnterScreen(
  BuildContext context, {
    Transaction? transaction,
    SerialTransaction? serialTransaction,
}) {
  final enterScreen = EnterScreen(
      transaction: transaction,
      serialTransaction: serialTransaction,
  );
  

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      context.getMainRouterDelegate().setOnPopOverwrite(() { Navigator.pop(context); });
      // Widget ist created outside of the builder to keep the Screens State
      return enterScreen;
    },
  ).whenComplete(() => context.getMainRouterDelegate().removeOnPopOverwrite());
}
