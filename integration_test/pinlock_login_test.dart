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

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
      as IntegrationTestWidgetsFlutterBinding;

  HomeRobot homeRobot;
  OnboardingRobot onboardingRobot;
  OnboardingOpenSignUpRobot onboardingOpenSignUpRobot;
  OnboardingOpenSignInRobot onboardingOpenSignInRobot;
  OnboardingOpenMessageRobot onboardingOpenMessageRobot;
  NavbarRobot navbarRobot;

  group('[PIN-lock auth test] - ', () {
    testWidgets('Login - First Test Account', (WidgetTester tester) async {
      app.main(testing: true);
      sleep(const Duration(seconds: 2));

      await tester.pumpAndSettle(const Duration(seconds: 2));

      homeRobot = HomeRobot(tester);
      onboardingRobot = OnboardingRobot(tester);
      onboardingOpenSignUpRobot = OnboardingOpenSignUpRobot(tester);
      onboardingOpenSignInRobot = OnboardingOpenSignInRobot(tester);
      onboardingOpenMessageRobot = OnboardingOpenMessageRobot(tester);
      navbarRobot = NavbarRobot(tester);

      await onboardingRobot.pressIHaveAnAccount();

      await onboardingOpenSignInRobot.fillInEmail("linum-tester-1@byom.de");
      await onboardingOpenSignInRobot.fillInPassword("123456");
      await onboardingOpenSignInRobot.pressSignIn();

      await tester.pumpAndSettle(const Duration(seconds: 1));
      await navbarRobot.pressSettingsButton();
    });
  });
}
