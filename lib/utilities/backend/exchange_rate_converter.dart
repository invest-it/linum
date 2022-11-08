import 'package:linum/models/exchange_rate_info.dart';

num convertCurrencyAmountWithExchangeRate(num amount, ExchangeRateInfo rateInfo) {
  final amountInEuro = amount / rateInfo.rate;
  return amountInEuro * rateInfo.standardCurrencyRate;
}
