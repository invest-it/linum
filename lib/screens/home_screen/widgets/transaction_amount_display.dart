import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/balance/domain/models/transaction.dart';
import 'package:linum/core/balance/presentation/transaction_amount_formatter.dart';
import 'package:linum/generated/translation_keys.g.dart';




class TransactionAmountDisplay extends StatelessWidget {
  final Transaction transaction;
  final TransactionAmountFormatter formatter;
  const TransactionAmountDisplay({
    super.key,
    required this.transaction,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    return transaction.amount == 0
        ? Text(
            tr(translationKeys.homeScreen.freeText),
            style: Theme.of(context).textTheme.bodyLarge,
          )
        : buildRow(context);
  }

  Widget buildRow(BuildContext context) {
    final defaultText = Text(
      formatter.format(transaction),
      style: transaction.amount <= 0
          ? Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.error,
              )
          : Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
    );

    var rowChildren = <Widget>[defaultText];

    if (transaction.currency != formatter.standardCurrency.name) {
      final convertedText = Text(
        formatter.format(transaction, showConverted: true),
        style: transaction.amount <= 0
            ? Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                )
            : Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
      );
      rowChildren = [
        defaultText,
        convertedText,
      ];
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: rowChildren,
    );
  }
}
