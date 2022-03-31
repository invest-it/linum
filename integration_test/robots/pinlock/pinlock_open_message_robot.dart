import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class PinlockOpenMessageRobot {
  const PinlockOpenMessageRobot(this.tester);

  final WidgetTester tester;

  Future<void> findAndClickResetPrompt() async {
    await _findAndClickMessage(
      "Are you sure?",
      "When you log out, the PIN lock is deactivated. This allows you to log in normally with your email and password if you forget your PIN code.",
    );
  }

  Future<void> _findAndClickMessage(
    String expectedMessageTitle,
    String expectedMessageBody,
  ) async {
    expect(find.text(expectedMessageTitle), findsOneWidget);
    expect(find.text(expectedMessageBody), findsOneWidget);

    final okayButtonFinder =
        find.widgetWithText(TextButton, "Log out and reset PIN");

    expect(okayButtonFinder, findsOneWidget);

    sleep(const Duration(milliseconds: 500));

    await tester.ensureVisible(okayButtonFinder);
    await tester.tap(okayButtonFinder);

    await tester.pumpAndSettle(const Duration(seconds: 1));
  }
}
