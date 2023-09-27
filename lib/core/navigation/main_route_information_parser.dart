//  MainRouteInformationParser - parses incoming urls and deep-links
//
//  Author: damattl
//

import 'package:flutter/material.dart';
import 'package:linum/core/navigation/main_routes.dart';
import 'package:linum/core/navigation/main_routes_extensions.dart';

class MainRouteInformationParser extends RouteInformationParser<MainRoute> {
  @override
  Future<MainRoute> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = routeInformation.uri;

    if (uri.pathSegments.isEmpty) {
      return MainRoute.home;
    }
    return mainRoutes.getRouteFromUri(uri);
  }
}
