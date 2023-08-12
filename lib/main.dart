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

  /// Force Portrait Mode
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SharedPreferences.getInstance().then((pref) {
    // LinumApp.currentLocalLanguageCode = pref.getString("languageCode");
    runApp(
      LifecycleWatcher(store: store, testing: testing),
    );
  });

}

//
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
    return EasyLocalization(
      supportedLocales: supportedLocales,
      path: 'assets/lang',
      fallbackLocale: const Locale('de', 'DE'),
      child: LinumApp(widget.store, testing: widget.testing),
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
