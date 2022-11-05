//  Standard Currencies - Contains Styles of Currencies for all Enums specified in settings_enums.dart
//
//  Author: NightmindOfficial, thebluebaronx
//  Co-Author: damattl
//  (Refactored)

import 'package:flutter/material.dart';
import 'package:linum/models/currency.dart';

final standardCurrencies = Map<String, Currency>.unmodifiable({
      "EUR": const Currency(
        label: 'Euro',
        name: 'EUR',
        icon: Icons.euro,
      ),
      "JPY": const Currency(
        label: 'Yen',
        name: 'JPY',
        icon: Icons.currency_yen,
      ),
      "GBP": const Currency(
        label: 'Pound',
        name: 'GBP',
        icon: Icons.currency_pound,
      ),
    }
);
