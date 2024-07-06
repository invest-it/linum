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
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Colors.grey,
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Column(
              children: [
                Text(label, style: theme.textTheme.headlineSmall,),
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
            const SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
                  child: Text("${formatter.format(budget - expenses)} remaining", style: theme.textTheme.labelMedium),
                ),
                Text(formatter.format(budget), style: theme.textTheme.labelMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
