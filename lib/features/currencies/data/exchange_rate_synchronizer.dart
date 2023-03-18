import 'package:linum/features/currencies/data/exchange_rate_api.dart';
import 'package:linum/features/currencies/models/exchange_rates_for_date.dart';
import 'package:linum/objectbox.g.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExchangeRateSynchronizer {
  final Box<ExchangeRatesForDate> _box;
  final Future<SharedPreferences> _prefs =  SharedPreferences.getInstance();

  ExchangeRateSynchronizer(this._box);

  Future<void> sync() async {
    final today = DateTime.now(); // TODO: Check timezone
    final lastEntryDate = (await _prefs).getInt('lastExchangeRateDate');

    final rates = _box.getAll();
    if (rates.isEmpty) {
      await _handleEmptyDatabase(today);
      return;
    }

    if (lastEntryDate == null) {
      final lastEntry = _findLastEntry(rates);
      await _syncToLatest(lastEntry.dateTime, today);
    } else {
      var lastEntry = _box.get(lastEntryDate);

      lastEntry ??= _findLastEntry(rates);

      await _syncToLatest(lastEntry.dateTime, today);
    }
  }

  ExchangeRatesForDate _findLastEntry(List<ExchangeRatesForDate> rates) {
    rates.sort((a, b) => a.date.compareTo(b.date)); // TODO: Direction Ascending or Descending?
    return rates.last;
  }

  Future<void> _syncToLatest(DateTime last, DateTime today) async {
    try {
      final rates = await fetchExchangeRatesForTimeSpan(last, today);
      _box.putMany(rates);
      (await _prefs).setInt('lastExchangeRateDate', rates.last.date);
    } catch(e) {
      // TODO: Handle error
    }
  }

  Future<void> _handleEmptyDatabase(DateTime today) async {
    try {
      final rates = await fetchExchangeRatesUntil(today);
      _box.putMany(rates);
      (await _prefs).setInt('lastExchangeRateDate', rates.last.date);
    } catch(e) {
      // TODO: Handle error
    }
  }
}
