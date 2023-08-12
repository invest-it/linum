import 'package:linum/core/settings/data/settings_mapper_interface.dart';
import 'package:linum/features/currencies/core/constants/standard_currencies.dart';
import 'package:linum/features/currencies/settings/data/currency_settings.dart';

class CurrencySettingsMapper implements ISettingsMapper<CurrencySettings> {
  @override
  Map<String, dynamic> toMap(CurrencySettings model) {
    final currencyId = model.currency.name;
    return {
      "StandardCurrency": currencyId,
    };
  }

  @override
  CurrencySettings toModel(Map<String, dynamic> map) {
    final currencyId = map["StandardCurrency"] as String?;
    final currency = standardCurrencies[currencyId] ?? standardCurrencies["EUR"]!;

    return CurrencySettings(
      currency: currency,
    );
  }





}
