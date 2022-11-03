import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/constants/settings_enums.dart';
import 'package:linum/constants/standard_currencies.dart';
import 'package:linum/models/entry_category.dart';
import 'package:linum/models/entry_currency.dart';
import 'package:linum/providers/account_settings_provider.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/utilities/frontend/size_guide.dart';

class CurrencyListView extends StatelessWidget {
  final ActionLipStatusProvider actionLipStatusProvider;
  final AccountSettingsProvider accountSettingsProvider;

  late final int enumItemCount;
  late final EntryCurrency? Function(int indexBuilder) standardCurrencyFunction;
  late final String Function(int indexBuilder) enumStr;

  CurrencyListView(this.accountSettingsProvider, this.actionLipStatusProvider) {
    enumItemCount = StandardCurrency.values.length;
    standardCurrencyFunction = (int indexBuilder) =>
        standardCurrency[StandardCurrency.values[indexBuilder]];
    enumStr =
        (int indexBuilder) => StandardCurrency.values[indexBuilder].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 24.0,
          ),
          child: Column(
            children: [
              SizedBox(
                height:
                    proportionateScreenHeightFraction(ScreenFraction.twofifths),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: enumItemCount,
                  itemBuilder: (BuildContext context, int indexBuilder) {
                    return ListTile(
                      leading: Icon(
                        standardCurrencyFunction(indexBuilder)?.icon,
                      ),
                      title: Text(
                        tr(
                          standardCurrencyFunction(indexBuilder)?.label ??
                              "Currency",
                        ),
                      ),
                      onTap: () {
                        actionLipStatusProvider.setActionLipStatus(
                          providerKey: ProviderKey.settings,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
