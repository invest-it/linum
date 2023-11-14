import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/design/theme/constants/main_theme_data.dart';
import 'package:linum/core/navigation/main_router_delegate.dart';
import 'package:linum/core/navigation/main_routes.dart';
import 'package:linum/generated/objectbox/objectbox.g.dart';
import 'package:linum/services.dart';

class Linum extends StatelessWidget {
  final bool? testing;
  final Store store;
  final MainRouterDelegate routerDelegate;
  final RouteInformationParser<MainRoute> routeInformationParser;

  const Linum({
    required this.store,
    required this.routerDelegate,
    required this.routeInformationParser,
    this.testing,
  });

  @override
  Widget build(BuildContext context) {
    /*if (testing != null && testing!) {
      return _wrapWithBanner(app);
    } else {
      return app;
    } */

    return MaterialApp(
      title: 'Linum',
      theme: MainThemeData.lightTheme,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: ApplicationServices(
        store: store,
        router: Router<MainRoute>(
          routerDelegate: routerDelegate,
          routeInformationParser: routeInformationParser,
          backButtonDispatcher: RootBackButtonDispatcher(),
        ),
      ),
    );
  }
}
