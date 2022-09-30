import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:linum/models/exchange_rate.dart';

const webAPIUrl = "https://exchange-rates.linum.martins-lightart.de/";

Future<ExchangeRate> fetchExchangeRateForDate(DateTime date, String currency) async {
  final dateStr = DateFormat("yyyy-MM-dd").format(date);
  final response = await http
      .get(Uri.parse("$webAPIUrl/rate/$currency/$dateStr"));

  if (response.statusCode == 200) {
    final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
    // TODO: Handle errors
    return ExchangeRate.fromJson(jsonMap);
  } else {
    throw Exception("Failed to get Exchange Rate");
    // TODO: Handle error more elegantly. Use API Error Codes
  }
}
