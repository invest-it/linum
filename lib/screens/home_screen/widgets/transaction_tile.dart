import 'dart:async';

import 'package:badges/badges.dart' as badge;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/components/dialogs/show_transaction_delete_dialog.dart';
import 'package:linum/core/balance/models/transaction.dart';
import 'package:linum/core/balance/services/balance_data_service.dart';
import 'package:linum/core/balance/utils/transaction_amount_formatter.dart';
import 'package:linum/screens/enter_screen/presentation/utils/show_enter_screen.dart';
import 'package:linum/screens/home_screen/widgets/serial_delete_mode_selection_view.dart';
import 'package:linum/screens/home_screen/widgets/transaction_amount_display.dart';
import 'package:linum/screens/home_screen/widgets/transaction_tile_background.dart';
import 'package:linum/screens/home_screen/widgets/transaction_tile_icon.dart';
import 'package:linum/screens/home_screen/widgets/transaction_tile_title.dart';
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


    return GestureDetector(
      onTap: () {
        showEnterScreen(context, transaction: transaction);
      },
      child: Dismissible(
        background: const TransactionTileBackground(),
        key: Key(transaction.id),
        direction: DismissDirection.endToStart,
        dismissThresholds: const {
          DismissDirection.endToStart: 0.5,
        },
        confirmDismiss: (DismissDirection dismissDirection) => _confirmDismiss(context),
        child: ListTile(
          leading: badge.Badge(
            padding: const EdgeInsets.all(2),
            toAnimate: false,
            position: const badge.BadgePosition(bottom: 23, start: 23),
            elevation: 1,
            badgeColor: _selectBadgeColor(context),
            badgeContent: transaction.repeatId != null
                ? Icon(
              Icons.autorenew_rounded,
              color: _selectBadgeContentColor(context),
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
                  )
                : Theme.of(context).textTheme.labelSmall,
          ),
          trailing: TransactionAmountDisplay(
            transaction: transaction,
            formatter: amountFormatter,
          ),
        ),
      ),
    );
  }

  Color _selectBadgeColor(BuildContext context) {
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

  Color _selectBadgeContentColor(BuildContext context) {
    if (!isFutureItem) {
      return Theme.of(context).colorScheme.secondaryContainer;
    }

    return transaction.amount > 0
        ? Theme.of(context).colorScheme.tertiary
        : Theme.of(context).colorScheme.errorContainer;
  }

  Future<bool?> _confirmDismiss(BuildContext context) async {
    // TODO refactor! SerialDeleteSelectionView has duplicated code from the enterscreen's serial transaction change mode selection.
    final balanceDataService = context.read<BalanceDataService>();

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
  }
}
