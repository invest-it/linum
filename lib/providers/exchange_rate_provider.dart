import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:linum/models/exchange_rate_info.dart';
import 'package:linum/models/exchange_rates_for_date.dart';
import 'package:linum/models/single_balance_data.dart';
import 'package:linum/objectbox.g.dart';
import 'package:linum/utilities/backend/exchange_rate_repository.dart';

class ExchangeRateProvider extends ChangeNotifier {
  late final ExchangeRateRepository _repository;
  final Store _store;
  ExchangeRateProvider(this._store) : _repository = ExchangeRateRepository(_store);

  @override
  void dispose() {
    _store.close();
    super.dispose();
  }

  Future addExchangeRatesToBalanceData(List<SingleBalanceData> balanceData) async {
    final dates = balanceData.map((e) => e.time.toDate()).toList();
    final ratesMap = await _repository.getExchangeRatesForDates(dates);

    if (ratesMap.isEmpty) {
      return;
    }

    ExchangeRatesForDate lastSuccessful = ratesMap.values.first;

    for (final balanceEntry in balanceData) {
      final dateTime = balanceEntry.time.toDate();
      final key = DateTime(dateTime.year, dateTime.day).millisecondsSinceEpoch;
      var exchangeRates = ratesMap[key];

      if (exchangeRates == null || exchangeRates.rates == null) {
        // TODO: Handle null case
        exchangeRates = lastSuccessful;
      } else {
        lastSuccessful = exchangeRates;
      }

      final exchangeRate = exchangeRates.rates?[balanceEntry.currency];

      if (exchangeRate != null) {
        balanceEntry.rateInfo = ExchangeRateInfo(
            int.parse(exchangeRate),
            Timestamp.fromMillisecondsSinceEpoch(exchangeRates.date),
            isOtherDate: key != exchangeRates.date,
        );
        continue;
      }

      // TODO: Check if entry exists and re-fetch
      // TODO: Make call to another API to get rate
    }
  }

}
