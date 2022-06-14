//  Settings Screen Standard Category - The selector for the standard categories
//
//  Author: aronzimmermann
//  Co-Author: SoTBurst, NightmindOfficial
//  Refactored: TheBlueBaron

import 'package:flutter/material.dart';
import 'package:linum/providers/account_settings_provider.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/utilities/backend/local_app_localizations.dart';
import 'package:linum/widgets/screen_skeleton/screen_skeleton.dart';
import 'package:linum/widgets/settings_screen/standard_category/expenses_list_view.dart';
import 'package:linum/widgets/settings_screen/standard_category/income_list_view.dart';
import 'package:linum/widgets/settings_screen/standard_category/standard_category_expenses_list_tile.dart';
import 'package:linum/widgets/settings_screen/standard_category/standard_category_income_list_tile.dart';
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
              actionLipTitle: AppLocalizations.of(context)!.translate(
                'action_lip/standard-category/income/label-title',
              ),
              actionLipBody: IncomeListView(
                accountSettingsProvider,
                actionLipStatusProvider,
              ),
            );
          },
          child: StandardCategoryIncomeListTile(
            accountSettingsProvider: accountSettingsProvider,
          ),
        ),
        GestureDetector(
          onTap: () {
            actionLipStatusProvider.setActionLip(
              providerKey: ProviderKey.settings,
              actionLipStatus: ActionLipStatus.onviewport,
              actionLipTitle: AppLocalizations.of(context)!.translate(
                'action_lip/standard-category/expenses/label-title',
              ),
              actionLipBody: ExpensesListView(
                accountSettingsProvider,
                actionLipStatusProvider,
              ),
            );
          },
          child: StandardCategoryExpensesListTile(
            accountSettingsProvider: accountSettingsProvider,
          ),
        ),
      ],
    );
  }
}
