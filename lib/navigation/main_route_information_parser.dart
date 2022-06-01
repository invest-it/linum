import 'package:flutter/material.dart';
import 'package:linum/navigation/main_routes.dart';
import 'package:linum/navigation/main_routes_extensions.dart';

class MainRouteInformationParser extends RouteInformationParser<MainRoute> {
  @override
  Future<MainRoute> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location ?? "");

    if (uri.pathSegments.isEmpty) {
      return MainRoute.home;
    }
    return mainRoutes.getRouteFromUri(uri);

  }


}
