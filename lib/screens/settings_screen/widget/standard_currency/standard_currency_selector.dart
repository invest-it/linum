import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/components/action_lip/viewmodels/action_lip_viewmodel.dart';
import 'package:linum/core/account/services/account_settings_service.dart';
import 'package:linum/core/design/layout/enums/screen_key.dart';
import 'package:linum/core/design/layout/widgets/screen_skeleton.dart';
import 'package:linum/screens/settings_screen/widget/standard_currency/currency_list_tile.dart';
import 'package:linum/screens/settings_screen/widget/standard_currency/curreny_list_view.dart';
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
    final ActionLipViewModel actionLipStatusProvider =
        Provider.of<ActionLipViewModel>(context);
    final accountSettingsProvider =
        Provider.of<AccountSettingsService>(context);

    final currentCurrency = accountSettingsProvider.getStandardCurrency();

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            actionLipStatusProvider.setActionLip(
              screenKey: ScreenKey.settings,
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
