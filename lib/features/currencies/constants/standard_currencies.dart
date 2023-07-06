//  Standard Currencies - Contains Styles of Currencies for all Enums specified in settings_enums.dart
//
//  Author: NightmindOfficial, thebluebaronx
//  Co-Author: damattl
//  (Refactored)

import 'package:collection/collection.dart';
import 'package:linum/features/currencies/models/currency.dart';
import 'package:linum/generated/translation_keys.g.dart';

final standardCurrencies = Map<String, Currency>.unmodifiable({
  "EUR": Currency(
    label: translationKeys.currency.name.eur,
    name: 'EUR',
    symbol: '€',
  ),
  "GBP": Currency(
    label: translationKeys.currency.name.gbp,
    name: 'GBP',
    symbol: '£',
  ),
  "USD": Currency(
    label: translationKeys.currency.name.usd,
    name: 'USD',
    symbol: '\$',
  ),
  "CHF": Currency(
    label: translationKeys.currency.name.chf,
    name: 'CHF',
    symbol: 'CHF',
  ),
  "PLN": Currency(
    label: translationKeys.currency.name.pln,
    name: 'PLN',
    symbol: 'zł',
  ),
  "CZK": Currency(
    label: translationKeys.currency.name.czk,
    name: 'CZK',
    symbol: 'Kč',
  ),
  "JPY": Currency(
    label: translationKeys.currency.name.jpy,
    name: 'JPY',
    symbol: 'JP¥',
  ),
  "CNY": Currency(
    label: translationKeys.currency.name.cny,
    name: 'CNY',
    symbol: 'CN¥',
  ),
  "KRW": Currency(
    label: translationKeys.currency.name.krw,
    name: 'KRW',
    symbol: '원',
  ),
  "AUD": Currency(
    label: translationKeys.currency.name.aud,
    name: 'AUD',
    symbol: 'AU\$',
  ),
  "NZD": Currency(
    label: translationKeys.currency.name.nzd,
    name: 'NZD',
    symbol: 'NZ\$',
  ),
  "CAD": Currency(
    label: translationKeys.currency.name.cad,
    name: 'CAD',
    symbol: 'C\$',
  ),
  "NOK": Currency(
    label: translationKeys.currency.name.nok,
    name: 'NOK',
    symbol: 'nkr',
  ),
  "SEK": Currency(
    label: translationKeys.currency.name.sek,
    name: 'SEK',
    symbol: 'skr',
  ),
  "DKK": Currency(
    label: translationKeys.currency.name.dkk,
    name: 'DKK',
    symbol: 'dkr',
  ),
  "ISK": Currency(
    label: translationKeys.currency.name.isk,
    name: 'ISK',
    symbol: 'Íkr',
  ),
  "TRY": Currency(
    label: translationKeys.currency.name.tyr, // TODO: fix key name
    name: 'TRY',
    symbol: '₺',
  ),
  "MYR": Currency(
    label: translationKeys.currency.name.myr,
    name: 'MYR',
    symbol: 'RM',
  ),
  "INR": Currency(
    label: translationKeys.currency.name.inr,
    name: 'INR',
    symbol: '₹',
  ),
  "IDR": Currency(
    label: translationKeys.currency.name.idr,
    name: 'IDR',
    symbol: 'Rp',
  ),
  "MXN": Currency(
    label: translationKeys.currency.name.mxn,
    name: 'MXN',
    symbol: 'Mex\$',
  ),
  "THB": Currency(
    label: translationKeys.currency.name.thb,
    name: 'THB',
    symbol: '฿',
  ),
  "ILS": Currency(
    label: translationKeys.currency.name.ils,
    name: 'ILS',
    symbol: '₪',
  ),
  "BRL": Currency(
    label: translationKeys.currency.name.blr, // TODO: fix key name
    name: 'BRL',
    symbol: 'R\$',
  ),
  "ZAR": Currency(
    label: translationKeys.currency.name.zar,
    name: 'ZAR',
    symbol: 'R',
  ),
});


Currency? getCurrencyFromSubstring(String? substring) {
  final currency = standardCurrencies[substring];
  return currency ?? standardCurrencies.entries
      .firstWhereOrNull((element) => element.value.symbol == substring)?.value;

}

bool isValidCurrency(String? substring) {
  if (substring == null) {
    return false;
  }

  return getCurrencyFromSubstring(substring) != null;
}
