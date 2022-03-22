// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:linum/main.dart' as app;

import 'robots/home_robot.dart';
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

  group('e2e test', () {
    testWidgets('login directly', (WidgetTester tester) async {
      app.main(testing: true);
      sleep(const Duration(seconds: 2));

      await tester.pumpAndSettle(const Duration(seconds: 2));

      homeRobot = HomeRobot(tester);
      onboardingRobot = OnboardingRobot(tester);
      onboardingOpenSignUpRobot = OnboardingOpenSignUpRobot(tester);
      onboardingOpenSignInRobot = OnboardingOpenSignInRobot(tester);
      onboardingOpenMessageRobot = OnboardingOpenMessageRobot(tester);

      await onboardingRobot.pressIHaveAnAccount();

      await onboardingOpenSignInRobot
          .fillInEmail("soencke.evers@investit-academy.de");
      await onboardingOpenSignInRobot.fillInPassword("wrongPassword");
      await onboardingOpenSignInRobot.pressSignIn();

      await onboardingOpenMessageRobot.findAndClickWrongPasswordMessage();

      await onboardingOpenSignInRobot.fillInPassword("tempPasswort123");
      await onboardingOpenSignInRobot.pressSignIn();
    });
  });
}
