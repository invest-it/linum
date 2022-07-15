//  Settings Screen Income List Tile - the list tile in the settings screen for income
//
//  Author: aronzimmermann
//  Co-Author: SoTBurst, NightmindOfficial
//  Refactored: none

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/providers/account_settings_provider.dart';

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
        tr("settings_screen.standard-income-selector.label-title") +
        // Translates the value from firebase
        tr(accountSettingsProvider.getIncomeEntryCategory()?.label ?? "ChosenStandardIncome"),
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
