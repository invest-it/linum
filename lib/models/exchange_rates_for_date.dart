import 'package:json_annotation/json_annotation.dart';

part 'exchange_rates_for_date.g.dart';

@JsonSerializable()
class ExchangeRatesForDate {
  ExchangeRatesForDate(this.date, this.rates);

  String date;
  Map<String, String> rates;

  factory ExchangeRatesForDate.fromJson(Map<String, dynamic> json)
  => _$ExchangeRatesForDateFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangeRatesForDateToJson(this);
}
