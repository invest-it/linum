// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:linum/main.dart' as app;

import 'robots/home_robot.dart';
import 'robots/navbar/navbar_robot.dart';
import 'robots/onboarding_screen/onboarding_open_message_robot.dart';
import 'robots/onboarding_screen/onboarding_open_sign_in.dart';
import 'robots/onboarding_screen/onboarding_open_sign_up.dart';
import 'robots/onboarding_screen/onboarding_robot.dart';
import 'robots/settings_screen/settings_auth_robot.dart';
import 'robots/settings_screen/settings_pinlock_robot.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
      as IntegrationTestWidgetsFlutterBinding;

  OnboardingRobot onboardingRobot;
  OnboardingOpenSignInRobot onboardingOpenSignInRobot;
  SettingsPinlockRobot settingsPinlockRobot;
  SettingsAuthRobot settingsAuthRobot;
  NavbarRobot navbarRobot;

  group('[PIN-lock auth test] - ', () {
    testWidgets('Login - First Test Account', (WidgetTester tester) async {
      app.main(testing: true);
      sleep(const Duration(seconds: 2));

      await tester.pumpAndSettle(const Duration(seconds: 2));

      onboardingRobot = OnboardingRobot(tester);
      onboardingOpenSignInRobot = OnboardingOpenSignInRobot(tester);
      settingsPinlockRobot = SettingsPinlockRobot(tester);
      settingsAuthRobot = SettingsAuthRobot(tester);
      navbarRobot = NavbarRobot(tester);

      await onboardingRobot.pressIHaveAnAccount();

      await onboardingOpenSignInRobot.fillInEmail("linum-tester-1@byom.de");
      await onboardingOpenSignInRobot.fillInPassword("123456");
      await onboardingOpenSignInRobot.pressSignIn();

      await tester.pumpAndSettle(const Duration(seconds: 1));
      await navbarRobot.pressSettingsButton();

      await settingsPinlockRobot.togglePINLock();
      await settingsPinlockRobot.dialInPIN();

      sleep(const Duration(seconds: 5));
      settingsAuthRobot.pressLogoutButton();
    });

    // TODO Continue this testing procedure
    testWidgets("Login - Second Test Account", (WidgetTester tester) async {
      app.main(testing: true);
      sleep(const Duration(seconds: 2));

      await tester.pumpAndSettle(const Duration(seconds: 2));

      onboardingRobot = OnboardingRobot(tester);
      onboardingOpenSignInRobot = OnboardingOpenSignInRobot(tester);

      await onboardingRobot.pressIHaveAnAccount();

      await onboardingOpenSignInRobot.fillInEmail("linum-tester-2@byom.de");
      await onboardingOpenSignInRobot.fillInPassword("123456");
      await onboardingOpenSignInRobot.pressSignIn();
    });
  });
}
