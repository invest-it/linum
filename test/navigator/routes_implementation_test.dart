import 'package:flutter_test/flutter_test.dart';
import 'package:linum/navigation/main_routes.dart';
import 'package:linum/navigation/route_configuration.dart';


void main() {
  group("Navigation", () {
      for (final enumValue in MainRoute.values) {
        test("Test MainRoute-Enumeration value $enumValue", () {
          expect(
              mainRoutes[enumValue].runtimeType,
              RouteConfiguration,
              reason: "The enumeration value "
                  "$enumValue could not be found in the 'mainRoutes'-map",
          );
        });
      }
  });
}
