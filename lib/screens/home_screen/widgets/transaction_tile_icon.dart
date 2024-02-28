import 'package:flutter/material.dart';
import 'package:linum/core/balance/models/transaction.dart';
import 'package:linum/core/categories/core/constants/standard_categories.dart';

class TransactionTileIcon extends StatelessWidget {
  final Transaction transaction;
  final bool isFutureItem;
  const TransactionTileIcon({
    super.key,
    required this.transaction,
    required this.isFutureItem,
  });

  // TODO: Get rid of these ternaries
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: _selectBackgroundColor(context),
      // PRESENT EXPENSE BACKGROUND
      child: Icon(
        standardCategories[transaction.category]?.icon ?? Icons.error,
        color: _selectIconColor(context),
      ),
    );
  }

  Color _selectBackgroundColor(BuildContext context) {
    if (isFutureItem) {
      return transaction.amount > 0
          ? Theme.of(context).colorScheme.tertiary
          : Theme.of(context).colorScheme.errorContainer;
    }
    return Theme.of(context).colorScheme.secondary;
  }

  Color _selectIconColor(BuildContext context) {
    if (isFutureItem) {
      return Theme.of(context).colorScheme.onPrimary;
    }

    return transaction.amount > 0
        ? Theme.of(context).colorScheme.tertiary
        : Theme.of(context).colorScheme.errorContainer;
  }
}
