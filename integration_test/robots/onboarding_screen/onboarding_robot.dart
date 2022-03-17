import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

class OnboardingRobot {
  const OnboardingRobot(this.tester);

  final WidgetTester tester;

  Future<void> pressSignUpNow() async {
    await _pressButtonByText("Sign up now!", GradientButton);
  }

  Future<void> pressIHaveAnAccount() async {
    await _pressButtonByText("I have an account", CupertinoButton);
  }

  Future<void> _pressButtonByText(String text, Type buttonType) async {
    expect(find.text(text), findsOneWidget);
    sleep(const Duration(milliseconds: 500));

    final signUpTextFinder = find.text(text);
    final signUpButtonFinder =
        find.ancestor(of: signUpTextFinder, matching: find.byType(buttonType));

    await tester.ensureVisible(signUpButtonFinder);
    await tester.tap(signUpButtonFinder);

    await tester.pumpAndSettle();
  }

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
  }
  */
}

class FinderType extends Finder {
  FinderType(this.finder, this.key);

  final Finder finder;
  final Key key;

  @override
  Iterable<Element> apply(Iterable<Element> candidates) {
    return finder.apply(candidates);
  }

  @override
  String get description => finder.description;

  Finder get title => find.descendant(of: this, matching: find.byKey(key));
}
