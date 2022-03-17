import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class OnboardingOpenMessageRobot {
  const OnboardingOpenMessageRobot(this.tester);

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

    await tester.pumpAndSettle(Duration(seconds: 1));
  }

  Future<void> findAndClickWrongPasswordMessage() async {
    await _findAndClickMessage("Login not successful",
        "Your email or password is not correct. Check for spelling errors?");
  }

  Future<void> _findAndClickMessage(
      String expectedMessageTitle, String expectedMessageBody) async {
    expect(find.text(expectedMessageTitle), findsOneWidget);
    expect(find.text(expectedMessageBody), findsOneWidget);

    final okayButtonFinder = find.widgetWithText(TextButton, "Okay");

    expect(okayButtonFinder, findsOneWidget);

    sleep(const Duration(milliseconds: 500));

    await tester.ensureVisible(okayButtonFinder);
    await tester.tap(okayButtonFinder);

    await tester.pumpAndSettle(Duration(seconds: 1));
  }
}
