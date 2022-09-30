import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:linum/models/exchange_rate.dart';
import 'package:linum/models/exchange_rates_for_date.dart';

const webAPIUrl = "https://exchange-rates.linum.martins-lightart.de/";

Future<ExchangeRate> fetchExchangeRateForDate(DateTime date, String currency) async {
  final dateStr = DateFormat("yyyy-MM-dd").format(date);
  final uri = Uri.parse("$webAPIUrl/rate/$dateStr/$currency");
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
    // TODO: Handle errors
    return ExchangeRate.fromJson(jsonMap);
  } else {
    throw Exception("Failed to get Exchange Rate");
    // TODO: Handle error more elegantly. Use API Error Codes
  }
}

Future<List<String>> fetchSupportedCurrencies() async {
  final uri = Uri.parse("$webAPIUrl/supported");
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final jsonList = jsonDecode(response.body) as List<String>;
    // TODO: Handle errors
    return jsonList;
  } else {
    throw Exception("Failed to get supported currencies");
    // TODO: Handle error more elegantly. Use API Error Codes
  }
}


Future<List<ExchangeRatesForDate>> fetchExchangeRatesUntil(DateTime date) async {
  final dateStr = DateFormat("yyyy-MM-dd").format(date);
  final uri = Uri.parse("$webAPIUrl/rates-until/$dateStr");
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final jsonList = jsonDecode(response.body) as List<Map<String, dynamic>>;
    return jsonList.map((e) => ExchangeRatesForDate.fromJson(e)).toList();
  } else {
    throw Exception("Failed to get exchange rates until specified date");
  }
}

Future<List<ExchangeRate>> fetchExchangeRatesForCurrencyUntil(DateTime date, String currency) async {
  final dateStr = DateFormat("yyyy-MM-dd").format(date);
  final uri = Uri.parse("$webAPIUrl/rates-until/$dateStr/$currency");
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final jsonList = jsonDecode(response.body) as List<Map<String, dynamic>>;
    return jsonList.map((e) => ExchangeRate.fromJson(e)).toList();
  } else {
    throw Exception("Failed to get exchange rates for currency until specified date");
  }
}
