//  MainRoutes - configuration for all the app's routes
//
//  Author: damattl
//

import 'dart:core';
import 'package:flutter/material.dart';
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
}


final mainRoutes = Map<MainRoute, RouteConfiguration>.of({
  MainRoute.home: RouteConfiguration(
    path: "/",
    builder: () {
      return MaterialPage(
        child: const LayoutScreen(currentRoute: MainRoute.home),
        name: MainRoute.home.toString(),
      );
    },
  ),
  MainRoute.budget: RouteConfiguration(
    path: "/budget",
    builder: () {
      return MaterialPage(
        child: const LayoutScreen(currentRoute: MainRoute.budget),
        name: MainRoute.budget.toString(),
      );
    },
  ),
  MainRoute.statistics: RouteConfiguration(
    path: "/statistics",
    builder: () {

      return MaterialPage(
        child: const LayoutScreen(currentRoute: MainRoute.statistics),
        name: MainRoute.statistics.toString(),
      );
    },
  ),
  MainRoute.settings: RouteConfiguration(
    path: "/settings",
    builder: () {
      return MaterialPage(
        child: const LayoutScreen(currentRoute: MainRoute.settings),
        name: MainRoute.settings.toString(),
      );
    },
  ),
  MainRoute.academy: RouteConfiguration(
    path: "/academy",
    builder: () {
      return MaterialPage(
        child: const LayoutScreen(currentRoute: MainRoute.academy),
        name: MainRoute.academy.toString(), // TODO: Not sure if this is needed anywhere
      );
    },
  ),
  MainRoute.lock: RouteConfiguration(
    path: "/lock",
    builder: () {
      return MaterialPage(
        child: LockScreen(),
        name: MainRoute.lock.toString(),
      );
    },
  ),
});



