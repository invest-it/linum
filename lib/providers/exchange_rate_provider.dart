import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:flutter/cupertino.dart';
import 'package:linum/models/exchange_rate_info.dart';
import 'package:linum/models/exchange_rates_for_date.dart';
import 'package:linum/models/transaction.dart';
import 'package:linum/objectbox.g.dart';
import 'package:linum/utilities/backend/exchange_rate_repository.dart';

class ExchangeRateProvider extends ChangeNotifier {
  late final ExchangeRateRepository _repository;
  final Store _store;
  ExchangeRateProvider(this._store) : _repository = ExchangeRateRepository(_store);

  Future addExchangeRatesToBalanceData(List<Transaction> transactions) async {
    final dates = transactions.map((e) => e.time.toDate()).toList();
    final ratesMap = await _repository.getExchangeRatesForDates(dates);

    if (ratesMap.isEmpty) {
      return;
    }

    ExchangeRatesForDate lastSuccessful = ratesMap.values.first;

    for (final transaction in transactions) {
      if (transaction.currency == "EUR") {
        continue;
        // TODO: Handle default Currency settings
      }

      final dateTime = transaction.time.toDate();
      final key = DateTime(dateTime.year, dateTime.day).millisecondsSinceEpoch;
      var exchangeRates = ratesMap[key];

      if (exchangeRates == null || exchangeRates.rates == null) {
        // TODO: Handle null case
        exchangeRates = lastSuccessful;
      } else {
        lastSuccessful = exchangeRates;
      }

      final exchangeRate = exchangeRates.rates?[transaction.currency];

      if (exchangeRate != null) {
        transaction.rateInfo = ExchangeRateInfo(
            int.parse(exchangeRate),
            firestore.Timestamp.fromMillisecondsSinceEpoch(exchangeRates.date),
            isOtherDate: key != exchangeRates.date,
        );
        continue;
      }

      // TODO: Check if entry exists and re-fetch
      // TODO: Make call to another API to get rate
    }
  }

}
