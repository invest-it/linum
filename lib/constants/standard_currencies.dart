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
      "JPY": const Currency(
        label: 'currency.name.jpy',
        name: 'JPY',
        symbol: '¥',
        icon: Icons.currency_yen,
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
    }
);
