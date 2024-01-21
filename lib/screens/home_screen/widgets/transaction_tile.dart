import 'dart:async';

import 'package:badges/badges.dart' as badge;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/components/dialogs/show_transaction_delete_dialog.dart';
import 'package:linum/core/balance/models/transaction.dart';
import 'package:linum/core/balance/services/balance_data_service.dart';
import 'package:linum/core/balance/utils/transaction_amount_formatter.dart';
import 'package:linum/core/categories/core/constants/standard_categories.dart';
import 'package:linum/core/categories/core/utils/translate_category.dart';
import 'package:linum/generated/translation_keys.g.dart';
import 'package:linum/screens/enter_screen/presentation/utils/show_enter_screen.dart';
import 'package:linum/screens/home_screen/widgets/serial_delete_mode_selection_view.dart';
import 'package:linum/screens/home_screen/widgets/transaction_amount_display.dart';
import 'package:provider/provider.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final TransactionAmountFormatter amountFormatter;
  final bool isFutureItem;

  const TransactionTile({
    super.key,
    required this.transaction,
    required this.amountFormatter,
    this.isFutureItem = false,
  });


  @override
  Widget build(BuildContext context) {
    final String langCode = context.locale.languageCode;
    final DateFormat formatter = DateFormat('EEEE, dd. MMMM yyyy', langCode);
    final balanceDataService = context.read<BalanceDataService>();

    return GestureDetector(
      onTap: () {
        showEnterScreen(context, transaction: transaction);
      },
      child: Dismissible(
        background: ColoredBox(
          color: Colors.red,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16.0,
                  children: [
                    Text(
                      tr(translationKeys.listview.dismissible.labelDelete),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.secondaryContainer,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        key: Key(transaction.id),
        direction: DismissDirection.endToStart,
        dismissThresholds: const {
          DismissDirection.endToStart: 0.5,
        },
        confirmDismiss: (DismissDirection direction)  {
          // TODO refactor! SerialDeleteSelectionView has duplicated code from the enterscreen's serial transaction change mode selection.
          if(transaction.repeatId != null){
            const radius = Radius.circular(16.0);
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return SerialDeleteModeSelectionView(transaction: transaction,);
              },
              isDismissible: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(topLeft: radius, topRight: radius),
              ),
            );
          } else {
            showTransactionDeleteDialog(context, () async {
              balanceDataService.removeTransaction(transaction);
            });
          }
          return Future.value(false);
        },
        child: ListTile(
          leading: badge.Badge(
            padding: const EdgeInsets.all(2),
            toAnimate: false,
            position: const badge.BadgePosition(bottom: 23, start: 23),
            elevation: 1,
            badgeColor: _selectBatchColor(context),
            badgeContent: transaction.repeatId != null
                ? Icon(
              Icons.autorenew_rounded,
              color: isFutureItem
                  ? transaction.amount > 0
                    ? Theme.of(context).colorScheme.tertiary
                    : Theme.of(context).colorScheme.errorContainer
                  : Theme.of(context).colorScheme.secondaryContainer,
              size: 18,
            )
                : const SizedBox(),
            child: TransactionTileIcon(
              transaction: transaction,
              isFutureItem: isFutureItem,
            ),
          ),
          title: TransactionTileTitle(
            transaction: transaction,
            isFutureItem: isFutureItem,
          ),
          subtitle: Text(
            formatter.format(
              transaction.date.toDate(),
            ).toUpperCase(),
            style: isFutureItem
                ? Theme.of(context).textTheme.labelSmall!.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.onSurface,
                ) : Theme.of(context).textTheme.labelSmall,
          ),
          trailing: TransactionAmountDisplay(
            transaction: transaction,
            formatter: amountFormatter,
          ),
        ),
      ),
    );
  }

  Color _selectBatchColor(BuildContext context) {
    if (isFutureItem && transaction.repeatId != null) {
      return Theme.of(context).colorScheme.tertiaryContainer;
    }

    if (transaction.repeatId != null && transaction.amount > 0) {
      return Theme.of(context).colorScheme.tertiary;
    }

    if (transaction.repeatId != null) {
      return Theme.of(context).colorScheme.errorContainer;
    }

    // ignore: use_full_hex_values_for_flutter_colors
    return const Color(0x000000);
    //cannot use the suggestion as it produces an unwanted white point
  }
}

class TransactionTileTitle extends StatelessWidget {
  final Transaction transaction;
  final bool isFutureItem;

  const TransactionTileTitle({
    super.key,
    required this.transaction,
    required this.isFutureItem,
  });

  @override
  Widget build(BuildContext context) {
    final titleText = transaction.name != ""
        ? transaction.name
        : translateCategoryId(
            transaction.category,
            isExpense: transaction.amount <= 0,
          );

    return Row(
      children: [
        Text(
          titleText,
          style: isFutureItem
              ? Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.onSurface,
                )
              : Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(width: 10,),
        transaction.note != null
            ? Badge(
                largeSize: 20,
                backgroundColor: Theme.of(context).colorScheme.primary,
                label: const Icon(
                  Icons.edit_outlined,
                  size: 12,
                  color: Colors.white,
                ),
              )
            : Container(),

      ],
    );
  }
}


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
      backgroundColor: isFutureItem
          ? transaction.amount > 0
            ? Theme.of(context).colorScheme.tertiary
      // FUTURE INCOME BACKGROUND
            : Theme.of(context).colorScheme.errorContainer
      // FUTURE EXPENSE BACKGROUND
          : transaction.amount > 0
            ? Theme.of(context).colorScheme.secondary
      // PRESENT INCOME BACKGROUND
            : Theme.of(context).colorScheme.secondary,
      // PRESENT EXPENSE BACKGROUND
      child: _selectIcon(context),
    );
  }

  Icon _selectIcon(BuildContext context) {
    if (transaction.amount > 0) {
      return Icon(
        standardCategories[transaction.category]?.icon ?? Icons.error,
        color: isFutureItem
          ? Theme.of(context).colorScheme.onPrimary
      // FUTURE INCOME ICON
          : Theme.of(context).colorScheme.tertiary,
        // PRESENT INCOME ICON
      );
    }

    return Icon(
      standardCategories[transaction.category]?.icon ?? Icons.error,
      color: isFutureItem
          ? Theme.of(context).colorScheme.onPrimary
      // FUTURE EXPENSE ICON
          : Theme.of(context).colorScheme.errorContainer,
      // PRESENT EXPENSE ICON
    );
  }
}
