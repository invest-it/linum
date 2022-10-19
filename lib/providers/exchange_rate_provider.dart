import 'package:flutter/cupertino.dart';
import 'package:linum/objectbox.g.dart';
import 'package:linum/utilities/backend/exchange_rate_repository.dart';

class ExchangeRateProvider extends ChangeNotifier {
  late final ExchangeRateRepository _repository;
  final Store _store;
  ExchangeRateProvider(this._store) : _repository = ExchangeRateRepository(_store);

  @override
  void dispose() {
    _store.close();
    super.dispose();
  }

}
