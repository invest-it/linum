import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

import '../general/general_robot.dart';

class OnboardingOpenSignInRobot extends GeneralRobot {
  const OnboardingOpenSignInRobot(tester) : super(tester);

  Future<void> fillInEmail(String email) async {
    await fillInText("loginEmailField", email);
  }

  Future<void> fillInPassword(String pwd) async {
    await fillInText("loginPasswordField", pwd);
  }

  Future<void> pressSignIn() async {
    await pressVisibleUniqueButton("Sign in", buttonType: GradientButton);

    sleep(const Duration(milliseconds: 500));
  }
}
