import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

class HomeRobot {
  const HomeRobot(this.tester);

  final WidgetTester tester;
/*
  Future<void> findTitle() async {
    await tester.pumpAndSettle();
    expect(find.text(HomeStrings.title), findsOneWidget);
    sleep(const Duration(seconds: 2));
  }

  Future<void> scrollThePage({bool scrollUp = false}) async {
    final listFinder = find.byKey(const Key('singleChildScrollView'));

    if (scrollUp) {
      await tester.fling(listFinder, const Offset(0, 500), 10000);
      await tester.pumpAndSettle();

      expect(find.text(HomeStrings.title), findsOneWidget);
    } else {
      await tester.fling(listFinder, const Offset(0, -500), 10000);
      await tester.pumpAndSettle();

      expect(find.text(HomeStrings.bottom), findsOneWidget);
    }
  }

  Future<void> clickFirstButton() async {
    final btnFinder = find.byKey(const Key(HomeStrings.bOp1));

    await tester.ensureVisible(btnFinder);
    await tester.tap(btnFinder);

    await tester.pumpAndSettle();
  }

  Future<void> clickSecondButton() async {
    final btnFinder = find.byKey(const Key(HomeStrings.bOp2));

    await tester.ensureVisible(btnFinder);
    await tester.tap(btnFinder);

    await tester.pumpAndSettle();
  }*/
}
