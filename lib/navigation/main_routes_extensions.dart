// Had to outsource it, because of some weird dart-behaviour
import 'package:linum/navigation/main_routes.dart';
import 'package:linum/navigation/route_configuration.dart';


extension MainRoutesExtensions on Map<MainRoute, RouteConfiguration> {
  MainRoute getRouteFromUri(Uri uri) {
    for (final MapEntry<MainRoute, RouteConfiguration> e in entries) {
      if (e.value.path == uri.path) {
        return e.key;
      }
    }
    return MainRoute.home; // TODO: Change to unknown later
  }
}
