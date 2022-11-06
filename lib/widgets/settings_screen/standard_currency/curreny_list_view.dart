import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/constants/standard_currencies.dart';
import 'package:linum/providers/account_settings_provider.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/utilities/frontend/size_guide.dart';
import 'package:provider/provider.dart';

class CurrencyListView extends StatelessWidget {
  final currencies = standardCurrencies.values.toList();
  final int enumItemCount = standardCurrencies.length;

  CurrencyListView();

  @override
  Widget build(BuildContext context) {
    final accountSettingsProvider =
        Provider.of<AccountSettingsProvider>(context);
    final actionLipStatusProvider =
        Provider.of<ActionLipStatusProvider>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
          ),
          child: Column(
            children: [
              SizedBox(
                height:
                    proportionateScreenHeightFraction(ScreenFraction.twofifths),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: enumItemCount,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: Icon(
                        currencies[index].icon,
                      ),
                      title: Text(
                        tr(
                          currencies[index].label,
                        ),
                      ),
                      onTap: () {
                        accountSettingsProvider
                            .setStandardCurrency(currencies[index]);
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
