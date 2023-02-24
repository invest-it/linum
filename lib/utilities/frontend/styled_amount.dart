import 'package:flutter/material.dart';
import 'package:linum/utilities/frontend/currency_formatter.dart';

class StyledAmount extends StatelessWidget {
  late final String _formatted;
  final String symbol;
  late final bool _euroMode;

  StyledAmount(num value, Locale locale, this.symbol) {
    _formatted = CurrencyFormatter(locale, symbol: symbol).format(value);
    _euroMode = CurrencyFormatter(locale, symbol: symbol).amountBeforeSymbol();
  }

  @override
  Widget build(BuildContext context) {
    final RegExp exp = RegExp('(-?[0-9]+)([,.](?:[0-9]+))');
    final expMatch = exp.firstMatch(_formatted);

    if (_euroMode) {
      //Euro Case
      return RichText(
        maxLines: 1,
        text: TextSpan(
          children: [
            TextSpan(text: expMatch?.group(1) ?? "??"),
            TextSpan(text: expMatch?.group(2) ?? ".??"),
            TextSpan(text: symbol),
          ],
          style: Theme.of(context).textTheme.bodyText2,
        ),
      );
    } else {
      //World Case
      return RichText(
        maxLines: 1,
        text: TextSpan(
          children: [
            TextSpan(text: symbol),
            TextSpan(text: expMatch?.group(1) ?? "??"),
            TextSpan(text: expMatch?.group(2) ?? ".??"),
          ],
          style: Theme.of(context).textTheme.bodyText2,
        ),
      );
    }
  }
}
