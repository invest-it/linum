//  Settings Screen Income List Tile - the list tile in the settings screen for income
//
//  Author: aronzimmermann
//  Co-Author: SoTBurst, NightmindOfficial
//  Refactored: TheBlueBaron

import 'package:flutter/material.dart';
import 'package:linum/providers/account_settings_provider.dart';
import 'package:linum/utilities/backend/local_app_localizations.dart';

class StandardCategoryIncomeListTile extends StatelessWidget {
  const StandardCategoryIncomeListTile({
    Key? key,
    required this.accountSettingsProvider,
  }) : super(key: key);

  final AccountSettingsProvider accountSettingsProvider;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        AppLocalizations.of(context)!.translate(
              'settings_screen/standard-income-selector/label-title',
            ) +
            // Translates the value from firebase
            AppLocalizations.of(context)!.translate(
              accountSettingsProvider.getIncomeEntryCategory()?.label ??
                  "ChosenStandardIncome",
            ),
        style: Theme.of(context).textTheme.bodyText1,
      ),
      trailing: const Icon(
        Icons.north_east,
        color: Color(0xFF97BC4E),
      ),
      leading: Icon(
        accountSettingsProvider.getIncomeEntryCategory()?.icon ?? Icons.error,
      ),
    );
  }
}
