import 'package:flutter/material.dart';
import 'package:linum/constants/standard_currencies.dart';
import 'package:linum/models/currency.dart';
import 'package:linum/models/transaction.dart';
import 'package:linum/utilities/frontend/currency_formatter.dart';

class TransactionAmountFormatter {
  final Locale locale;
  final Currency standardCurrency;
  TransactionAmountFormatter(this.locale, this.standardCurrency);

  String format(Transaction transaction, {bool showConverted = false}) {
    final currency = standardCurrencies[transaction.currency];
    if (currency == null) {
      // TODO: see how to handle this
      throw Exception("Currency not supported");
    }

    if (!showConverted || standardCurrency.name == currency.name) {
      return CurrencyFormatter(locale, symbol: currency.symbol).format(transaction.amount);
    }

    final rateInfo = transaction.rateInfo;

    if (rateInfo != null) {
      final amountInEuro = transaction.amount / rateInfo.rate;
      return CurrencyFormatter(locale, symbol: standardCurrency.symbol)
          .format(amountInEuro * rateInfo.standardCurrencyRate);
    }

    // Inform the user about the missing rate
    return CurrencyFormatter(locale, symbol: currency.symbol).format(transaction.amount);
  }
}
