import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:linum/core/balance/models/transaction.dart';
import 'package:linum/features/currencies/core/data/models/currency.dart';
import 'package:linum/features/currencies/core/data/models/exchange_rate_info.dart';
import 'package:linum/features/currencies/core/data/models/exchange_rates_for_date.dart';
import 'package:linum/features/currencies/core/domain/exchange_rate_fetcher.dart';
import 'package:linum/features/currencies/core/presentation/exchange_rate_service.dart';
import 'package:linum/features/currencies/settings/presentation/currency_settings_service.dart';

class ExchangeRateServiceImpl extends ChangeNotifier implements IExchangeRateService {
  final ExchangeRateFetcher _fetcher;
  final ICurrencySettingsService _settings;

  ExchangeRateServiceImpl(this._settings, this._fetcher);

  @override
  Currency get standardCurrency => _settings.getStandardCurrency();


  @override
  Future addExchangeRatesToTransactions(List<Transaction> transactions) async {
    // Get dates for transactions that need exchange rates (currency != standardCurrency)

    final ratesMap = await _fetcher.getExchangeRates(transactions);

    if (ratesMap.isEmpty) {
      return;
    }

    final sortedKeys = ratesMap.keys.sorted((a, b) => a.compareTo(b));

    for (final transaction in transactions) {
      if (transaction.currency == standardCurrency.name) {
        continue;
      }

      final exchangeRates = await _fetcher.findMostFittingExchangeRates(transaction, ratesMap, sortedKeys);
      if (exchangeRates == null) {
        continue;
      }

      _addRateToTransaction(transaction, exchangeRates);
    }
  }

  void _addRateToTransaction(Transaction transaction, ExchangeRatesForDate exchangeRates) {
    // Always compared to EUR
    final transactionCurrencyRate = exchangeRates.rates?[transaction.currency]
        ?? (transaction.currency == "EUR" ? "1" : null); // FOR NOW
    final standardCurrencyRate = exchangeRates.rates?[standardCurrency.name]
        ?? "1";

    if (transactionCurrencyRate == null) {
      return;
    }

    transaction.rateInfo = ExchangeRateInfo(
      num.parse(transactionCurrencyRate),
      num.parse(standardCurrencyRate),
      Timestamp.fromMillisecondsSinceEpoch(exchangeRates.date),
      isOtherDate: _getDateInMilliseconds(transaction) != exchangeRates.date,
    );
  }

  int _getDateInMilliseconds(Transaction transaction) {
    final dateTime = transaction.date.toDate();
    final sanitizedDateTime = DateTime(dateTime.year, dateTime.month, dateTime.day);
    return sanitizedDateTime.millisecondsSinceEpoch;
  }

}
