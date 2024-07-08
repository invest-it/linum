import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/widgets/month_slide.dart';
import 'package:linum/common/widgets/screen_tab.dart';
import 'package:linum/features/currencies/core/utils/currency_formatter.dart';
import 'package:linum/features/currencies/settings/presentation/currency_settings_service.dart';
import 'package:linum/screens/budget_screen/models/budget_category.dart';
import 'package:linum/screens/budget_screen/widgets/add_budget_section_button.dart';
import 'package:linum/screens/budget_screen/widgets/budget_section.dart';
import 'package:provider/provider.dart';

class PlanTab extends StatelessWidget {
  const PlanTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = CurrencyFormatter(
      context.locale,
      symbol: context.read<ICurrencySettingsService>().getStandardCurrency().symbol,
    );

    return ScreenTab(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              "Dein Planbudget:".toUpperCase(),
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.textTheme.labelMedium?.color,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0, top: 8.0),
            child: MonthSlide(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  formatter.format(2400), // TODO: Remove hardcoded value
                  style: theme.textTheme.displayMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Column(
            children: [
              BudgetSection(
                budgetCategories: [
                  BudgetCategory(
                    categoryId: "income",
                    budget: 2000,
                  ),
                  BudgetCategory(
                    categoryId: "sidejob",
                    budget: 450,
                  ),
                ],
              ),
            ],
          ),
          const AddBudgetSectionButton(),
        ],
      ),
    );
  }
}
