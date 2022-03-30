import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class GeneralRobot {
  const GeneralRobot(this.tester);

  final WidgetTester tester;

  Future<void> pressVisibleUniqueButton(
    String text, {
    Type buttonType = TextButton,
    Duration settleDuration = const Duration(seconds: 2),
    Duration sleepDuration = const Duration(milliseconds: 500),
  }) async {
    final signInFinder = find.widgetWithText(buttonType, text);

    expect(signInFinder, findsOneWidget);

    sleep(sleepDuration);

    await tester.ensureVisible(signInFinder);
    await tester.tap(signInFinder);

    await tester.pumpAndSettle(settleDuration);
  }

  Future<void> fillInText(String key, String text) async {
    final Finder textField = find.byKey(Key(key));
    expect(textField, findsOneWidget);
    sleep(const Duration(milliseconds: 500));

    await tester.ensureVisible(textField);
    await tester.enterText(textField, text);

    await tester.pumpAndSettle();
  }
}
