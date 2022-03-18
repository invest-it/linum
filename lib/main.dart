import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linum/backend_functions/local_app_localizations.dart';
import 'package:linum/frontend_functions/materialcolor_creator.dart';
import 'package:linum/frontend_functions/size_guide.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/providers/algorithm_provider.dart';
import 'package:linum/providers/balance_data_provider.dart';
import 'package:linum/providers/onboarding_screen_provider.dart';
import 'package:linum/providers/screen_index_provider.dart';
import 'package:linum/screens/layout_screen.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:linum/providers/account_settings_provider.dart';
import 'package:linum/screens/onboarding_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main({bool? testing}) {
  WidgetsFlutterBinding.ensureInitialized();

  /// Force Portrait Mode
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SharedPreferences.getInstance().then((pref) {
    MyApp.currentLocalLanguageCode = pref.getString("languageCode");
    runApp(MyApp(testing));
  });
}

class MyApp extends StatelessWidget {
  final bool? testing;

  MyApp(this.testing);

  static String? currentLocalLanguageCode;

  @override
  Widget build(BuildContext context) {
    // return _wrapWithBanner(MaterialApp(
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Linum',
      theme: ThemeData(
        //This is the colorScheme where we store the colors
        //the names should be self explaining
        //all those that are not custom are just fillers as ColorScheme lists
        //them all as required

        //use like this: Theme.of(context).colorScheme.NAME_OF_COLOR_STYLE
        colorScheme: ColorScheme(
          primary: createMaterialColor(Color(0xFF97BC4E)),
          primaryContainer: Colors.green,
          secondary: createMaterialColor(Color(0xFF505050)),
          secondaryContainer: Colors.white,
          tertiary: createMaterialColor(Color(0xFFC1E695)),
          tertiaryContainer: createMaterialColor(Color(0xFF808080)),
          surface: createMaterialColor(Color(0xFFC1E695)),
          background: createMaterialColor(Color(0xFFFAFAFA)),
          error: createMaterialColor(Color(0xFFEB5757)),
          errorContainer:
              createMaterialColor(Color.fromARGB(255, 250, 171, 171)),
          onPrimary: createMaterialColor(Color(0xFFFAFAFA)),
          onSecondary: createMaterialColor(Color(0xFFFAFAFA)),
          onSurface: createMaterialColor(Color(0xFF505050)),
          onBackground: Colors.black12,
          onError: Colors.teal,
          brightness: Brightness.light,
        ),

        // This is the generic textTheme where we store most basic applications
        // of different text styles. The names should be self-explaining.
        //use like this: Theme.of(context).textTheme.THEME_TYPE

        //we should discuss as whether to augment bis by adding an own @TODO
        // e.g. for the HEADLINER function
        textSelectionTheme:
            TextSelectionThemeData(selectionHandleColor: Colors.transparent),
        textTheme: TextTheme(
          headline1: GoogleFonts.dmSans(
            fontSize: 39.81,
            fontWeight: FontWeight.w700,
            letterSpacing: -1.5,
            color: createMaterialColor(Color(0xFF303030)),
          ),
          headline2: GoogleFonts.dmSans(
            fontSize: 33.18,
            fontWeight: FontWeight.w500,
            color: createMaterialColor(Color(0xFF303030)),
          ),
          headline3: GoogleFonts.dmSans(
            fontSize: 27.65,
            fontWeight: FontWeight.w500,
            color: createMaterialColor(Color(0xFF303030)),
          ),
          headline4: GoogleFonts.dmSans(
            fontSize: 23.04,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.25,
            color: createMaterialColor(Color(0xFF303030)),
          ),
          headline5: GoogleFonts.dmSans(
            fontSize: 19.2,
            fontWeight: FontWeight.w500,
            color: createMaterialColor(Color(0xFF202020)),
          ),
          //the text theme for the big headlines telling the page's name
          headline6: GoogleFonts.dmSans(
            fontSize: 84,
            letterSpacing: -1.5,
            fontWeight: FontWeight.w700,
            color: createMaterialColor(
              Color(0xFFC1E695),
            ),
          ),
          bodyText1: GoogleFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.16,
          ),
          bodyText2: GoogleFonts.dmSans(
            fontSize: 13.33,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.08,
          ),
          overline: GoogleFonts.dmSans(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: createMaterialColor(Color(0xFF505050))),
          button: GoogleFonts.dmSans(
              fontSize: 19.2,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.15,
              color: createMaterialColor(Color(0xFFFAFAFA))),
        ),
      ),

      // End of Theme Data.

      home: MyHomePage(title: 'Linum', testing: testing),

      // Specified Localizations
      supportedLocales: [
        Locale('en', 'US'),
        Locale('de', 'DE'),
        Locale('nl', 'NL'),
        Locale('es', 'ES'),
        Locale('fr', 'FR')
      ],

      localizationsDelegates: [
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
        for (var supportedLocale in supportedLocales) {
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

class MyHomePage extends StatefulWidget {
  final bool? testing;
  MyHomePage({Key? key, required this.title, this.testing}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState(testing);
}

class _MyHomePageState extends State<MyHomePage> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  final bool? testing;
  _MyHomePageState(this.testing);

  @override
  Widget build(BuildContext context) {
    // Initialize Size Guide for responsive behaviour
    SizeGuide().init(context);

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
          return MultiProvider(
            key: Key("MainMultiProvider"),
            providers: [
              ChangeNotifierProvider<AuthenticationService>(
                key: Key("AuthenticationChangeNotifierProvider"),
                create: (_) {
                  AuthenticationService auth =
                      AuthenticationService(FirebaseAuth.instance, context);
                  if (testing != null && testing!) {
                    auth.signOut();
                    while (auth.isLoggedIn) {
                      sleep(Duration(milliseconds: 50));
                      // this should only be called when we are testing.
                    }
                  }

                  return auth;
                },
                lazy: false,
              ),
              ChangeNotifierProxyProvider<AuthenticationService,
                  AccountSettingsProvider>(
                create: (ctx) {
                  return AccountSettingsProvider(ctx);
                },
                update: (ctx, auth, oldAccountSettings) {
                  if (oldAccountSettings != null) {
                    return oldAccountSettings..updateAuth(auth, ctx);
                  } else {
                    return AccountSettingsProvider(ctx);
                  }
                },
                lazy: false,
              ),
              ChangeNotifierProvider<AlgorithmProvider>(
                create: (_) => AlgorithmProvider(),
                lazy: false,
              ),
              ChangeNotifierProxyProvider2<AuthenticationService,
                  AlgorithmProvider, BalanceDataProvider>(
                create: (ctx) {
                  return BalanceDataProvider(ctx);
                },
                update: (ctx, auth, algo, oldBalance) {
                  if (oldBalance != null) {
                    oldBalance.updateAuth(auth);
                    return oldBalance..updateAlgorithmProvider(algo);
                  } else {
                    return BalanceDataProvider(ctx);
                  }
                },
                lazy: false,
              ),
              ChangeNotifierProxyProvider<AlgorithmProvider,
                      ScreenIndexProvider>(
                  create: (ctx) => ScreenIndexProvider(ctx),
                  update: (ctx, algo, oldScreenIndexProvider) {
                    if (oldScreenIndexProvider == null) {
                      return ScreenIndexProvider(ctx);
                    } else {
                      return oldScreenIndexProvider
                        ..updateAlgorithmProvider(algo);
                    }
                  }),
              ChangeNotifierProvider<ActionLipStatusProvider>(
                create: (_) => ActionLipStatusProvider(),
              ),
            ],
            child: OnBoardingOrLayoutScreen(),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 32.0),
                  child: CircularProgressIndicator(
                    value: null,
                  ),
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

// ignore: unused_element
Widget _wrapWithBanner(Widget child) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: Banner(
      child: child,
      location: BannerLocation.bottomEnd,
      message: 'ALPHA',
      color: Colors.white.withOpacity(1),
      textStyle: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 12.0,
        letterSpacing: 1.0,
        color: Color(0xFF79BC4E),
      ),
      textDirection: TextDirection.ltr,
    ),
  );
}

class OnBoardingOrLayoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthenticationService auth = Provider.of<AuthenticationService>(context);

    return auth.isLoggedIn
        ? LayoutScreen(key)
        : MultiProvider(
            providers: [
              ChangeNotifierProvider<OnboardingScreenProvider>(
                create: (_) => OnboardingScreenProvider(),
              ),
            ],
            child: OnboardingPage(),
          );
  }
}
