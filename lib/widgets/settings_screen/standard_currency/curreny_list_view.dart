import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/constants/screen_fraction_enum.dart';
import 'package:linum/constants/standard_currencies.dart';
import 'package:linum/providers/account_settings_provider.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/utilities/frontend/layout_helpers.dart';
import 'package:linum/widgets/screen_skeleton/screen_skeleton.dart';
import 'package:linum/widgets/text_icon.dart';
import 'package:provider/provider.dart';

class CurrencyListView extends StatelessWidget {
  final currencies = standardCurrencies.values.toList();
  final int enumItemCount = standardCurrencies.length;

  CurrencyListView();

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AccountSettingsProvider>(context);
    final actionLipStatus = Provider.of<ActionLipStatusProvider>(context);
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.only(
          left: 24.0,
          right: 24.0,
          bottom: context.proportionateScreenHeightFraction(ScreenFraction.onefifth),
        ),
        shrinkWrap: true,
        itemCount: enumItemCount,
        itemBuilder: (BuildContext context, int index) {
          final currency = currencies[index];
          return ListTile(
            leading: TextIcon(
              currency.name,
              selected: currency.name ==
                  settings.getStandardCurrency().name,
            ),
            selected:
                currency.name == settings.getStandardCurrency().name,
            title: Text(
              "${tr(currency.label)} (${currency.symbol})",
            ),
            onTap: () {
              settings.setStandardCurrency(currencies[index]);
              actionLipStatus.setActionLipStatus(
                providerKey: ProviderKey.settings,
                status: ActionLipStatus.hidden,
              );
            },
          );
        },
      ),
    );
  }
}
