//  Screens - Constant List with all Screens that can be referenced with the ScreenIndexProvider (Future: MaterialPageRoutes)
//
//  Author: NightmindOfficial
//  Co-Author: thebluebaronx
//  (Refactored by NightmindOfficial, damattl)

//list with all the "screens"
import 'package:flutter/material.dart';
import 'package:linum/core/design/layout/enums/screen_key.dart';
import 'package:linum/screens/academy_screen/academy_screen.dart';
import 'package:linum/screens/budget_screen/budget_screen.dart';
import 'package:linum/screens/home_screen/home_screen.dart';
import 'package:linum/screens/settings_screen/settings_screen.dart';
import 'package:linum/screens/statistics_screen/statistics_screen.dart';

final _routes = Map<ScreenKey, Widget>.of({
  ScreenKey.home: const HomeScreen(), //0
  ScreenKey.budget: const BudgetScreen(), //1
  ScreenKey.stats: const StatisticsScreen(), //2
  ScreenKey.settings: const SettingsScreen(), //3
  ScreenKey.academy: const AcademyScreen(), //4
  // MainRoute.lock: LockScreen(), //5
});

Map<ScreenKey, Widget> get screenRoutes => _routes;
