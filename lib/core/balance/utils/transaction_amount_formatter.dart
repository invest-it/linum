import 'package:flutter/material.dart';
import 'package:linum/core/balance/models/transaction.dart';
import 'package:linum/features/currencies/core/constants/standard_currencies.dart';
import 'package:linum/features/currencies/core/data/exchange_rate_converter.dart';
import 'package:linum/features/currencies/core/data/models/currency.dart';
import 'package:linum/features/currencies/core/utils/currency_formatter.dart';

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
      final formatted = CurrencyFormatter(locale, symbol: standardCurrency.symbol)
          .format(convertCurrencyAmountWithExchangeRate(transaction.amount, rateInfo));
      if (transaction.rateInfo!.isOtherDate) {
        return "($formatted)";
      }
      return formatted;
    }

    // Inform the user about the missing rate
    return CurrencyFormatter(locale, symbol: currency.symbol).format(transaction.amount);
  }
}
