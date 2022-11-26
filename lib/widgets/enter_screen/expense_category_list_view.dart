import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/constants/settings_enums.dart';
import 'package:linum/constants/standard_expense_categories.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/providers/enter_screen_provider.dart';
import 'package:linum/utilities/frontend/silent_scroll.dart';
import 'package:linum/widgets/screen_skeleton/screen_skeleton.dart';
import 'package:provider/provider.dart';

class ExpenseCategoryListView extends StatelessWidget {
  const ExpenseCategoryListView({super.key});

  void _selectCategoryItemExpenses(
      BuildContext context,
      String name,
      ) {
    Provider.of<ActionLipStatusProvider>(context, listen: false)
        .setActionLipStatus(
          providerKey: ProviderKey.enter,
          status: ActionLipStatus.hidden,
        );
    Provider.of<EnterScreenProvider>(context, listen: false)
        .setCategory(name);
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: SilentScroll(),
      child: ListView.builder(
        itemCount: standardExpenseCategories.length,
        itemBuilder: (BuildContext context, int index) {
          final categoryKey = StandardCategoryExpense.values[index];
          final category = standardExpenseCategories[categoryKey];
          return ListTile(
            leading: Icon(
              category!.icon,
            ),
            title: Text(
              tr(category.label),
            ),
            //selects the item as the categories value
            onTap: () => _selectCategoryItemExpenses(
              context,
              categoryKey.name,
            ),
          );
        },
      ),
    );
  }
}
