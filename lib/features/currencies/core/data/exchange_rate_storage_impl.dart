import 'package:linum/features/currencies/core/data/models/exchange_rates_for_date.dart';
import 'package:linum/features/currencies/core/domain/exchange_rate_storage.dart';
import 'package:linum/generated/objectbox/objectbox.g.dart';

class ExchangeRateStorageImpl implements IExchangeRateStorage {
  final Box<ExchangeRatesForDate> _box;
  ExchangeRateStorageImpl(Store store) : _box = store.box();

  @override
  ExchangeRatesForDate? getExchangeRatesForDate(DateTime date) {
    final sanitizedDate = DateTime(date.year, date.month, date.day);
    return _box.get(sanitizedDate.millisecondsSinceEpoch);
  }

  @override
  List<ExchangeRatesForDate> getExchangeRatesForDates(List<DateTime> dates) {
    final sanitizedDates = dates.map((e) => DateTime(e.year, e.month, e.day).millisecondsSinceEpoch).toSet().toList();
    final query = _box.query(
      ExchangeRatesForDate_.date.oneOf(sanitizedDates),
    ).build();
    return findAndClose(query);
  }

  @override
  List<ExchangeRatesForDate> getExchangeRatesForTimeSpan(DateTime earliest, DateTime latest) {
    final sanitizedEarliest = DateTime(earliest.year, earliest.month, earliest.day);
    final query = _box.query(
      ExchangeRatesForDate_.date.lessOrEqual(latest.millisecondsSinceEpoch)
      & ExchangeRatesForDate_.date.greaterOrEqual(sanitizedEarliest.millisecondsSinceEpoch), // TODO: gt or gte?
    ).build();

    return findAndClose(query);
  }

  @override
  List<ExchangeRatesForDate> getExchangeRatesUntil(DateTime date) {
    final query = _box.query(
      ExchangeRatesForDate_.date.lessOrEqual(date.millisecondsSinceEpoch),
    ).build();
    return findAndClose(query);
  }


  List<T> findAndClose<T>(Query<T> query) {
    final rates = query.find();
    query.close();
    return rates;
  }

  @override
  int put(ExchangeRatesForDate rates) {
    return _box.put(rates);
  }

  @override
  List<int> putMany(List<ExchangeRatesForDate> ratesList) {
    return _box.putMany(ratesList);
  }
}
