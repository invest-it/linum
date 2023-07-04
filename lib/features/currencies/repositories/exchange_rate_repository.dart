import 'package:linum/features/currencies/data/exchange_rate_api.dart';
import 'package:linum/features/currencies/data/exchange_rate_synchronizer.dart';
import 'package:linum/features/currencies/models/exchange_rates_for_date.dart';
import 'package:linum/generated/objectbox/objectbox.g.dart';
import 'package:logger/logger.dart';

class ExchangeRateRepository {
  final Box<ExchangeRatesForDate> _box;
  late final ExchangeRateSynchronizer _synchronizer;

  final logger = Logger();

  ExchangeRateRepository(Store store) : _box = store.box() {
    _synchronizer = ExchangeRateSynchronizer(_box);
  }

  /*
  Future<void> _addExchangeRatesForDate() async {
    throw UnimplementedError();
  }

  Future<void> _addMultipleExchangeRatesForDate() async {
    throw UnimplementedError();
  }
  */

  Future<void> sync() async {
    _synchronizer.sync();
  } // TODO: Call sync method on app start

  Future<ExchangeRatesForDate?> getExchangeRatesForDate(DateTime date) async {
    final sanitizedDate = DateTime(date.year, date.month, date.day);
    var rates = _box.get(sanitizedDate.millisecondsSinceEpoch);
    if (rates == null) {
      try {
        rates = await fetchExchangeRatesForDate(date);
        _box.put(rates);
      } catch(e) {
        // TODO: Handle error
      }
    }
    return Future.value(rates);
  }

  Future<List<ExchangeRatesForDate>?> getExchangeRatesUntil(DateTime date) async {
    final query = _box.query(
      ExchangeRatesForDate_.date.lessOrEqual(date.millisecondsSinceEpoch),
    ).build();
    var rates = query.find();
    if (rates.isEmpty) {
      try {
        rates = await fetchExchangeRatesUntil(date);
        _box.putMany(rates); // TODO: What happens when one entry already exists
      } catch(e) {
        logger.e(e);
        // TODO: Handle error
      }
    }
    return Future.value(rates);
  }

  Future<Map<int, ExchangeRatesForDate>> getExchangeRatesForDates(List<DateTime> dates) async {
    final sanitizedDates = dates.map((e) => DateTime(e.year, e.month, e.day).millisecondsSinceEpoch).toSet().toList();
    final query = _box.query(
      ExchangeRatesForDate_.date.oneOf(sanitizedDates),
    ).build();
    var rates = query.find();
    if (rates.isEmpty && dates.isNotEmpty) {
      dates.sort((a, b) => a.compareTo(b));
      try {
        rates = await fetchExchangeRatesForTimeSpan(dates.first, dates.last);
        _box.putMany(rates);
      } catch(e) {
        logger.e(e);
        // TODO: Handle error
      }
    }
    final ratesMap = <int, ExchangeRatesForDate>{};
    for (final rate in rates) {
      ratesMap[rate.date] = rate;
    }
    return Future.value(ratesMap);
  }

  Future<List<ExchangeRatesForDate>?> getExchangeRatesForTimeSpan(DateTime earliest, DateTime latest) async {
    final sanitizedEarliest = DateTime(earliest.year, earliest.month, earliest.day);
    final query = _box.query(
      ExchangeRatesForDate_.date.lessOrEqual(latest.millisecondsSinceEpoch)
      & ExchangeRatesForDate_.date.greaterOrEqual(sanitizedEarliest.millisecondsSinceEpoch), // TODO: gt or gte?
    ).build();
    var rates = query.find();
    if (rates.isEmpty) {
      try {
        rates = await fetchExchangeRatesForTimeSpan(earliest, latest);
        _box.putMany(rates);
      } catch(e) {
        logger.e(e);
        // TODO: Handle error
      }
    }

    return Future.value(rates);
  }
}
