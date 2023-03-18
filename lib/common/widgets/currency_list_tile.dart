import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/widgets/text_icon.dart';
import 'package:linum/features/currencies/models/currency.dart';

// ignore_for_file: deprecated_member_use
//TODO DEPRECATED

class CurrencyListTile extends StatelessWidget {
  const CurrencyListTile({
    super.key,
    required this.currency,
    this.onTap,
    this.selected = false,
    this.displayTrailing = false,
  });
  final Currency currency;
  final void Function()? onTap;
  final bool selected;
  final bool displayTrailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        "${tr(currency.label)} (${currency.symbol})",
        style: Theme.of(context).textTheme.bodyText1,
      ),
      trailing: displayTrailing ? const Icon(
        Icons.arrow_forward,
      ) : null,
      leading: TextIcon(currency.name),
      selected: selected,
      onTap: onTap,
    );
  }
}
