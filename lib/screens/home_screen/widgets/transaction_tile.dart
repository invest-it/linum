import 'package:badges/badges.dart' as badge;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/balance/models/transaction.dart';
import 'package:linum/core/balance/utils/transaction_amount_formatter.dart';
import 'package:linum/core/categories/constants/standard_categories.dart';
import 'package:linum/core/categories/utils/translate_category.dart';
import 'package:linum/screens/enter_screen/utils/show_enter_screen.dart';
import 'package:linum/screens/home_screen/widgets/transaction_amount_display.dart';

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
                      tr("listview.dismissible.label-delete"),
                      style: Theme.of(context).textTheme.button,
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
        confirmDismiss: (DismissDirection direction) async {
          return null;
          // TODO: Reimplement
          /*return generateDeleteDialogFromTransaction(
            context,
            // balanceDataProvider,
            transaction,
          ); */
        },
        child: ListTile(
          leading: badge.Badge(
            padding: const EdgeInsets.all(2),
            toAnimate: false,
            position: const badge.BadgePosition(bottom: 23, start: 23),
            elevation: 1,
            badgeColor: isFutureItem && transaction.repeatId != null
                ? Theme.of(context).colorScheme.tertiaryContainer
            //badgeColor for current transactions
                : transaction.amount > 0
            //badgeColor for future transactions
                ? transaction.repeatId != null
                ? Theme.of(context).colorScheme.tertiary
            // ignore: use_full_hex_values_for_flutter_colors
                : const Color(0x000000)
                : transaction.repeatId != null
                ? Theme.of(context).colorScheme.errorContainer
            // ignore: use_full_hex_values_for_flutter_colors
                : const Color(0x000000),
            //cannot use the suggestion as it produces an unwanted white point
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
            child: CircleAvatar(
              backgroundColor: isFutureItem
                  ? transaction.amount > 0
                  ? Theme.of(context)
                  .colorScheme
                  .tertiary // FUTURE INCOME BACKGROUND
                  : Theme.of(context).colorScheme.errorContainer
              // FUTURE EXPENSE BACKGROUND
                  : transaction.amount > 0
                  ? Theme.of(context)
                  .colorScheme
                  .secondary // PRESENT INCOME BACKGROUND
                  : Theme.of(context)
                  .colorScheme
                  .secondary, // PRESENT EXPENSE BACKGROUND
              child: transaction.amount > 0
                  ? Icon(
                standardCategories[transaction.category]?.icon ??
                    Icons.error,
                color: isFutureItem
                    ? Theme.of(context)
                    .colorScheme
                    .onPrimary // FUTURE INCOME ICON
                    : Theme.of(context)
                    .colorScheme
                    .tertiary, // PRESENT INCOME ICON
              )
                  : Icon(
                standardCategories[transaction.category]?.icon ??
                    Icons.error,
                color: isFutureItem
                    ? Theme.of(context)
                    .colorScheme
                    .onPrimary // FUTURE EXPENSE ICON
                    : Theme.of(context)
                    .colorScheme
                    .errorContainer, // PRESENT EXPENSE ICON
              ),
            ),
          ),
          title: Text(
            transaction.name != ""
                ? transaction.name
                : translateCategoryId(
              transaction.category,
              isExpense: transaction.amount <= 0,
            ),
            style: isFutureItem
                ? Theme.of(context).textTheme.bodyText1!.copyWith(
              fontStyle: FontStyle.italic,
              color: Theme.of(context).colorScheme.onSurface,
            )
                : Theme.of(context).textTheme.bodyText1,
          ),
          subtitle: Text(
            formatter
                .format(
              transaction.date.toDate(),
            )
                .toUpperCase(),
            style: isFutureItem
                ? Theme.of(context).textTheme.overline!.copyWith(
              fontStyle: FontStyle.italic,
              color: Theme.of(context).colorScheme.onSurface,
            )
                : Theme.of(context).textTheme.overline,
          ),
          trailing: TransactionAmountDisplay(
            transaction: transaction,
            formatter: amountFormatter,
          ),
        ),
      ),
    );
  }
}
