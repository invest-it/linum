import 'package:flutter/material.dart';
import 'package:linum/common/utils/currency_formatter.dart';



class StyledAmount extends StatelessWidget {
  final String symbol;
  final TextAlign txtAlign;
  final StyledFontSize fontSize;
  final StyledFontPrefix fontPrefix;
  final num value;
  late final bool _isNegative;
  late final CurrencyFormatter _formatter;

  StyledAmount({
    required this.value,
    required Locale locale,
    required this.symbol,
    this.fontSize = StyledFontSize.standard,
    this.txtAlign = TextAlign.center,
    this.fontPrefix = StyledFontPrefix.none,
  }) {
    _formatter = CurrencyFormatter(locale, symbol: symbol);
    _isNegative =
        (fontPrefix == StyledFontPrefix.alwaysNegative) || (value < 0);
  }

  /// Helper Method to inject a "+" or "-" sign into the styled amount. However, the minus prefix is only inserted in the edge case should [value] equal zero, as in any other case, it will already have a minus prefix.
  TextSpan _buildZeroPrefix(TextStyle? posTextTheme, TextStyle? negTextTheme) {
    assert(value >= 0);
    if (fontPrefix == StyledFontPrefix.alwaysNegative && value == 0) {
      return TextSpan(
        text: '-',
        style: negTextTheme,
      );
    } else {
      return TextSpan(
        text: '+',
        style: posTextTheme,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final RegExp exp = RegExp('(-?[0-9]+)([,.](?:[0-9]+))');
    final expMatch = exp.firstMatch(_formatter.format(value));

    TextStyle? normalFontTheme;
    TextStyle? smallFontTheme;
    TextStyle? normalFontThemeNeg;
    TextStyle? smallFontThemeNeg;

    switch (fontSize) {
      case StyledFontSize.standard:
        normalFontTheme = Theme.of(context).textTheme.displaySmall;
        smallFontTheme = Theme.of(context).textTheme.headlineMedium;
        normalFontThemeNeg = Theme.of(context)
            .textTheme
            .displaySmall
            ?.copyWith(color: Theme.of(context).colorScheme.error);
        smallFontThemeNeg = Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(color: Theme.of(context).colorScheme.error);
        break;
      case StyledFontSize.compact:
        normalFontTheme = Theme.of(context).textTheme.headlineMedium;
        smallFontTheme = Theme.of(context).textTheme.headlineSmall;
        normalFontThemeNeg = Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(color: Theme.of(context).colorScheme.error);
        smallFontThemeNeg = Theme.of(context)
            .textTheme
            .headlineSmall
            ?.copyWith(color: Theme.of(context).colorScheme.error);
        break;
      case StyledFontSize.maximize:
        normalFontTheme = Theme.of(context).textTheme.displayMedium?.copyWith(
              fontSize: 39.81,
            );
        smallFontTheme = Theme.of(context).textTheme.displayMedium;
        normalFontThemeNeg = Theme.of(context).textTheme.displayMedium?.copyWith(
              color: Theme.of(context).colorScheme.error,
              fontSize: 39.81,
            );
        smallFontThemeNeg = Theme.of(context)
            .textTheme
            .displayMedium
            ?.copyWith(color: Theme.of(context).colorScheme.error);
        break;
    }

    if (_formatter.amountBeforeSymbol()) {
      //Euro Case
      return Align(
        child: RichText(
          textAlign: txtAlign,
          maxLines: 1,
          text: TextSpan(
            children: [
              if (fontPrefix != StyledFontPrefix.none && value >= 0)
                _buildZeroPrefix(normalFontTheme, normalFontThemeNeg),
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
            if (fontPrefix != StyledFontPrefix.none && value >= 0)
              _buildZeroPrefix(normalFontTheme, normalFontThemeNeg),
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

enum StyledFontPrefix {
  none,
  alwaysNegative,
  alwaysPositive,
}
