//  LinumApp - here the main app is defined and configured
//
//  Author: damattl
//  Co-Author: n/a
//

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linum/application_services.dart';
import 'package:linum/constants/main_theme_data.dart';
import 'package:linum/navigation/main_route_information_parser.dart';
import 'package:linum/navigation/main_router_delegate.dart';
import 'package:linum/objectbox.g.dart';

class LinumApp extends StatelessWidget {
  final bool? testing;
  final Store store;

  const LinumApp(this.store, {this.testing});

  @override
  Widget build(BuildContext context) {
    /*if (testing != null && testing!) {
      return _wrapWithBanner(app);
    } else {
      return app;
    } */
    final MainRouterDelegate routerDelegate = Get.put(MainRouterDelegate());
    final MainRouteInformationParser routeInformationParser = MainRouteInformationParser();

    return MaterialApp(
      title: 'Linum',
      theme: MainThemeData.lightTheme,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

      home: ApplicationServices(
        store: store,
        router: Router(
          routerDelegate: routerDelegate,
          routeInformationParser: routeInformationParser,
          backButtonDispatcher: RootBackButtonDispatcher(),
        ),
      ),
    );
  }
}
