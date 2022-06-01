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




// TODO: Perhaps as a custom map?
final mainRoutes = Map<MainRoute, RouteConfiguration>.of({
  MainRoute.home: RouteConfiguration(
    path: "/",
    builder: () {
      return const MaterialPage(
        child: LayoutScreen(currentRoute: MainRoute.home),
      );
    },
    // TODO: Page might never be rebuild - use a builder-function perhaps?
  ),
  MainRoute.budget: RouteConfiguration(
    path: "/budget", // TODO: Implement as URI?
    builder: () {
      return const MaterialPage(
        child: LayoutScreen(currentRoute: MainRoute.budget),
      );
    },
  ),
  MainRoute.statistics: RouteConfiguration(
    path: "/statistics",
    builder: () {
      return const MaterialPage(
        child: LayoutScreen(currentRoute: MainRoute.statistics),
      );
    },
  ),
  MainRoute.settings: RouteConfiguration(
    path: "/settings",
    builder: () {
      return const MaterialPage(
        child: LayoutScreen(currentRoute: MainRoute.settings),
      );
    },
  ),
});


