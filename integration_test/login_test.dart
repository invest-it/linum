//  Login Test - An Integration Test designed to extensively test the functionality of the Login (NOT THE SIGNUP) function of the app.
//
//  Author: SoTBurst
//  Co-Author: NightmindOfficial
//

// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:linum/main.dart' as app;

import 'robots/home_screen/home_robot.dart';
import 'robots/onboarding_screen/onboarding_open_message_robot.dart';
import 'robots/onboarding_screen/onboarding_open_sign_in.dart';
import 'robots/onboarding_screen/onboarding_open_sign_up.dart';
import 'robots/onboarding_screen/onboarding_robot.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  HomeRobot homeRobot;
  OnboardingRobot onboardingRobot;
  OnboardingOpenSignUpRobot onboardingOpenSignUpRobot;
  OnboardingOpenSignInRobot onboardingOpenSignInRobot;
  OnboardingOpenMessageRobot onboardingOpenMessageRobot;

  group('e2e test', () {
    testWidgets('login directly', (WidgetTester tester) async {
      await app.main(testing: true);
      sleep(const Duration(seconds: 2));

      await tester.pumpAndSettle(const Duration(seconds: 2));

      homeRobot = HomeRobot(tester);
      onboardingRobot = OnboardingRobot(tester);
      onboardingOpenSignUpRobot = OnboardingOpenSignUpRobot(tester);
      onboardingOpenSignInRobot = OnboardingOpenSignInRobot(tester);
      onboardingOpenMessageRobot = OnboardingOpenMessageRobot(tester);

      await onboardingRobot.pressIHaveAnAccount();

      await onboardingOpenSignInRobot.fillInEmail("linum-tester-1@byom.de");
      await onboardingOpenSignInRobot.fillInPassword("wrongPasswd");
      await onboardingOpenSignInRobot.pressSignIn();

      await onboardingOpenMessageRobot.findAndClickWrongPasswordMessage();

      await onboardingOpenSignInRobot.fillInPassword("123456");
      await onboardingOpenSignInRobot.pressSignIn();
    });
  });
}
