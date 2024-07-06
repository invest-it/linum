import 'package:linum/common/interfaces/service_interface.dart';
import 'package:linum/features/currencies/core/data/models/currency.dart';

abstract class ICurrencySettingsService extends IProvidableService with NotifyReady {
  Currency getStandardCurrency();
  Future<void> setStandardCurrency(Currency currency);
}
