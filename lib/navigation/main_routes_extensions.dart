import 'package:linum/navigation/main_routes.dart';
import 'package:linum/navigation/route_configuration.dart';
import 'package:linum/types/page_builder.dart';

extension MainRoutesExtensions on Map<MainRoute, RouteConfiguration> {
  MainRoute getRouteFromUri(Uri uri) {
    for (final MapEntry<MainRoute, RouteConfiguration> e in entries) {
      if (e.value.path == uri.path) {
        return e.key;
      }
    }
    return MainRoute.home; // TODO: Change to unknown later
  }

  PageBuilder builderFromRoute(MainRoute route) {
    final builder = this[route]?.builder;
    if (builder == null) {
      return this[MainRoute.home]!.builder; // TODO: Replace with unknown;
    }
    return builder;
  }
}
