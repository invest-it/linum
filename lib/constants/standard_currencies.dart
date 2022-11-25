//  Standard Currencies - Contains Styles of Currencies for all Enums specified in settings_enums.dart
//
//  Author: NightmindOfficial, thebluebaronx
//  Co-Author: damattl
//  (Refactored)

import 'package:flutter/material.dart';
import 'package:linum/models/currency.dart';

final standardCurrencies = Map<String, Currency>.unmodifiable({
    "EUR": const Currency(
      label: 'currency.name.eur',
      name: 'EUR',
      symbol: '€',
      icon: Icons.euro,
    ),
    "GBP": const Currency(
      label: 'currency.name.gbp',
      name: 'GBP',
      symbol: '£',
      icon: Icons.currency_pound,
    ),
    "USD": const Currency(
      label: 'currency.name.usd',
      name: 'USD',
      symbol: '\$',
      icon: Icons.attach_money,
    ),
    "CHF": const Currency(
      label: 'currency.name.chf',
      name: 'CHF',
      symbol: '₣',
      icon: Icons.currency_franc,
    ),
    "JPY": const Currency(
      label: 'currency.name.jpy',
      name: 'JPY',
      symbol: '¥',
      icon: Icons.currency_yen,
    ),
    "CNY": const Currency(
      label: 'currency.name.cny',
      name: 'CNY',
      symbol: '¥',
      icon: Icons.currency_yen,
    ),
    "AUD": const Currency(
      label: 'currency.name.aud',
      name: 'AUD',
      symbol: '\$',
      icon: Icons.attach_money,
    ),
    "NZD": const Currency(
      label: 'currency.name.nzd',
      name: 'NZD',
      symbol: '\$',
      icon: Icons.attach_money,
    ),
    "CAD": const Currency(
      label: 'currency.name.cad',
      name: 'CAD',
      symbol: '\$',
      icon: Icons.attach_money,
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
    "MYR": const Currency(
      label: 'currency.name.myr',
      name: 'MYR',
      symbol: 'RM',
    ),
  }
);
