import 'package:flutter/material.dart';
import 'package:linum/utilities/frontend/currency_formatter.dart';

class StyledAmount extends StatelessWidget {
  final String symbol;
  final TextAlign txtAlign;
  late final bool _euroMode;
  late final bool _isNegative;
  late final String _formatted;

  StyledAmount(
    num value,
    Locale locale,
    this.symbol, {
    this.txtAlign = TextAlign.center,
  }) {
    _formatted = CurrencyFormatter(locale, symbol: symbol).format(value);
    _euroMode = CurrencyFormatter(locale, symbol: symbol).amountBeforeSymbol();
    _isNegative = value < 0;
  }

  @override
  Widget build(BuildContext context) {
    final RegExp exp = RegExp('(-?[0-9]+)([,.](?:[0-9]+))');
    final expMatch = exp.firstMatch(_formatted);
    final _regularTheme3 = Theme.of(context).textTheme.headline3;
    final _regularTheme4 = Theme.of(context).textTheme.headline4;
    final _errorTheme3 = Theme.of(context)
        .textTheme
        .headline3
        ?.copyWith(color: Theme.of(context).colorScheme.error);
    final _errorTheme4 = Theme.of(context)
        .textTheme
        .headline4
        ?.copyWith(color: Theme.of(context).colorScheme.error);

    if (_euroMode) {
      //Euro Case
      return Align(
        child: RichText(
          textAlign: txtAlign,
          maxLines: 1,
          text: TextSpan(
            children: [
              TextSpan(
                text: expMatch?.group(1) ?? "??",
                style: _isNegative ? _errorTheme3 : _regularTheme3,
              ),
              TextSpan(
                text: expMatch?.group(2) ?? ".??",
                style: _isNegative ? _errorTheme4 : _regularTheme4,
              ),
              TextSpan(
                text: symbol,
                style: _isNegative ? _errorTheme3 : _regularTheme3,
              ),
            ],
          ),
        ),
      );
    } else {
      //World Case
      return RichText(
        textAlign: txtAlign,
        maxLines: 1,
        text: TextSpan(
          children: [
            TextSpan(
              text: symbol,
              style: _isNegative ? _errorTheme3 : _regularTheme3,
            ),
            TextSpan(
              text: expMatch?.group(1) ?? "??",
              style: _isNegative ? _errorTheme3 : _regularTheme3,
            ),
            TextSpan(
              text: expMatch?.group(2) ?? ".??",
              style: _isNegative ? _errorTheme4 : _regularTheme4,
            ),
          ],
        ),
      );
    }
  }
}
