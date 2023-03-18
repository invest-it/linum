//  Standard Currencies - Contains Styles of Currencies for all Enums specified in settings_enums.dart
//
//  Author: NightmindOfficial, thebluebaronx
//  Co-Author: damattl
//  (Refactored)

import 'package:linum/features/currencies/models/currency.dart';

final standardCurrencies = Map<String, Currency>.unmodifiable({
  "EUR": const Currency(
    label: 'currency.name.eur',
    name: 'EUR',
    symbol: '€',
  ),
  "GBP": const Currency(
    label: 'currency.name.gbp',
    name: 'GBP',
    symbol: '£',
  ),
  "USD": const Currency(
    label: 'currency.name.usd',
    name: 'USD',
    symbol: '\$',
  ),
  "CHF": const Currency(
    label: 'currency.name.chf',
    name: 'CHF',
    symbol: 'CHF',
  ),
  "PLN": const Currency(
    label: 'currency.name.pln',
    name: 'PLN',
    symbol: 'zł',
  ),
  "CZK": const Currency(
    label: 'currency.name.czk',
    name: 'CZK',
    symbol: 'Kč',
  ),
  "JPY": const Currency(
    label: 'currency.name.jpy',
    name: 'JPY',
    symbol: 'JP¥',
  ),
  "CNY": const Currency(
    label: 'currency.name.cny',
    name: 'CNY',
    symbol: 'CN¥',
  ),
  "KRW": const Currency(
    label: 'currency.name.krw',
    name: 'KRW',
    symbol: '원',
  ),
  "AUD": const Currency(
    label: 'currency.name.aud',
    name: 'AUD',
    symbol: 'AU\$',
  ),
  "NZD": const Currency(
    label: 'currency.name.nzd',
    name: 'NZD',
    symbol: 'NZ\$',
  ),
  "CAD": const Currency(
    label: 'currency.name.cad',
    name: 'CAD',
    symbol: 'C\$',
  ),
  "NOK": const Currency(
    label: 'currency.name.nok',
    name: 'NOK',
    symbol: 'nkr',
  ),
  "SEK": const Currency(
    label: 'currency.name.sek',
    name: 'SEK',
    symbol: 'skr',
  ),
  "DKK": const Currency(
    label: 'currency.name.dkk',
    name: 'DKK',
    symbol: 'dkr',
  ),
  "ISK": const Currency(
    label: 'currency.name.isk',
    name: 'ISK',
    symbol: 'Íkr',
  ),
  "TRY": const Currency(
    label: 'currency.name.tyr', // TODO: fix key name
    name: 'TRY',
    symbol: '₺',
  ),
  "MYR": const Currency(
    label: 'currency.name.myr',
    name: 'MYR',
    symbol: 'RM',
  ),
  "INR": const Currency(
    label: 'currency.name.inr',
    name: 'INR',
    symbol: '₹',
  ),
  "IDR": const Currency(
    label: 'currency.name.idr',
    name: 'IDR',
    symbol: 'Rp',
  ),
  "MXN": const Currency(
    label: 'currency.name.mxn',
    name: 'MXN',
    symbol: 'Mex\$',
  ),
  "THB": const Currency(
    label: 'currency.name.thb',
    name: 'THB',
    symbol: '฿',
  ),
  "ILS": const Currency(
    label: 'currency.name.ils',
    name: 'ILS',
    symbol: '₪',
  ),
  "BRL": const Currency(
    label: 'currency.name.blr', // TODO: fix key name
    name: 'BRL',
    symbol: 'R\$',
  ),
  "ZAR": const Currency(
    label: 'currency.name.zar',
    name: 'ZAR',
    symbol: 'R',
  ),
});
