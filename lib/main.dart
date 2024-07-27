//  Main File - The root of our application
//
//  Author: The Linum Authors
//
//

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:linum/app.dart';
import 'package:linum/core/localization/settings/constants/supported_locales.dart';
import 'package:linum/core/navigation/main_route_information_parser.dart';
import 'package:linum/core/navigation/main_router_delegate.dart';
import 'package:linum/core/navigation/main_routes.dart';
import 'package:linum/generated/objectbox/objectbox.g.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wiredash/wiredash.dart';

Future<void> main({bool? testing}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final store = await openStore();

  if (testing != null && testing) {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  // Force Portrait Mode
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // Load .env
  await dotenv.load();

  final pref = await SharedPreferences.getInstance();

  FlutterError.onError = (details) async {
    await Sentry.captureException(details.exception, stackTrace: details.stack);
    FlutterError.presentError(details);
  };

  await SentryFlutter.init(
    (options) {
      options.dsn = dotenv.env['SENTRY_DSN'];
      options.tracesSampleRate = 1.0;
      options.profilesSampleRate = 1.0;
      options.diagnosticLevel = SentryLevel.warning;
    },
  );

  runApp(
    LifecycleWatcher(store: store, testing: testing, preferences: pref),
  );
}

/// Wrapper to handle global lifecycle changes, for example the app closing.
class LifecycleWatcher extends StatefulWidget {
  final Store store;
  final bool? testing;
  final SharedPreferences preferences;
  const LifecycleWatcher({
    super.key,
    required this.store,
    this.testing,
    required this.preferences,
  });

  @override
  State<LifecycleWatcher> createState() => _LifecycleWatcherState();
}

class _LifecycleWatcherState extends State<LifecycleWatcher> {
  @override
  Widget build(BuildContext context) {
    final MainRouterDelegate routerDelegate = MainRouterDelegate(
      defaultRoute: MainRoute.home,
    );

    final MainRouteInformationParser routeInformationParser =
        MainRouteInformationParser();
    // print("Rebuild LifecycleWatcher");
    return Wiredash(
      feedbackOptions: const WiredashFeedbackOptions(
        labels: [
          Label(id: 'label-ztqz1iic2d', title: 'Bug'),
          Label(id: 'label-vc1hsuuyj3', title: 'Improvement'),
          Label(id: 'label-eobuukbzgi', title: 'Praise'),
        ],
      ),
      projectId: dotenv.env[
          'WIREDASH_PROJECT_ID']!, //FUTURE Check if the null checks can cause issues and rewrite if necessary
      secret: dotenv.env['WIREDASH_SECRET']!,
      child: EasyLocalization(
        supportedLocales: supportedLocales,
        path: 'assets/lang',
        fallbackLocale: const Locale('de', 'DE'),
        child: Linum(
          store: widget.store,
          routerDelegate: routerDelegate,
          routeInformationParser: routeInformationParser,
          testing: widget.testing,
          preferences: widget.preferences,
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.store.close();
    super.dispose();
  }
}


/* class OnBoardingOrLayoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthenticationService auth =
        context.watch<AuthenticationService>();
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
} */
