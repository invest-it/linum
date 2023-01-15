import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ExchangeRatesForDate {
  ExchangeRatesForDate(this.date);

  @Id(assignable: true)
  int date;
  Map<String, String>? rates;

  factory ExchangeRatesForDate.fromJson(Map<String, dynamic> json) {
    final dateStr = json["date"] as String;
    final date = DateFormat("yyyy-MM-dd").parse(dateStr);
    final exRateForDate = ExchangeRatesForDate(date.millisecondsSinceEpoch);
    exRateForDate.rates = (json["exchange_rates"] as Map<String, dynamic>)
        .map((key, value) => MapEntry(key, value as String));
    return exRateForDate;
  }

  String? get dbRates => rates == null ? null : jsonEncode(rates);
  set dbRates(String? value) {
    if (value == null) {
      rates = null;
    } else {
      rates = (jsonDecode(value) as Map<String, dynamic>).map((key, value) => MapEntry(key, value as String));
    }
  }

  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(date);
}
