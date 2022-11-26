//  Standard Currencies - Contains Styles of Currencies for all Enums specified in settings_enums.dart
//
//  Author: NightmindOfficial, thebluebaronx
//  Co-Author: damattl
//  (Refactored)

import 'package:linum/models/currency.dart';

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
    symbol: '₣',
  ),
  "PLN": const Currency(
    label: 'currency.name.pln',
    name: 'PLN',
  ),
  "CZK": const Currency(
    label: 'currency.name.czk',
    name: 'CZK',
  ),
  "JPY": const Currency(
    label: 'currency.name.jpy',
    name: 'JPY',
    symbol: '¥',
  ),
  "CNY": const Currency(
    label: 'currency.name.cny',
    name: 'CNY',
    symbol: '¥',
  ),
  "KRW": const Currency(
    label: 'currency.name.krw',
    name: 'KRW',
  ),
  "AUD": const Currency(
    label: 'currency.name.aud',
    name: 'AUD',
    symbol: '\$',
  ),
  "NZD": const Currency(
    label: 'currency.name.nzd',
    name: 'NZD',
    symbol: '\$',
  ),
  "CAD": const Currency(
    label: 'currency.name.cad',
    name: 'CAD',
    symbol: '\$',
  ),
  "NOK": const Currency(
    label: 'currency.name.nok',
    name: 'NOK',
    symbol: 'kr',
  ),
  "SEK": const Currency(
    label: 'currency.name.sek',
    name: 'SEK',
    symbol: 'kr',
  ),
  "DKK": const Currency(
    label: 'currency.name.dkk',
    name: 'DKK',
  ),
  "ISK": const Currency(
    label: 'currency.name.isk',
    name: 'ISK',
  ),
  "TYR": const Currency(
    label: 'currency.name.tyr',
    name: 'TYR',
  ),
  "MYR": const Currency(
    label: 'currency.name.myr',
    name: 'MYR',
    symbol: 'RM',
  ),
  "INR": const Currency(
    label: 'currency.name.inr',
    name: 'INR',
  ),
  "IDR": const Currency(
    label: 'currency.name.idr',
    name: 'IDR',
  ),
  "MXN": const Currency(
    label: 'currency.name.mxn',
    name: 'MXN',
  ),
  "THB": const Currency(
    label: 'currency.name.thb',
    name: 'THB',
  ),
  "ILS": const Currency(
    label: 'currency.name.ils',
    name: 'ILS',
  ),
  "BLR": const Currency(
    label: 'currency.name.blr',
    name: 'BLR',
  ),
  "ZAR": const Currency(
    label: 'currency.name.zar',
    name: 'ZAR',
  ),
});
