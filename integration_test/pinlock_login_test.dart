//  Pin Lock Login Test - An Integration Test designed to extensively test the functionality of the PIN lock within the application.
//
//  Author: NightmindOfficial
//  Co-Author: SoTBurst
//

// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:linum/main.dart' as app;

import 'robots/home_screen/home_robot.dart';
import 'robots/navbar/navbar_robot.dart';
import 'robots/onboarding_screen/onboarding_open_sign_in.dart';
import 'robots/onboarding_screen/onboarding_robot.dart';
import 'robots/pinlock/pinlock_open_message_robot.dart';
import 'robots/pinlock/pinlock_robot.dart';
import 'robots/settings_screen/settings_auth_robot.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  OnboardingRobot onboardingRobot;
  OnboardingOpenSignInRobot onboardingOpenSignInRobot;
  PinlockRobot settingsPinlockRobot;
  SettingsAuthRobot settingsAuthRobot;
  NavbarRobot navbarRobot;
  HomeRobot homeRobot;
  PinlockOpenMessageRobot pinlockOpenMessageRobot;

  group('[PIN-lock auth test] - ', () {
    testWidgets('One Account (toggle, change, recall)',
        (WidgetTester tester) async {
      await app.main(testing: true);
      sleep(const Duration(seconds: 2));

      await tester.pumpAndSettle(const Duration(seconds: 2));

      onboardingRobot = OnboardingRobot(tester);
      onboardingOpenSignInRobot = OnboardingOpenSignInRobot(tester);
      settingsPinlockRobot = PinlockRobot(tester);
      settingsAuthRobot = SettingsAuthRobot(tester);
      navbarRobot = NavbarRobot(tester);
      homeRobot = HomeRobot(tester);

      await onboardingRobot.pressIHaveAnAccount();

      await onboardingOpenSignInRobot.fillInEmail("linum-tester-1@byom.de");
      await onboardingOpenSignInRobot.fillInPassword("123456");
      await onboardingOpenSignInRobot.pressSignIn();

      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Set first PIN - 1234

      await navbarRobot.pressSettingsButton();
      await settingsPinlockRobot.togglePINLock();
      await settingsPinlockRobot.dialInPINWithIntentionalErrors(1, 2, 3, 4);

      // Check if PIN recall works

      sleep(const Duration(seconds: 1));
      await navbarRobot.pressHomeButton();
      await homeRobot.pressPINLockButton();

      await settingsPinlockRobot.dialInPIN(1, 2, 3, 5);
      await settingsPinlockRobot.dialInPIN(1, 2, 3, 4);

      // CHANGE

      await navbarRobot.pressSettingsButton();
      await settingsPinlockRobot.togglePINChange();
      await settingsPinlockRobot.dialInPIN(2, 4, 0, 3);

      // Check change effectiveness

      sleep(const Duration(seconds: 1));
      await navbarRobot.pressHomeButton();
      await homeRobot.pressPINLockButton();

      await settingsPinlockRobot.dialInPIN(1, 2, 3, 4);
      await settingsPinlockRobot.dialInPIN(2, 4, 0, 3);

      // Check if PIN is recalled correctly on new login (2403)

      await navbarRobot.pressSettingsButton();
      await settingsAuthRobot.pressLogoutButton();

      await onboardingRobot.pressIHaveAnAccount();

      await onboardingOpenSignInRobot.fillInEmail("linum-tester-1@byom.de");
      await onboardingOpenSignInRobot.fillInPassword("123456");
      await onboardingOpenSignInRobot.pressSignIn();

      await settingsPinlockRobot.dialInPIN(9, 1, 1, 0);
      await settingsPinlockRobot.dialInPIN(2, 4, 0, 3);

      // Turn off PIN again and log out again

      await navbarRobot.pressSettingsButton();
      await settingsPinlockRobot.togglePINLock();
      await settingsAuthRobot.pressLogoutButton();
    });
    testWidgets("Two accounts", (WidgetTester tester) async {
      await app.main(testing: true);
      sleep(const Duration(seconds: 2));

      await tester.pumpAndSettle(const Duration(seconds: 2));

      onboardingRobot = OnboardingRobot(tester);
      onboardingOpenSignInRobot = OnboardingOpenSignInRobot(tester);
      navbarRobot = NavbarRobot(tester);
      settingsAuthRobot = SettingsAuthRobot(tester);
      settingsPinlockRobot = PinlockRobot(tester);
      homeRobot = HomeRobot(tester);
      pinlockOpenMessageRobot = PinlockOpenMessageRobot(tester);

      // LOGIN ACC 1 - SET PIN 1234 - LOGOUT ACC 1

      await onboardingRobot.pressIHaveAnAccount();

      await onboardingOpenSignInRobot.fillInEmail("linum-tester-1@byom.de");
      await onboardingOpenSignInRobot.fillInPassword("123456");
      await onboardingOpenSignInRobot.pressSignIn();

      await tester.pumpAndSettle(const Duration(seconds: 1));

      await navbarRobot.pressSettingsButton();
      await settingsPinlockRobot.togglePINLock();
      await settingsPinlockRobot.dialInPIN(1, 2, 3, 4);

      await settingsAuthRobot.pressLogoutButton();

      // LOGIN ACC 2 - SET PIN 5678
      await onboardingRobot.pressIHaveAnAccount();

      await onboardingOpenSignInRobot.fillInEmail("linum-tester-2@byom.de");
      await onboardingOpenSignInRobot.fillInPassword("123456");
      await onboardingOpenSignInRobot.pressSignIn();
      await navbarRobot.pressSettingsButton();

      await settingsPinlockRobot.togglePINLock();
      await settingsPinlockRobot.dialInPIN(5, 6, 7, 8);

      await settingsAuthRobot.pressLogoutButton();

      // MUTUAL EXCLUSIVITY (TRY 1 in 2)

      await onboardingRobot.pressIHaveAnAccount();

      await onboardingOpenSignInRobot.fillInEmail("linum-tester-2@byom.de");
      await onboardingOpenSignInRobot.fillInPassword("123456");
      await onboardingOpenSignInRobot.pressSignIn();

      await settingsPinlockRobot.dialInPIN(1, 2, 3, 4);
      await settingsPinlockRobot.dialInPIN(5, 6, 7, 8);

      await navbarRobot.pressSettingsButton();
      await settingsAuthRobot.pressLogoutButton();

      // MUTUAL EXCLUSIVITY (TRY 2 in 1)

      await onboardingRobot.pressIHaveAnAccount();

      await onboardingOpenSignInRobot.fillInEmail("linum-tester-1@byom.de");
      await onboardingOpenSignInRobot.fillInPassword("123456");
      await onboardingOpenSignInRobot.pressSignIn();

      await settingsPinlockRobot.dialInPIN(5, 6, 7, 8);
      await settingsPinlockRobot.dialInPIN(1, 2, 3, 4);

      // TURN OFF 1, CHECK FOR 2, then set new PIN 7890 for 2 again and try to reset

      await navbarRobot.pressSettingsButton();
      await settingsPinlockRobot.togglePINLock();

      await settingsAuthRobot.pressLogoutButton();

      await onboardingRobot.pressIHaveAnAccount();

      await onboardingOpenSignInRobot.fillInEmail("linum-tester-2@byom.de");
      await onboardingOpenSignInRobot.fillInPassword("123456");
      await onboardingOpenSignInRobot.pressSignIn();

      await settingsPinlockRobot.dialInPIN(1, 2, 3, 4);
      await settingsPinlockRobot.dialInPIN(5, 6, 7, 8);

      await navbarRobot.pressSettingsButton();
      await settingsPinlockRobot.togglePINChange();
      await settingsPinlockRobot.dialInPIN(7, 8, 9, 0);

      sleep(const Duration(seconds: 1));
      await navbarRobot.pressHomeButton();
      await homeRobot.pressPINLockButton();

      await settingsPinlockRobot.togglePINReset();
      await pinlockOpenMessageRobot.findAndClickResetPrompt();

      sleep(const Duration(seconds: 1));

      //now try to log in one last time

      await onboardingRobot.pressIHaveAnAccount();

      await onboardingOpenSignInRobot.fillInEmail("linum-tester-2@byom.de");
      await onboardingOpenSignInRobot.fillInPassword("123456");
      await onboardingOpenSignInRobot.pressSignIn();

      //if it works, we should be able to log out without entering a password

      await navbarRobot.pressSettingsButton();
      await settingsAuthRobot.pressLogoutButton();
    });
  });
}
