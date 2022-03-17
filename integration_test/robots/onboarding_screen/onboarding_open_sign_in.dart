import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

class OnboardingOpenSignInRobot {
  const OnboardingOpenSignInRobot(this.tester);

  final WidgetTester tester;
  Future<void> fillInEmail(String email) async {
    await _fillInText("loginEmailField", email);
  }

  Future<void> fillInPassword(String pwd) async {
    await _fillInText("loginPasswordField", pwd);
  }

  Future<void> _fillInText(String key, String text) async {
    final Finder textField = find.byKey(Key(key));
    expect(textField, findsOneWidget);
    sleep(const Duration(milliseconds: 500));

    await tester.ensureVisible(textField);
    await tester.enterText(textField, text);

    await tester.pumpAndSettle();
  }

  Future<void> pressSignIn() async {
    final signInFinder = find.widgetWithText(GradientButton, "Sign in");

    expect(signInFinder, findsOneWidget);

    sleep(const Duration(milliseconds: 500));

    await tester.ensureVisible(signInFinder);
    await tester.tap(signInFinder);

    await tester.pumpAndSettle(Duration(seconds: 3));
    sleep(const Duration(milliseconds: 500));
  }
}
