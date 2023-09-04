//  MainRoutes - configuration for all the app's routes
//  A new route has to be declared in the MainRoute enumeration
//  and then be configured in the mainRoutes map.
//
//  Author: damattl
//

import 'dart:core';

import 'package:flutter/material.dart';
import 'package:linum/core/design/layout/enums/screen_key.dart';
import 'package:linum/core/design/layout/screen_layout.dart';
import 'package:linum/core/navigation/route_configuration.dart';
import 'package:linum/screens/filter_screen/filter_screen.dart';
import 'package:linum/screens/lock_screen/lock_screen.dart';
import 'package:linum/screens/sandbox_screen/sandbox_screen.dart';
import 'package:uuid/uuid.dart';

enum MainRoute {
  home,
  budget,
  stats,
  settings,
  academy,
  lock,
  filter,
  sandbox,
}

final mainRoutes = Map<MainRoute, RouteConfiguration>.of({
  MainRoute.home: RouteConfiguration(
    path: "/",
    builder: <T>(_) {
      return const MaterialPage(
        child: ScreenLayout(currentScreen: ScreenKey.home),
      );
    },
  ),
  MainRoute.budget: RouteConfiguration(
    path: "/budget",
    builder: <T>(_) {
      return MaterialPage(
        child: const ScreenLayout(currentScreen: ScreenKey.budget),
        name: MainRoute.budget.toString(),
      );
    },
  ),
  MainRoute.stats: RouteConfiguration(
    path: "/statistics",
    builder: <T>(_) {
      return MaterialPage(
        child: const ScreenLayout(currentScreen: ScreenKey.stats),
        name: MainRoute.stats.toString(),
      );
    },
  ),
  MainRoute.settings: RouteConfiguration(
    path: "/settings",
    builder: <T>(_) {
      return MaterialPage(
        child: const ScreenLayout(currentScreen: ScreenKey.settings),
        name: MainRoute.settings.toString(),
      );
    },
  ),
  MainRoute.academy: RouteConfiguration(
    path: "/academy",
    builder: <T>(_) {
      return MaterialPage(
        child: const ScreenLayout(currentScreen: ScreenKey.academy),
        name: MainRoute.academy.toString(),
      );
    },
  ),
  MainRoute.lock: RouteConfiguration(
    path: "/lock",
    builder: <T>(_) {
      return MaterialPage(
        child: const LockScreen(),
        name: MainRoute.lock.toString(),
      );
    },
  ),
  MainRoute.filter: RouteConfiguration(
    path: "/filter",
    builder: <T>(_) {
      return MaterialPage(
        child: const FilterScreen(),
        name: MainRoute.filter.toString(),
      );
    },
  ),
  MainRoute.sandbox: RouteConfiguration(
    path: "/sandbox${const Uuid().v4()}",
    builder: <T>(_) {
      return MaterialPage(
        child: const SandboxScreen(),
        name: MainRoute.sandbox.toString(),
      );
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
