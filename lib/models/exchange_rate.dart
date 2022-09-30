import 'package:json_annotation/json_annotation.dart';

part 'exchange_rate.g.dart';


@JsonSerializable()
class ExchangeRate {
  ExchangeRate(this.currency, this.rate, this.date);

  String currency;
  double rate;
  String date;

  factory ExchangeRate.fromJson(Map<String, dynamic> json)
    => _$ExchangeRateFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangeRateToJson(this);
}
