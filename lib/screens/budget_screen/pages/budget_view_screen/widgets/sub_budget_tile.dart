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

  BudgetViewData({
    required this.name,
    required this.expenses,
    required this.cap,
    required this.categories,
  });
}

class SubBudgetTile extends StatefulWidget {
  final BudgetViewData budgetData;
  const SubBudgetTile({super.key, required this.budgetData});

  @override
  State<SubBudgetTile> createState() => _SubBudgetTileState();
}

class _SubBudgetTileState extends State<SubBudgetTile> {
  bool isOpen = false;
  double turns = 0.0;
  List<String> categories = [];

  final animationDuration = 150;
  late final stepDuration = animationDuration ~/ widget.budgetData.categories.length;

  Future<void> _showCategories() async {
    for (final cat in widget.budgetData.categories) {
      setState(() {
        categories.add(cat);
        // categories = [...categories, cat];
      });
      await Future.delayed(Duration(milliseconds: stepDuration), (){});
    }
  }

  Future<void> _removeCategories() async {
    for (final _ in widget.budgetData.categories) {
      setState(() {
        categories.removeLast();
      });
      await Future.delayed(Duration(milliseconds: stepDuration), (){});
    }
  }


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
                AnimatedRotation(
                  turns: turns,
                  duration: const Duration(milliseconds: 150),
                  child: IconButton(
                    onPressed: () {
                      if (isOpen) {
                        _removeCategories();
                      } else {
                        _showCategories();
                      }

                      setState(() {
                        isOpen = !isOpen;
                        if (turns == 0.5) {
                          turns = .0;
                        } else {
                          turns = .5;
                        }
                      });
                    },
                    icon: const Icon(Icons.expand_more),
                  ),
                ),
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
                    style: theme.textTheme.labelMedium,),
                Text(formatter.format(widget.budgetData.cap),
                    style: theme.textTheme.labelMedium,),
              ],
            ),
            if (isOpen) const Divider(),
            AnimatedSize(
              alignment: Alignment.topLeft,
              duration: const Duration(milliseconds: 150),
              child: isOpen ? Column(
                children: categories.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(item),
                  );
                }).toList(),
              ) : Container(),
            ),
          ],
        ),
      ),
    );
  }
}

/*
Convert Widgets to Stack
Cut upper Stack Border, but leave the

 */
