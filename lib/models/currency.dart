//  EntryCategoriy - Basic Model of a Category that can be displayed within the settings_screen.dart
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//

import 'package:flutter/material.dart';

class Currency {
  final String label;
  final String name;
  final String symbol;
  final IconData? icon;

  const Currency({required this.label, required this.name, required this.symbol, this.icon});
}
