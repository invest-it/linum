//  RouteConfiguration - possible configurations for routes
//
//  Author: damattl
//

import 'package:linum/core/navigation/types/page_builder.dart';

class RouteConfiguration {
  final Uri uri;
  final PageBuilder builder;
  RouteConfiguration({required String path, required this.builder})
      : uri = Uri(path: path);

  String get path => uri.path;
}
