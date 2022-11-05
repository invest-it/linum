import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CurrencyFormatter {
  final String symbol;
  late final NumberFormat _formatter;
  CurrencyFormatter(Locale locale, {this.symbol = "€"}) {
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
}
