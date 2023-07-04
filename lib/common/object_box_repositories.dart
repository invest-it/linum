import 'package:linum/features/currencies/repositories/exchange_rate_repository.dart';
import 'package:linum/generated/objectbox/objectbox.g.dart';

class ObjectBoxRepositories {
  final ExchangeRateRepository exchangeRates;

  static Future<ObjectBoxRepositories> create() async =>
      ObjectBoxRepositories._(await openStore());
  ObjectBoxRepositories._(Store store)
      : exchangeRates = ExchangeRateRepository(store);
}
