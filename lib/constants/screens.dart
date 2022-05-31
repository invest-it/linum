//  Screens - Constant List with all Screens that can be referenced with the ScreenIndexProvider (Future: MaterialPageRoutes)
//
//  Author: NightmindOfficial
//  Co-Author: thebluebaronx
//  (Refactored by NightmindOfficial)

//list with all the "screens"
import 'package:flutter/material.dart';
import 'package:linum/screens/academy_screen.dart';
import 'package:linum/screens/budget_screen.dart';
import 'package:linum/screens/home_screen.dart';
import 'package:linum/screens/lock_screen.dart';
import 'package:linum/screens/settings_screen.dart';
import 'package:linum/screens/statistics_screen.dart';

final List<Widget> _screens = <Widget>[
  const HomeScreen(), //0
  const BudgetScreen(), //1
  const StatisticsScreen(), //2
  const SettingsScreen(), //3
  const AcademyScreen(), //4
  LockScreen(), //5
];

List<Widget> get screens => _screens;
