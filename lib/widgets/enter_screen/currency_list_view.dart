import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/constants/standard_currencies.dart';
import 'package:linum/models/currency.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/providers/enter_screen_provider.dart';
import 'package:linum/utilities/frontend/silent_scroll.dart';
import 'package:linum/widgets/text_icon.dart';
import 'package:provider/provider.dart';

class CurrencyListView extends StatelessWidget {
  const CurrencyListView({super.key});

  void _selectCurrency(
      BuildContext context,
      Currency currency,
    ) {

    Provider.of<ActionLipStatusProvider>(context, listen: false)
        .setActionLipStatus(
      providerKey: ProviderKey.enter,
    );
    Provider.of<EnterScreenProvider>(context, listen: false)
        .setCurrency(currency.name);
  }

  @override
  Widget build(BuildContext context) {
    final currencies = standardCurrencies.values.toList();

    return ScrollConfiguration(
      behavior: SilentScroll(),
      child: ListView.builder(
        itemCount: standardCurrencies.length,
        itemBuilder: (BuildContext context, int index) {
          final currency = currencies[index];
          return ListTile(
            leading: currency.icon != null
                ? Icon(currency.icon)
                : TextIcon(currency.symbol),
            title: Text(tr(currency.label)),
            onTap: () => {
              _selectCurrency(
                context,
                currency,
              ),
            },
          );
        },
      ),
    );
  }
}
