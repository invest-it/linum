import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

import '../general/general_robot.dart';

class OnboardingRobot extends GeneralRobot {
  const OnboardingRobot(WidgetTester tester) : super(tester);

  Future<void> pressSignUpNow() async {
    await pressVisibleButtonByString("Sign up now!",
        buttonType: GradientButton);
  }

  Future<void> pressIHaveAnAccount() async {
    await pressVisibleButtonByString(
      "I have an account",
      buttonType: CupertinoButton,
    );
  }
}
