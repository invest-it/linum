import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/categories/core/data/models/category.dart';
import 'package:linum/features/currencies/core/utils/currency_formatter.dart';
import 'package:linum/features/currencies/settings/presentation/currency_settings_service.dart';
import 'package:provider/provider.dart';

class BudgetTile extends StatelessWidget {
  final Category category;
  final double budget;

  const BudgetTile({
    super.key,
    required this.category,
    required this.budget,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = CurrencyFormatter(
      context.locale,
      symbol: context.watch<ICurrencySettingsService>().getStandardCurrency().symbol,
    );

    return ListTile(
      leading: Icon(category.icon),
      title: Text(
        tr(category.label),
        style: theme.textTheme.titleMedium,
      ),
      trailing: Text(
        formatter.format(budget),
        style: theme.textTheme.titleMedium,
      ),
    );
  }
}
