import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/features/currencies/core/utils/currency_formatter.dart';
import 'package:linum/features/currencies/settings/presentation/currency_settings_service.dart';
import 'package:provider/provider.dart';

class CategoryBudgetChart extends StatelessWidget {
  final Color color;
  final String label;
  final num expenses;
  final num budget;
  const CategoryBudgetChart({
    super.key,
    required this.color,
    required this.label,
    required this.expenses,
    required this.budget,
  });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = CurrencyFormatter(
      context.locale,
      symbol: context.watch<ICurrencySettingsService>().getStandardCurrency().symbol,
    );

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      color: theme.colorScheme.background,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(label, style: theme.textTheme.headlineSmall,),
                  ),
                ),
                Text(formatter.format(budget - expenses), style: theme.textTheme.headlineMedium)
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: LinearProgressIndicator(
                backgroundColor: Colors.black12,
                color: color,
                value: expenses / budget,
                borderRadius:
                const BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
