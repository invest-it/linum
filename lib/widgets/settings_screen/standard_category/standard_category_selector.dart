//  Settings Screen Standard Category - The selector for the standard categories
//
//  Author: aronzimmermann
//  Co-Author: SoTBurst, NightmindOfficial
//  Refactored: TheBlueBaron

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/constants/settings_enums.dart';
import 'package:linum/providers/account_settings_provider.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/widgets/screen_skeleton/screen_skeleton.dart';
import 'package:linum/widgets/settings_screen/standard_category/category_list_tile.dart';
import 'package:linum/widgets/settings_screen/standard_category/category_list_view.dart';
import 'package:provider/provider.dart';

class StandardCategorySelector extends StatefulWidget {
  const StandardCategorySelector({super.key});

  @override
  State<StandardCategorySelector> createState() => _StandardCategorySelectorState();
}

class _StandardCategorySelectorState extends State<StandardCategorySelector> {
  @override
  Widget build(BuildContext context) {
    final AccountSettingsProvider accountSettingsProvider =
        Provider.of<AccountSettingsProvider>(context);
    final ActionLipStatusProvider actionLipStatusProvider =
        Provider.of<ActionLipStatusProvider>(context);
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            actionLipStatusProvider.setActionLip(
              providerKey: ProviderKey.settings,
              actionLipStatus: ActionLipStatus.onviewport,
              actionLipTitle:
                  tr('action_lip.standard-category.income.label-title'),
              actionLipBody: CategoryListView<StandardCategoryIncome>(
                accountSettingsProvider,
                actionLipStatusProvider,
              ),
            );
          },
          child: CategoryListTile(
            defaultLabel: "ChosenStandardIncome",
            labelTitle:
                tr('settings_screen.standard-income-selector.label-title'),
            category: accountSettingsProvider.getIncomeEntryCategory(),
            trailingIcon: Icons.north_east,
            trailingIconColor: Colors.green,
          ),
        ),
        GestureDetector(
          onTap: () {
            actionLipStatusProvider.setActionLip(
              providerKey: ProviderKey.settings,
              actionLipStatus: ActionLipStatus.onviewport,
              actionLipTitle:
                  tr('action_lip.standard-category.expenses.label-title'),
              actionLipBody: CategoryListView<StandardCategoryExpense>(
                accountSettingsProvider,
                actionLipStatusProvider,
              ),
            );
          },
          child: CategoryListTile(
            defaultLabel: "ChosenStandardExpense",
            labelTitle:
                tr('settings_screen.standard-expense-selector.label-title'),
            category: accountSettingsProvider.getExpenseEntryCategory(),
            trailingIcon: Icons.south_east,
            trailingIconColor: Colors.red,
          ),
        ),
      ],
    );
  }
}
