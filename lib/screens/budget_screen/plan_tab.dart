import 'package:flutter/material.dart';
import 'package:linum/common/widgets/screen_tab.dart';
import 'package:linum/screens/budget_screen/models/budget_category.dart';
import 'package:linum/screens/budget_screen/widgets/add_budget_section_button.dart';
import 'package:linum/screens/budget_screen/widgets/budget_section.dart';

class PlanTab extends StatelessWidget {
  const PlanTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
          // TODO: Month Switch. See remaining tab for implementation ideas
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
