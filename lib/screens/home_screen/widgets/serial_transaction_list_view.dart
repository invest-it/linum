import 'package:flutter/material.dart';
import 'package:linum/core/balance/domain/models/serial_transaction.dart';
import 'package:linum/screens/home_screen/widgets/serial_transaction_tile.dart';
import 'package:linum/screens/home_screen/widgets/time_widget.dart';

class SerialTransactionListView extends StatelessWidget {
  final List<SerialTransaction> serialTransactions;

  const SerialTransactionListView({
    super.key,
    required this.serialTransactions,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> list = [];
    if (serialTransactions.isEmpty) {
      list.add(const TimeWidget(label: "listview.label-no-entries"));
    } else {
      bool wroteExpensesTag = false;
      bool wroteIncomeTag = false;

      for (final serTrans in serialTransactions) {
        if (!wroteExpensesTag && serTrans.amount <= 0) {
          list.add(
            const TimeWidget(label: "home_screen_card.label-expenses"),
          );
          wroteExpensesTag = true;
        }
        if (!wroteIncomeTag && serTrans.amount > 0) {
          list.add(
            const TimeWidget(label: "home_screen_card.label-income"),
          );
          wroteIncomeTag = true;
        }
        list.add(
          SerialTransactionTile(serialTransaction: serTrans),
        );
      }
    }

    return ListView(
      padding: const EdgeInsets.only(
        bottom: 32.0,
      ),
      children: list,
    );
  }
}
