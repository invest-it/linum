//  MainRoutes - configuration for all the app's routes
//
//  Author: damattl
//

import 'dart:core';
import 'package:flutter/material.dart';
import 'package:linum/navigation/enter_screen_page.dart';
import 'package:linum/navigation/route_configuration.dart';
import 'package:linum/screens/layout_screen.dart';
import 'package:linum/screens/lock_screen.dart';

enum MainRoute {
  home,
  budget,
  statistics,
  settings,
  academy,
  lock,
  enterScreen,
}


final mainRoutes = Map<MainRoute, RouteConfiguration>.of({
  MainRoute.home: RouteConfiguration(
    path: "/",
    builder: <Void>(_) {
      return MaterialPage(
        child: const LayoutScreen(currentRoute: MainRoute.home),
        name: MainRoute.home.toString(),
      );
    },
  ),
  MainRoute.budget: RouteConfiguration(
    path: "/budget",
    builder: <Void>(_) {
      return MaterialPage(
        child: const LayoutScreen(currentRoute: MainRoute.budget),
        name: MainRoute.budget.toString(),
      );
    },
  ),
  MainRoute.statistics: RouteConfiguration(
    path: "/statistics",
    builder: <Void>(_) {

      return MaterialPage(
        child: const LayoutScreen(currentRoute: MainRoute.statistics),
        name: MainRoute.statistics.toString(),
      );
    },
  ),
  MainRoute.settings: RouteConfiguration(
    path: "/settings",
    builder: <Void>(_) {
      return MaterialPage(
        child: const LayoutScreen(currentRoute: MainRoute.settings),
        name: MainRoute.settings.toString(),
      );
    },
  ),
  MainRoute.academy: RouteConfiguration(
    path: "/academy",
    builder: <Void>(_) {
      return MaterialPage(
        child: const LayoutScreen(currentRoute: MainRoute.academy),
        name: MainRoute.academy.toString(), // TODO: Not sure if this is needed anywhere
      );
    },
  ),
  MainRoute.lock: RouteConfiguration(
    path: "/lock",
    builder: <Void>(_) {
      return MaterialPage(
        child: LockScreen(),
        name: MainRoute.lock.toString(),
      );
    },
  ),
  MainRoute.enterScreen: RouteConfiguration(
    path: "/enterScreen",
    builder: <EnterScreenSettings>(settings) {
      // TODO THROW ERROR IF NO SETTINGS PROVIDED
      return EnterScreenPage(settings as EnterScreenPageSettings);
    }
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
