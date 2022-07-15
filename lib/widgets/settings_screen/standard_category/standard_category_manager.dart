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

class StandardCategory extends StatefulWidget {
  const StandardCategory({Key? key}) : super(key: key);

  @override
  State<StandardCategory> createState() => _StandardCategoryState();
}

class _StandardCategoryState extends State<StandardCategory> {
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
              actionLipTitle: tr('action_lip.standard-category.income.label-title'),
              actionLipBody: CategoryListView<StandardCategoryIncome>(
                accountSettingsProvider,
                actionLipStatusProvider,
              ),
            );
          },
          child: CategoryListTile(
            defaultLabel: "ChosenStandardIncome",
            labelTitle: AppLocalizations.of(context)!.translate(
              'settings_screen/standard-income-selector/label-title',
            ),
            category: accountSettingsProvider.getIncomeEntryCategory(),
          ),
        ),
        GestureDetector(
          onTap: () {
            actionLipStatusProvider.setActionLip(
              providerKey: ProviderKey.settings,
              actionLipStatus: ActionLipStatus.onviewport,
              actionLipBody: CategoryListView<StandardCategoryExpense>(
              actionLipTitle: tr('action_lip.standard-category.expenses.label-title'),
                accountSettingsProvider,
                actionLipStatusProvider,
              ),
            );
          },
          child: CategoryListTile(
            defaultLabel: "ChosenStandardExpense",
            labelTitle: AppLocalizations.of(context)!.translate(
              'settings_screen/standard-expense-selector/label-title',
            ),
            category: accountSettingsProvider.getExpenseEntryCategory(),
          ),
        ),
      ],
    );
  }
}
