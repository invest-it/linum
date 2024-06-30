//  Onboarding Open Sign In Robot - A Robot specifically designed to perform tasks on the Sign in section of the Onboarding Screen.
//
//  Author: SoTBurst
//  Co-Author: NightmindOfficial
//

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:linum/common/widgets/gradient_button.dart';

import '../general/general_robot.dart';

class OnboardingOpenSignInRobot extends GeneralRobot {
  const OnboardingOpenSignInRobot(super.tester);

  Future<void> fillInEmail(String email) async {
    await fillInText("loginEmailField", email);
  }

  Future<void> fillInPassword(String pwd) async {
    await fillInText("loginPasswordField", pwd);
  }

  Future<void> pressSignIn() async {
    await pressVisibleButtonByString("Sign in", buttonType: GradientButton);

    sleep(const Duration(milliseconds: 500));
  }
}
