import 'package:flutter/material.dart';
import 'package:linum/utilities/frontend/currency_formatter.dart';

class StyledAmount extends StatelessWidget {
  final String symbol;
  final TextAlign txtAlign;
  final StyledFontSize fontSize;
  late final bool _euroMode;
  late final bool _isNegative;
  late final num value;
  late final String _formatted;

  StyledAmount(
    this.value,
    Locale locale,
    this.symbol, {
    this.fontSize = StyledFontSize.standard,
    this.txtAlign = TextAlign.center,
    bool alwaysNegative = false,
  }) {
    _formatted = CurrencyFormatter(locale, symbol: symbol).format(value);
    _euroMode = CurrencyFormatter(locale, symbol: symbol).amountBeforeSymbol();
    _isNegative = alwaysNegative || value < 0;
  }

  @override
  Widget build(BuildContext context) {
    final RegExp exp = RegExp('(-?[0-9]+)([,.](?:[0-9]+))');
    final expMatch = exp.firstMatch(_formatted);

    TextStyle? normalFontTheme;
    TextStyle? smallFontTheme;
    TextStyle? normalFontThemeNeg;
    TextStyle? smallFontThemeNeg;

    switch (fontSize) {
      case StyledFontSize.standard:
        normalFontTheme = Theme.of(context).textTheme.headline3;
        smallFontTheme = Theme.of(context).textTheme.headline4;
        normalFontThemeNeg = Theme.of(context)
            .textTheme
            .headline3
            ?.copyWith(color: Theme.of(context).colorScheme.error);
        smallFontThemeNeg = Theme.of(context)
            .textTheme
            .headline4
            ?.copyWith(color: Theme.of(context).colorScheme.error);
        break;
      case StyledFontSize.compact:
        normalFontTheme = Theme.of(context).textTheme.headline4;
        smallFontTheme = Theme.of(context).textTheme.headline5;
        normalFontThemeNeg = Theme.of(context)
            .textTheme
            .headline4
            ?.copyWith(color: Theme.of(context).colorScheme.error);
        smallFontThemeNeg = Theme.of(context)
            .textTheme
            .headline5
            ?.copyWith(color: Theme.of(context).colorScheme.error);
        break;
      case StyledFontSize.maximize:
        normalFontTheme = Theme.of(context).textTheme.headline2?.copyWith(
              fontSize: 39.81,
            );
        smallFontTheme = Theme.of(context).textTheme.headline2;
        normalFontThemeNeg = Theme.of(context).textTheme.headline2?.copyWith(
              color: Theme.of(context).colorScheme.error,
              fontSize: 39.81,
            );
        smallFontThemeNeg = Theme.of(context)
            .textTheme
            .headline2
            ?.copyWith(color: Theme.of(context).colorScheme.error);
        break;
    }

    if (_euroMode) {
      //Euro Case
      return Align(
        child: RichText(
          textAlign: txtAlign,
          maxLines: 1,
          text: TextSpan(
            children: [
              if (_isNegative && value == 0)
                TextSpan(text: '-', style: normalFontThemeNeg),
              TextSpan(
                text: expMatch?.group(1) ?? "??",
                style: _isNegative ? normalFontThemeNeg : normalFontTheme,
              ),
              TextSpan(
                text: expMatch?.group(2) ?? ".??",
                style: _isNegative ? smallFontThemeNeg : smallFontTheme,
              ),
              TextSpan(
                text: symbol,
                style: _isNegative ? normalFontThemeNeg : normalFontTheme,
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
              style: _isNegative ? normalFontThemeNeg : normalFontTheme,
            ),
            if (_isNegative && value == 0)
              TextSpan(text: '-', style: normalFontThemeNeg),
            TextSpan(
              text: expMatch?.group(1) ?? "??",
              style: _isNegative ? normalFontThemeNeg : normalFontTheme,
            ),
            TextSpan(
              text: expMatch?.group(2) ?? ".??",
              style: _isNegative ? smallFontThemeNeg : smallFontTheme,
            ),
          ],
        ),
      );
    }
  }
}

enum StyledFontSize {
  standard,
  compact,
  maximize,
}
