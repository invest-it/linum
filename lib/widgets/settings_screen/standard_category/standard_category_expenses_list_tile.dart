//  Settings Screen Expenses List Tile - the list tile in the settings screen for expenses
//
//  Author: aronzimmermann
//  Co-Author: SoTBurst, NightmindOfficial
//  Refactored: TheBlueBaron

import 'package:flutter/material.dart';
import 'package:linum/providers/account_settings_provider.dart';
import 'package:linum/utilities/backend/local_app_localizations.dart';

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
        AppLocalizations.of(context)!.translate(
              'settings_screen/standard-expense-selector/label-title',
            ) +
            // Translates the value from firebase
            AppLocalizations.of(context)!.translate(
              accountSettingsProvider.getExpenseEntryCategory()?.label ??
                  "ChosenStandardExpense",
            ),
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
