import 'package:linum/features/currencies/core/data/models/exchange_rates_for_date.dart';

abstract class IExchangeRateRepository {
  Future<void> sync();
  Future<ExchangeRatesForDate?> getExchangeRatesForDate(DateTime date);
  Future<List<ExchangeRatesForDate>?> getExchangeRatesUntil(DateTime date);
  Future<Map<int, ExchangeRatesForDate>> getExchangeRatesForDates(List<DateTime> dates);
  Future<List<ExchangeRatesForDate>?> getExchangeRatesForTimeSpan(DateTime earliest, DateTime latest);
}
