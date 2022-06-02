import 'dart:core';

import 'package:flutter/material.dart';
import 'package:linum/navigation/route_configuration.dart';
import 'package:linum/screens/layout_screen.dart';

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
    path: "/budget", // TODO: Implement as URI?
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
});



