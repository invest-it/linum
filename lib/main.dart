//  Main File - The root of our application
//
//  Author: The Linum Authors
//
//

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:linum/constants/main_theme_data.dart';
import 'package:linum/providers/account_settings_provider.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/providers/algorithm_provider.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:linum/providers/balance_data_provider.dart';
import 'package:linum/providers/onboarding_screen_provider.dart';
import 'package:linum/providers/pin_code_provider.dart';
import 'package:linum/providers/screen_index_provider.dart';
import 'package:linum/screens/layout_screen.dart';
import 'package:linum/screens/onboarding_screen.dart';
import 'package:linum/utilities/backend/local_app_localizations.dart';
import 'package:linum/utilities/frontend/multi_provider_builder.dart';
import 'package:linum/utilities/frontend/size_guide.dart';
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
    final MaterialApp app = MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Linum',
      theme: MainThemeData.lightTheme,

      // End of Theme Data.
      home: MyHomePage(title: 'Linum', testing: testing),

      // Specified Localizations
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('de', 'DE'),
        Locale('nl', 'NL'),
        Locale('es', 'ES'),
        Locale('fr', 'FR')
      ],

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

    if (testing != null && testing!) {
      return _wrapWithBanner(app);
    } else {
      return app;
    }
  }
}

class MyHomePage extends StatefulWidget {
  final bool? testing;
  const MyHomePage({Key? key, required this.title, this.testing})
      : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState(testing: testing);
}

class _MyHomePageState extends State<MyHomePage> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  final bool? testing;
  _MyHomePageState({this.testing});

  @override
  Widget build(BuildContext context) {
    // Initialize Size Guide for responsive behaviour
    SizeGuide.init(context);

    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (innerContext, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                AppLocalizations.of(context)!.translate("main/label-error"),
              ),
            ),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {


          return MultiProviderBuilder(context: context, child: OnBoardingOrLayoutScreen())
            .setKey("MainMultiProvider")
            .useProvider(AuthenticationService.provider)
            .useProvider(AccountSettingsProvider.provider)
            .useProvider(AlgorithmProvider.provider)
            .useProvider(BalanceDataProvider.provider)
            .useProvider(ScreenIndexProvider.provider)
            .useProvider(ActionLipStatusProvider.provider)
            .useProvider(PinCodeProvider.provider)
            .build();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32.0),
                  child: CircularProgressIndicator(),
                ),
                Text(
                  AppLocalizations.of(context)!.translate('main/label-loading'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ],
            ),
          ),
        );
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
      return LayoutScreen(key);
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
