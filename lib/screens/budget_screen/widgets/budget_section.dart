import 'package:flutter/material.dart';
import 'package:linum/core/categories/core/presentation/category_service.dart';
import 'package:linum/screens/budget_screen/models/budget_category.dart';
import 'package:linum/screens/budget_screen/widgets/budget_form.dart';
import 'package:linum/screens/budget_screen/widgets/budget_tile.dart';
import 'package:provider/provider.dart';

class BudgetSection extends StatelessWidget {
  final List<BudgetCategory> budgetCategories;
  const BudgetSection({super.key, required this.budgetCategories});


  @override
  Widget build(BuildContext context) {
    final categories = context.read<ICategoryService>().getAllCategories();

    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      child: Card.outlined(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(
                "Einnahmen",
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: budgetCategories.map((c) {
                  return BudgetTile(
                      category: categories[c.categoryId]!,
                      budget: c.budget,
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: OutlinedButton.icon(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        showDragHandle: true,
                        builder: (context) {
                          return const BudgetForm();
                        },
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: Text(
                      "Hinzufügen",
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
