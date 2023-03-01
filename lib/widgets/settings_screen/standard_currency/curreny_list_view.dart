import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/constants/standard_currencies.dart';
import 'package:linum/providers/account_settings_provider.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/providers/size_guide_provider.dart';
import 'package:linum/utilities/frontend/size_guide.dart';
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
    final sizeGuideProvider = Provider.of<SizeGuideProvider>(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
          ),
          child: Column(
            children: [
              SizedBox(
                height: sizeGuideProvider.proportionateScreenHeightFraction(
                    ScreenFraction.twofifths),
                child: ListView.builder(
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}
