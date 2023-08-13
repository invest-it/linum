import 'package:linum/features/currencies/core/data/models/exchange_rates_for_date.dart';

abstract class IExchangeRateStorage {
  List<ExchangeRatesForDate> getExchangeRatesForTimeSpan(
      DateTime earliest,
      DateTime latest,
  );

  List<ExchangeRatesForDate> getExchangeRatesForDates(List<DateTime> dates);

  List<ExchangeRatesForDate> getExchangeRatesUntil(DateTime date);

  ExchangeRatesForDate? getExchangeRatesForDate(DateTime date);

  List<int> putMany(List<ExchangeRatesForDate> ratesList);
  int put(ExchangeRatesForDate rates);
}
