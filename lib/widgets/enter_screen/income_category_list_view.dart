import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/constants/settings_enums.dart';
import 'package:linum/constants/standard_income_categories.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/providers/enter_screen_provider.dart';
import 'package:linum/utilities/frontend/silent_scroll.dart';
import 'package:linum/widgets/screen_skeleton/screen_skeleton.dart';
import 'package:provider/provider.dart';

class IncomeCategoryListView extends StatelessWidget {
  const IncomeCategoryListView({super.key});

  void _selectCategoryItemIncome(
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
        itemCount: standardIncomeCategories.length,
        itemBuilder: (BuildContext context, int index) {
          final categoryKey = StandardCategoryIncome.values[index];
          final category = standardIncomeCategories[categoryKey];
          return ListTile(
            leading: Icon(
              category!.icon,
            ),
            title: Text(
              tr(category.label),
            ),
            onTap: () => _selectCategoryItemIncome(
              context,
              categoryKey.name,
            ),
          );
        },
      ),
    );
  }
}
