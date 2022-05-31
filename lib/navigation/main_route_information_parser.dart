import 'package:flutter/material.dart';
import 'package:linum/navigation/main_route_path.dart';

class MainRouteInformationParser extends RouteInformationParser<MainRoutePath> {
  @override
  Future<MainRoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location ?? "");

    if (uri.pathSegments.isEmpty) {
      return MainRoutePath.home();
    }
    if (MainRoutePath.compareFirst(uri, MainRoutePath.budget().uri)) {
      return MainRoutePath.budget();
    }
    if (MainRoutePath.compareFirst(uri, MainRoutePath.statistics().uri)) {
      return MainRoutePath.statistics();
    }
    if (MainRoutePath.compareFirst(uri, MainRoutePath.settings().uri)) {
      return MainRoutePath.settings();
    }
    return MainRoutePath.unknown();

  }


}
