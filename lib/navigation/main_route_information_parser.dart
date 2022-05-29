import 'package:flutter/material.dart';
import 'package:linum/navigation/main_route_path.dart';

class MainRouteInformationParser extends RouteInformationParser<MainRoutePath> {
  @override
  Future<MainRoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location ?? "");

    if (uri.pathSegments.isEmpty) {
      return HomeScreenPath();
    }
    switch (uri.pathSegments[0]) {
      case MainRoutePaths.budget:
        return BudgetScreenPath();
      case MainRoutePaths.settings:
        return SettingsScreenPath();
      case MainRoutePaths.statistics:
        return StatisticsScreenPath();
      default:
        return HomeScreenPath();
    }
  }

}
