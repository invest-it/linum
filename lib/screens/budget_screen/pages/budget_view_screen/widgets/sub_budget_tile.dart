import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/features/currencies/core/utils/currency_formatter.dart';
import 'package:linum/features/currencies/settings/presentation/currency_settings_service.dart';
import 'package:provider/provider.dart';

class BudgetViewData {
  final String name;
  final double expenses;
  final double cap;
  final List<String> categories;

  BudgetViewData(
      {required this.name,
      required this.expenses,
      required this.cap,
      required this.categories});
}

class SubBudgetTile extends StatefulWidget {
  final BudgetViewData budgetData;
  const SubBudgetTile({super.key, required this.budgetData});

  @override
  State<SubBudgetTile> createState() => _SubBudgetTileState();
}

class _SubBudgetTileState extends State<SubBudgetTile> {
  var isOpen = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = CurrencyFormatter(
      context.locale,
      symbol: context
          .watch<ICurrencySettingsService>()
          .getStandardCurrency()
          .symbol,
    );

    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.budgetData.name,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        isOpen = !isOpen;
                      });
                    },
                    icon: const Icon(Icons.expand_more)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 4.0),
              child: LinearProgressIndicator(
                backgroundColor: Colors.black12,
                color: theme.colorScheme.primary,
                value: widget.budgetData.expenses / widget.budgetData.cap,
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    "${formatter.format(widget.budgetData.cap - widget.budgetData.expenses)} remaining",
                    style: theme.textTheme.labelMedium),
                Text(formatter.format(widget.budgetData.cap),
                    style: theme.textTheme.labelMedium),
              ],
            ),
            if (isOpen) const Text("Hola mucho gusto"),
          ],
        ),
      ),
    );
  }
}


/*



 */
