//  LinumApp - here the main app is defined and configured
//
//  Author: damattl
//  Co-Author: n/a
//

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:linum/constants/main_theme_data.dart';
import 'package:linum/constants/supported_locals.dart';
import 'package:linum/firebase_wrapper.dart';
import 'package:linum/navigation/main_route_information_parser.dart';
import 'package:linum/navigation/main_router_delegate.dart';
import 'package:linum/utilities/backend/local_app_localizations.dart';

class LinumApp extends StatelessWidget {
  final bool? testing;

  const LinumApp({this.testing});

  static String? currentLocalLanguageCode;

  @override
  Widget build(BuildContext context) {
    /*if (testing != null && testing!) {
      return _wrapWithBanner(app);
    } else {
      return app;
    } */
    final MainRouterDelegate _routerDelegate = Get.put(MainRouterDelegate());
    final MainRouteInformationParser _routeInformationParser = MainRouteInformationParser();

    return MaterialApp(
      title: 'Linum',
      theme: MainThemeData.lightTheme,
      home: FirebaseWrapper(
        router: Router(
          routerDelegate: _routerDelegate,
          routeInformationParser: _routeInformationParser,
        ),
      ),
      debugShowCheckedModeBanner: false,

      supportedLocales: supportedLocals,
      localizationsDelegates: const [
        // Local Translation of our coding team / Invest it! Community
        AppLocalizations.delegate,
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // EXPERIMENTAL: Account for Apple's Bullshit
        GlobalCupertinoLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate,
      ],
      // Returns a locale which will be used by the app
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (final supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode ||
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      },
    );
  }
}
