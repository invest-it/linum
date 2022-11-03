//  Standard Currencies - Contains Styles of Currencies for all Enums specified in settings_enums.dart
//
//  Author: NightmindOfficial, thebluebaronx
//  Co-Author: damattl
//  (Refactored)

import 'package:flutter/material.dart';
import 'package:linum/constants/settings_enums.dart';
import 'package:linum/models/entry_currency.dart';
import 'package:linum/types/category_map_currency.dart';

final CategoryMapCurrency<StandardCurrency> standardCurrency =
    CategoryMapCurrency.fromMap({
  StandardCurrency.euro: const EntryCurrency(
    label: 'Euro',
    icon: Icons.euro,
  ),
  StandardCurrency.yen: const EntryCurrency(
    label: 'Yen',
    icon: Icons.currency_yen,
  ),
  StandardCurrency.dollar: const EntryCurrency(
    label: 'Pound',
    icon: Icons.currency_pound,
  ),
});
