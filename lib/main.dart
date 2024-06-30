//  Main File - The root of our application
//
//  Author: The Linum Authors
//
//

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linum/app.dart';
import 'package:linum/core/localization/settings/constants/supported_locales.dart';
import 'package:linum/core/navigation/main_route_information_parser.dart';
import 'package:linum/core/navigation/main_router_delegate.dart';
import 'package:linum/core/navigation/main_routes.dart';
import 'package:linum/generated/objectbox/objectbox.g.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main({bool? testing}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final store = await openStore();

  if (testing != null && testing) {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  // Force Portrait Mode
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SharedPreferences.getInstance().then((pref) {
    runApp(
      LifecycleWatcher(store: store, testing: testing),
    );
  });

}

/// Wrapper to handle global lifecycle changes, for example the app closing.
class LifecycleWatcher extends StatefulWidget {
  final Store store;
  final bool? testing;
  const LifecycleWatcher({super.key, required this.store, this.testing});

  @override
  State<LifecycleWatcher> createState() => _LifecycleWatcherState();
}

class _LifecycleWatcherState extends State<LifecycleWatcher> {
  @override
  Widget build(BuildContext context) {
    final MainRouterDelegate routerDelegate = MainRouterDelegate(
      defaultRoute: MainRoute.home,
    );
    final MainRouteInformationParser routeInformationParser = MainRouteInformationParser();

    return EasyLocalization(
      supportedLocales: supportedLocales,
      path: 'assets/lang',
      fallbackLocale: const Locale('de', 'DE'),
      child: Linum(
          store: widget.store,
          routerDelegate: routerDelegate,
          routeInformationParser: routeInformationParser,
          testing: widget.testing,
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
