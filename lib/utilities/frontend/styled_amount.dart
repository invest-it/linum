import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:linum/utilities/frontend/currency_formatter.dart';

class StyledAmount extends StatelessWidget {
  late final CurrencyFormatter _formatter;
  final num value;

  StyledAmount(this.value, Locale locale, String symbol) {
    _formatter = CurrencyFormatter(locale, symbol: symbol);
  }

  @override
  Widget build(BuildContext context) {
    if (_formatter.amountBeforeSymbol()) {
      //Euro Case
      return Text(_formatter.format(value));
    } else {
      //World Case
      final RegExp exp = RegExp(r'(\p{Sc})(-?[0-9]+)([,.](?:[0-9]{1,2})?)');
      final splits = exp
          .allMatches(_formatter.format(value))
          .map((e) => e.group(0))
          .toList();

      dev.log(splits.toString());

      return RichText(
        maxLines: 1,
        text: TextSpan(
          children: splits.map((e) => TextSpan(text: e)).toList(),
          style: Theme.of(context).textTheme.bodyText2,
        ),
      );
    }
  }
}
