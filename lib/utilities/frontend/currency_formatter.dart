import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CurrencyFormatter {
  final String symbol;
  late final NumberFormat _formatter;
  CurrencyFormatter(Locale locale, {this.symbol = "EUR"}) {
    _formatter = NumberFormat("#0.00", locale.toString());
  }


  String format(num value) {
    final numberPart = _formatter.format(value);
    if (symbol == "€") {
      return "$numberPart $symbol";
    } else { // $, £
      return "$symbol $numberPart";
    }
  }

  bool amountBeforeSymbol() {
    if (symbol == "€") {
      return true;
    } else { // $, £
      return false;
    }
  }

  List<Widget> formatWithWidgets(
      num value,
      Widget Function(String amount) amountDisplayBuilder,
      Widget Function(String symbol) symbolDisplayBuilder,
  ) {
    if (symbol == "€") {
      return [
        amountDisplayBuilder(_formatter.format(value)),
        symbolDisplayBuilder(symbol),
      ];
    } else {
      return [
        symbolDisplayBuilder(symbol),
        amountDisplayBuilder(_formatter.format(value)),
      ];
    }

  }
}
