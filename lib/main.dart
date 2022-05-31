//  Main File - The root of our application
//
//  Author: The Linum Authors
//
//

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linum/app.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:linum/providers/onboarding_screen_provider.dart';
import 'package:linum/screens/layout_screen.dart';
import 'package:linum/screens/onboarding_screen.dart';
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
