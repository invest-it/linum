import 'package:linum/core/balance/domain/models/transaction.dart';
import 'package:linum/features/currencies/core/data/models/exchange_rates_for_date.dart';
import 'package:linum/features/currencies/core/domain/exchange_rate_repository.dart';
import 'package:linum/features/currencies/core/utils/int_list_extensions.dart';

class ExchangeRateFetcher {
  final IExchangeRateRepository _repository;

  ExchangeRateFetcher(this._repository);

  Future<Map<int, ExchangeRatesForDate>> getExchangeRates(List<Transaction> transactions) async {
    final dates = <DateTime>[];

    for (final transaction in transactions) {

      var date = transaction.date;

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

  Future<ExchangeRatesForDate?> findMostFittingExchangeRates(
      Transaction transaction,
      Map<int, ExchangeRatesForDate> ratesMap,
      List<int> sortedKeys,
      ) async {

    final dateTime = transaction.date;
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
    if ((exchangeRates == null || exchangeRates.rates == null) && transaction.date.isBefore(DateTime.now())) {
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
}
