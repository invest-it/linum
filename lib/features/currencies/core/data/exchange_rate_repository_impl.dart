import 'package:linum/features/currencies/core/data/exchange_rate_api.dart';
import 'package:linum/features/currencies/core/data/exchange_rate_synchronizer.dart';
import 'package:linum/features/currencies/core/data/models/exchange_rates_for_date.dart';
import 'package:linum/features/currencies/core/domain/exchange_rate_repository.dart';
import 'package:linum/features/currencies/core/domain/exchange_rate_storage.dart';
import 'package:logger/logger.dart';

class ExchangeRateRepositoryImpl implements IExchangeRateRepository {
  final IExchangeRateStorage _storage;
  final ExchangeRateSynchronizer _synchronizer;

  final _logger = Logger();

  ExchangeRateRepositoryImpl(this._storage, this._synchronizer);


  @override
  Future<void> sync() async {
    await _synchronizer.sync();
  } // TODO: Call sync method on app start

  @override
  Future<ExchangeRatesForDate?> getExchangeRatesForDate(DateTime date) async {
    var rates = _storage.getExchangeRatesForDate(date);
    if (rates == null) {
      try {
        rates = await fetchExchangeRatesForDate(date);
        _storage.put(rates);
      } catch(e) {
        _logger.e(e);
        // TODO: Handle error
      }
    }
    return Future.value(rates);
  }

  @override
  Future<List<ExchangeRatesForDate>?> getExchangeRatesUntil(DateTime date) async {
    var rates = _storage.getExchangeRatesUntil(date);
    if (rates.isEmpty) {
      try {
        rates = await fetchExchangeRatesUntil(date);
        _storage.putMany(rates); // TODO: What happens when one entry already exists
      } catch(e) {
        _logger.e(e);
        // TODO: Handle error
      }
    }
    return Future.value(rates);
  }

  @override
  Future<Map<int, ExchangeRatesForDate>> getExchangeRatesForDates(List<DateTime> dates) async {
    var rates = _storage.getExchangeRatesForDates(dates);
    if (rates.isEmpty && dates.isNotEmpty) {
      dates.sort((a, b) => a.compareTo(b));
      try {
        rates = await fetchExchangeRatesForTimeSpan(dates.first, dates.last);
        _storage.putMany(rates);
      } catch(e) {
        _logger.e(e);
        // TODO: Handle error
      }
    }
    final ratesMap = <int, ExchangeRatesForDate>{};
    for (final rate in rates) {
      ratesMap[rate.date] = rate;
    }
    return Future.value(ratesMap);
  }

  @override
  Future<List<ExchangeRatesForDate>?> getExchangeRatesForTimeSpan(DateTime earliest, DateTime latest) async {
    var rates = _storage.getExchangeRatesForTimeSpan(earliest, latest);
    if (rates.isEmpty) {
      try {
        rates = await fetchExchangeRatesForTimeSpan(earliest, latest);
        _storage.putMany(rates);
      } catch(e) {
        _logger.e(e);
        // TODO: Handle error
      }
    }

    return Future.value(rates);
  }
}
