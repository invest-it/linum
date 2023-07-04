import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:linum/core/account/services/account_settings_service.dart';
import 'package:linum/core/balance/models/transaction.dart';
import 'package:linum/features/currencies/models/currency.dart';
import 'package:linum/features/currencies/models/exchange_rate_info.dart';
import 'package:linum/features/currencies/models/exchange_rates_for_date.dart';
import 'package:linum/features/currencies/repositories/exchange_rate_repository.dart';
import 'package:linum/features/currencies/utils/int_list_extensions.dart';
import 'package:linum/generated/objectbox/objectbox.g.dart';
import 'package:provider/provider.dart';

class ExchangeRateService extends ChangeNotifier {
  late final ExchangeRateRepository _repository;
  final Store _store;
  late AccountSettingsService _settings;
  ExchangeRateService(BuildContext context, this._store) {
    _repository = ExchangeRateRepository(_store);
    _settings = context.read<AccountSettingsService>();


  }

  Currency get standardCurrency => _settings.getStandardCurrency();

  Future<Map<int, ExchangeRatesForDate>> _getExchangeRates(List<Transaction> transactions) async {
    final dates = <DateTime>[];

    for (final transaction in transactions) {

      var date = transaction.date.toDate();

      final today = DateTime.now();
      final todaySanitized = DateTime(today.year, today.month, today.day);
      if (date.millisecondsSinceEpoch > todaySanitized.millisecondsSinceEpoch) {
        date = todaySanitized.subtract(const Duration(days: 1));
      }

      if (date.weekday == DateTime.sunday) {
        date = date.subtract(const Duration(days: 2));
      }
      if (date.weekday == DateTime.saturday) {
        date = date.subtract(const Duration(days: 1));
      }

      dates.add(date);
    }

    return _repository.getExchangeRatesForDates(dates);
  }

  Future<ExchangeRatesForDate?> _findMostFittingExchangeRates(
      Transaction transaction,
      Map<int, ExchangeRatesForDate> ratesMap,
      List<int> sortedKeys,
  ) async {

    final dateTime = transaction.date.toDate();
    final today = DateTime.now();
    final todaySanitized = DateTime(today.year, today.month, today.day);
    var sanitizedDateTime = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (dateTime.isAfter(todaySanitized.subtract(const Duration(days: 1)))) {
      sanitizedDateTime = todaySanitized.subtract(const Duration(days: 1));
    }
    if (dateTime.weekday == DateTime.sunday) {
      sanitizedDateTime = sanitizedDateTime.subtract(const Duration(days: 2));
    }
    if (dateTime.weekday == DateTime.saturday) {
      sanitizedDateTime = sanitizedDateTime.subtract(const Duration(days: 1));
    }

    var key = sanitizedDateTime.millisecondsSinceEpoch;
    var exchangeRates = ratesMap[key];

    // Still necessary, due to the possibility of missing rates;
    if ((exchangeRates == null || exchangeRates.rates == null) && transaction.date.toDate().isBefore(DateTime.now())) {
      exchangeRates = await _repository.getExchangeRatesForDate(sanitizedDateTime);
    }


    if (exchangeRates == null) {
      var lastSmallerIndex = sortedKeys.lastSmallerIndex(key);
      if (lastSmallerIndex == -1) {
        lastSmallerIndex = 0;
      }
      key = sortedKeys[lastSmallerIndex];
      return ratesMap[key];
    }

    return exchangeRates;
  }

  Future addExchangeRatesToTransactions(List<Transaction> transactions) async {
    // Get dates for transactions that need exchange rates (currency != standardCurrency)

    final ratesMap = await _getExchangeRates(transactions);

    if (ratesMap.isEmpty) {
      return;
    }

    final sortedKeys = ratesMap.keys.sorted((a, b) => a.compareTo(b));


    for (final transaction in transactions) {
      if (transaction.currency == standardCurrency.name) {
        continue;
      }

      final exchangeRates = await _findMostFittingExchangeRates(transaction, ratesMap, sortedKeys);
      if (exchangeRates == null) {
        continue;
      }

      // Always compared to EUR
      final transactionCurrencyRate = exchangeRates.rates?[transaction.currency]
        ?? (transaction.currency == "EUR" ? "1" : null); // FOR NOW
      final standardCurrencyRate = exchangeRates.rates?[standardCurrency.name];

      if (transactionCurrencyRate != null) {
        final dateTime = transaction.date.toDate();
        final sanitizedDateTime = DateTime(dateTime.year, dateTime.month, dateTime.day);
        final dateInMs = sanitizedDateTime.millisecondsSinceEpoch;
        transaction.rateInfo = ExchangeRateInfo(
          num.parse(transactionCurrencyRate),
          num.parse(standardCurrencyRate ?? "1"),
           Timestamp.fromMillisecondsSinceEpoch(exchangeRates.date),
          isOtherDate: dateInMs != exchangeRates.date,
        );
        continue;
      }


    }
  }

  void update(AccountSettingsService settings) {
    _settings = settings;
    // TODO: Do this better
  }

}
