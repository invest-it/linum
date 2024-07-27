import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/components/sheets/linum_bottom_sheet.dart';
import 'package:linum/features/currencies/core/data/models/currency.dart';
import 'package:linum/features/currencies/core/presentation/widgets/currency_list_tile.dart';
import 'package:linum/features/currencies/settings/presentation/currency_settings_service.dart';
import 'package:linum/features/currencies/settings/presentation/widgets/curreny_list_view.dart';
import 'package:linum/generated/translation_keys.g.dart';
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
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              useSafeArea: true,
              context: context,
              builder: (BuildContext context) {
                return LinumBottomSheet(
                  title: tr(translationKeys.actionLip.standardCurrency.labelTitle),
                  body: CurrencyListView(),
                );
              },
            );
          },
          child: Selector<ICurrencySettingsService, Currency>(
            selector: (_, settings) => settings.getStandardCurrency(),
            builder: (context, currency, _) {
              return CurrencyListTile(
                currency: currency,
                displayTrailing: true,
              );
            },
          ),
        ),
      ],
    );
  }
}
