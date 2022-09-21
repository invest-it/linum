//  MainRoutes - configuration for all the app's routes
//
//  Author: damattl
//

import 'dart:core';

import 'package:flutter/material.dart';
import 'package:linum/navigation/enter_screen_page.dart';
import 'package:linum/navigation/route_configuration.dart';
import 'package:linum/screens/lock_screen.dart';
import 'package:linum/screens/screen_layout.dart';

enum MainRoute {
  home,
  budget,
  statistics,
  settings,
  academy,
  lock,
  enter
}


final mainRoutes = Map<MainRoute, RouteConfiguration>.of({
  MainRoute.home: RouteConfiguration(
    path: "/",
    builder: <T>(_) {
      return const MaterialPage(
        child: ScreenLayout(currentRoute: MainRoute.home),
      );
    },
  ),
  MainRoute.budget: RouteConfiguration(
    path: "/budget",
    builder: <T>(_) {
      return MaterialPage(
        child: const ScreenLayout(currentRoute: MainRoute.budget),
        name: MainRoute.budget.toString(),
      );
    },
  ),
  MainRoute.statistics: RouteConfiguration(
    path: "/statistics",
    builder: <T>(_) {

      return MaterialPage(
        child: const ScreenLayout(currentRoute: MainRoute.statistics),
        name: MainRoute.statistics.toString(),
      );
    },
  ),
  MainRoute.settings: RouteConfiguration(
    path: "/settings",
    builder: <T>(_) {
      return MaterialPage(
        child: const ScreenLayout(currentRoute: MainRoute.settings),
        name: MainRoute.settings.toString(),
      );
    },
  ),
  MainRoute.academy: RouteConfiguration(
    path: "/academy",
    builder: <T>(_) {
      return MaterialPage(
        child: const ScreenLayout(currentRoute: MainRoute.academy),
        name: MainRoute.academy.toString(), // TODO: Not sure if this is needed anywhere
      );
    },
  ),
  MainRoute.lock: RouteConfiguration(
    path: "/lock",
    builder: <T>(_) {
      return MaterialPage(
        child: LockScreen(),
        name: MainRoute.lock.toString(),
      );
    },
  ),
  MainRoute.enter: RouteConfiguration(
    path: "/enterScreen",
    builder: <T>(settings) {
      // TODO THROW ERROR IF NO SETTINGS PROVIDED
      return EnterScreenPage(settings as EnterScreenPageSettings);
    },
  ),

});



/*
return EnterScreenProvider(
          category: _accountSettingsProvider.settings[
          'StandardCategoryExpense']
          as String? ??
              "None",
          secondaryCategory:
          _accountSettingsProvider.settings[
          'StandardCategoryIncome']
          as String? ??
              "None",
        );
 */
