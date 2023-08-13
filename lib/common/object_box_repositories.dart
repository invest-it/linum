// TODO: Might be a nice pattern but could be removed currently
/* class ObjectBoxRepositories {
  final IExchangeRateRepository exchangeRates;

  static Future<ObjectBoxRepositories> create() async =>
      ObjectBoxRepositories._(await openStore());
  ObjectBoxRepositories._(Store store)
      : exchangeRates = IExchangeRateRepository(store);
}
*/
