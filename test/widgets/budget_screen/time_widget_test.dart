import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linum/backend_functions/local_app_localizations.dart';
import 'package:linum/frontend_functions/size_guide.dart';
import 'package:linum/widgets/budget_screen/time_widget.dart';

void main() {
  group("TimeWidget", () {
    testWidgets("should display given text in capslock",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(builder: (context) {
            SizeGuide().init(context);
            return TimeWidget(
              displayValue: "Test text",
              isTranslated: true,
            );
          }),
        ),
      );

      final textFinder = find.text("TEST TEXT");
      expect(textFinder, findsOneWidget);
    });

    testWidgets("should display given text translated",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(builder: (context) {
            SizeGuide().init(context);
            return TimeWidget(
              displayValue: "Test text",
              isTranslated: true,
            );
          }),
        ),
      );

      final textFinder = find.text("TEST TEXT");
      expect(textFinder, findsOneWidget);
    });
  });
}
