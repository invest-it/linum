import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/models/entry_category.dart';
import 'package:linum/models/entry_currency.dart';

class CurrencyListTile extends StatelessWidget {
  const CurrencyListTile({
    super.key,
    required this.currency,
    required this.labelTitle,
    required this.defaultLabel,
  });
  final String labelTitle;
  final String defaultLabel;
  final EntryCurrency? currency;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        labelTitle +
            // Translates the value from firebase
            tr(currency?.label ?? defaultLabel),
        style: Theme.of(context).textTheme.bodyText1,
      ),
      trailing: const Icon(
        Icons.arrow_forward,
      ),
      leading: Icon(
        currency?.icon ?? Icons.error,
      ),
    );
  }
}
