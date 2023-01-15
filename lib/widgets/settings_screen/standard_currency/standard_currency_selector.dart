import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/providers/account_settings_provider.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/widgets/screen_skeleton/screen_skeleton.dart';
import 'package:linum/widgets/settings_screen/standard_currency/currency_list_tile.dart';
import 'package:linum/widgets/settings_screen/standard_currency/curreny_list_view.dart';
import 'package:provider/provider.dart';

class StandardCurrencySelector extends StatefulWidget {
  const StandardCurrencySelector({super.key});

  @override
  State<StandardCurrencySelector> createState() =>
      _StandardCurrencySelectorState();
}

class _StandardCurrencySelectorState extends State<StandardCurrencySelector> {
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
              actionLipTitle: tr('action_lip.standard-currency.label-title'),
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
