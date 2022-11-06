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
import 'package:linum/widgets/settings_screen/standard_currency/currency_list_tile.dart';
import 'package:linum/widgets/settings_screen/standard_currency/curreny_list_view.dart';
import 'package:provider/provider.dart';

class StandardCurrencyManager extends StatefulWidget {
  const StandardCurrencyManager({super.key});

  @override
  State<StandardCurrencyManager> createState() =>
      _StandardCurrencyManagerState();
}

class _StandardCurrencyManagerState extends State<StandardCurrencyManager> {
  @override
  Widget build(BuildContext context) {
    final ActionLipStatusProvider actionLipStatusProvider =
        Provider.of<ActionLipStatusProvider>(context);
    final accountSettingsProvider =
        Provider.of<AccountSettingsProvider>(context);

    final currentCurrency = accountSettingsProvider.getStandardCurrency();

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            actionLipStatusProvider.setActionLip(
              providerKey: ProviderKey.settings,
              actionLipStatus: ActionLipStatus.onviewport,
              actionLipTitle:
                  "Currency", // FIXME: Translate settings_screen.standard-currency.action-lip-title
              actionLipBody: CurrencyListView(),
            );
          },
          child: CurrencyListTile(
            currency: currentCurrency,
          ),
        ),
      ],
    );
  }
}
