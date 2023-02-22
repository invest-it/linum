import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
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
      final splits = _formatter.format(value).split();

      return RichText(
        text: TextSpan(
          children: [
            TextSpan(),
            TextSpan(),
            TextSpan(),
          ],
        ),
      );
    }
  }
}
