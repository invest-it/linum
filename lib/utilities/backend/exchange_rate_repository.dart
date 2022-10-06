import 'package:linum/models/exchange_rates_for_date.dart';
import 'package:linum/objectbox.g.dart';
import 'package:linum/utilities/backend/currency_web_functions.dart';
import 'package:linum/utilities/backend/exchange_rate_synchronizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExchangeRateRepository {
  final Store _store;
  final Box<ExchangeRatesForDate> _box;
  final Future<SharedPreferences> _prefs =  SharedPreferences.getInstance();
  late final ExchangeRateSynchronizer _synchronizer;

  ExchangeRateRepository(this._store) : _box = _store.box() {
    _synchronizer = ExchangeRateSynchronizer(_box);
  }

  Future<void> _addExchangeRatesForDate() async {
    throw UnimplementedError();
  }

  Future<void> _addMultipleExchangeRatesForDate() async {
    throw UnimplementedError();
  }

  Future<void> sync() async {
    _synchronizer.sync();
  }

  Future<ExchangeRatesForDate?> getExchangeRatesForDate(DateTime date) async {
    final sanitizedDate = DateTime(date.year, date.day);
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
        // TODO: Handle error
      }
    }
    return Future.value(rates);
  }

  Future<List<ExchangeRatesForDate>?> getExchangeRatesForTimeSpan(DateTime earliest, DateTime latest) async {
    final sanitizedEarliest = DateTime(earliest.year, earliest.day);
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
        // TODO: Handle error
      }
    }
    return Future.value(rates);
  }
}
