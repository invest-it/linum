import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/design/theme/theme_data.dart';
import 'package:linum/core/navigation/main_router_delegate.dart';
import 'package:linum/core/navigation/main_routes.dart';
import 'package:linum/generated/objectbox/objectbox.g.dart';
import 'package:linum/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Linum extends StatelessWidget {
  final bool? testing;
  final Store store;
  final MainRouterDelegate routerDelegate;
  final RouteInformationParser<MainRoute> routeInformationParser;
  final SharedPreferences preferences;

  const Linum({
    required this.store,
    required this.routerDelegate,
    required this.routeInformationParser,
    required this.preferences,
    this.testing,
  });

  @override
  Widget build(BuildContext context) {
    /*if (testing != null && testing!) {
      return _wrapWithBanner(app);
    } else {
      return app;
    } */
    print("rebuild linum app");

    return MaterialApp(
      title: 'Linum',
      theme: LinumTheme.light(),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: ApplicationServices(
        store: store,
        preferences: preferences,
        router: Router<MainRoute>(
          routerDelegate: routerDelegate,
          routeInformationParser: routeInformationParser,
          backButtonDispatcher: RootBackButtonDispatcher(),
        ),
      ),
    );
  }
}
