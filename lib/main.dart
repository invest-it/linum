//  Main File - The root of our application
//
//  Author: The Linum Authors
//
//

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:linum/constants/main_theme_data.dart';
import 'package:linum/constants/supported_locals.dart';
import 'package:linum/navigation/main_route_information_parser.dart';
import 'package:linum/navigation/main_router_delegate.dart';
import 'package:linum/providers/authentication_service.dart';

import 'package:linum/providers/onboarding_screen_provider.dart';
import 'package:linum/screens/layout_screen.dart';
import 'package:linum/screens/onboarding_screen.dart';
import 'package:linum/utilities/backend/local_app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main({bool? testing}) async {
  WidgetsFlutterBinding.ensureInitialized();

  if (testing != null && testing) {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  /// Force Portrait Mode
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SharedPreferences.getInstance().then((pref) {
    MyApp.currentLocalLanguageCode = pref.getString("languageCode");
    runApp(MyApp(testing: testing));
  });
}

class MyApp extends StatelessWidget {
  final bool? testing;

  const MyApp({this.testing});

  static String? currentLocalLanguageCode;

  @override
  Widget build(BuildContext context) {
    /*if (testing != null && testing!) {
      return _wrapWithBanner(app);
    } else {
      return app;
    } */
    final MainRouterDelegate _routerDelegate = MainRouterDelegate();
    final MainRouteInformationParser _routeInformationParser =
    MainRouteInformationParser();

    return MaterialApp.router(
      title: 'Linum',
      theme: MainThemeData.lightTheme,

      debugShowCheckedModeBanner: false,

      routeInformationParser: _routeInformationParser,
      routerDelegate: _routerDelegate,

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

// Defines the State of the App (in our MVP test phase, this will be "ALPHA" according
// to the principles of versioning)

Widget _wrapWithBanner(Widget child) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: Banner(
      location: BannerLocation.bottomEnd,
      message: 'TESTING',
      color: Colors.white.withOpacity(1),
      textStyle: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 12.0,
        letterSpacing: 1.0,
        color: Color(0xFF79BC4E),
      ),
      textDirection: TextDirection.ltr,
      child: child,
    ),
  );
}

class OnBoardingOrLayoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthenticationService auth =
        Provider.of<AuthenticationService>(context);
    if (auth.isLoggedIn) {
      return LayoutScreen(key: key);
    } else {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<OnboardingScreenProvider>(
            create: (_) => OnboardingScreenProvider(),
          ),
        ],
        child: const OnboardingPage(),
      );
    }
  }
}
