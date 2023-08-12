import 'dart:async';
import 'package:linum/common/utils/subscription_handler.dart';
import 'package:linum/core/settings/domain/settings_repository.dart';
import 'package:linum/features/currencies/core/data/models/currency.dart';
import 'package:linum/features/currencies/settings/data/currency_settings.dart';
import 'package:linum/features/currencies/settings/presentation/currency_settings_service.dart';

class CurrencySettingsServiceImpl extends SubscriptionHandler implements ICurrencySettingsService {
  final ISettingsRepository<CurrencySettings> _repository;

  CurrencySettingsServiceImpl(this._repository) {
    super.subscribe(_repository.settingsStream, (event) {
      notifyListeners();
    });
  }

  @override
  Currency getStandardCurrency() {
    return _repository.settings.currency;
  }

  @override
  Future<void> setStandardCurrency(Currency currency) {
    final update = _repository.settings.copyWith(currency: currency);
    return _repository.update(update);
  }
}
