//  Settings Screen Expenses List Tile - the list tile in the settings screen for expenses
//
//  Author: aronzimmermann
//  Co-Author: SoTBurst, NightmindOfficial
//  Refactored: none

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/providers/account_settings_provider.dart';

class StandardCategoryExpensesListTile extends StatelessWidget {
  const StandardCategoryExpensesListTile({
    Key? key,
    required this.accountSettingsProvider,
  }) : super(key: key);

  final AccountSettingsProvider accountSettingsProvider;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        tr('settings_screen.standard-expense-selector.label-title') +
            // Translates the value from firebase
        tr(accountSettingsProvider.getExpenseEntryCategory()?.label ?? "ChosenStandardExpense"),
        style: Theme.of(context).textTheme.bodyText1,
      ),
      trailing: const Icon(
        Icons.south_east,
        color: Colors.red,
      ),
      leading: Icon(
        accountSettingsProvider.getExpenseEntryCategory()?.icon ?? Icons.error,
      ),
    );
  }
}
