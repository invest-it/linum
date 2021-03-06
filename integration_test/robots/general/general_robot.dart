//  General Robot - A Robot File that can perform user-like interactions in integration tests.
//
//  Author: SoTBurst
//  Co-Author: NightmindOfficial
//

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class GeneralRobot {
  const GeneralRobot(this.tester);

  final WidgetTester tester;

  Future<void> pressVisibleButtonByString(
    String text, {
    Type buttonType = TextButton,
    Duration settleDuration = const Duration(milliseconds: 500),
    Duration sleepDuration = const Duration(milliseconds: 250),
  }) async {
    final Finder targetFinder = find.widgetWithText(buttonType, text);
    await _executePressButton(targetFinder, settleDuration, sleepDuration);
  }

  Future<void> pressVisibleButtonByKey(
    String key, {
    Duration settleDuration = const Duration(seconds: 2),
    Duration sleepDuration = const Duration(milliseconds: 500),
  }) async {
    final Finder targetFinder = find.byKey(Key(key));
    await _executePressButton(targetFinder, settleDuration, sleepDuration);
  }

  Future<void> _executePressButton(
    Finder target,
    Duration settleDuration,
    Duration sleepDuration,
  ) async {
    expect(target, findsOneWidget);
    sleep(sleepDuration);
    await tester.tap(target);
    await tester.pumpAndSettle(settleDuration);
  }

  Future<void> dragToKey(
    String targetKey,
    String viewKey, {
    Offset customOffset = const Offset(0.0, -4000.0),
    Duration settleDuration = const Duration(seconds: 2),
  }) async {
    final Finder targetFinder = find.byKey(Key(targetKey));
    final Finder viewFinder = find.byKey(Key(viewKey));

    await tester.dragUntilVisible(
      targetFinder,
      viewFinder,
      customOffset,
    );
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
