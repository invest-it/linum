//  Screens - Constant List with all Screens that can be referenced with the ScreenIndexProvider (Future: MaterialPageRoutes)
//
//  Author: NightmindOfficial
//  Co-Author: thebluebaronx
//  (Refactored by NightmindOfficial)

//list with all the "screens"
import 'package:flutter/material.dart';
import 'package:linum/navigation/main_routes.dart';
import 'package:linum/screens/academy_screen.dart';
import 'package:linum/screens/budget_screen.dart';
import 'package:linum/screens/home_screen.dart';
import 'package:linum/screens/lock_screen.dart';
import 'package:linum/screens/settings_screen.dart';
import 'package:linum/screens/statistics_screen.dart';


final _screens = Map<MainRoute, Widget>.of({
  MainRoute.home: const HomeScreen(), //0
  MainRoute.budget: const BudgetScreen(), //1
  MainRoute.statistics: const StatisticsScreen(), //2
  MainRoute.settings: const SettingsScreen(), //3
  MainRoute.academy: const AcademyScreen(), //4
  MainRoute.lock: LockScreen(), //5
});

Map<MainRoute, Widget> get screens => _screens;
