// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_rates_for_date.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExchangeRatesForDate _$ExchangeRatesForDateFromJson(
        Map<String, dynamic> json) =>
    ExchangeRatesForDate(
      json['date'] as String,
      Map<String, String>.from(json['rates'] as Map),
    );

Map<String, dynamic> _$ExchangeRatesForDateToJson(
        ExchangeRatesForDate instance) =>
    <String, dynamic>{
      'date': instance.date,
      'rates': instance.rates,
    };
