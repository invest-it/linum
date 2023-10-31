//  Time Widget Test
//
//  Author: SoTBurst
//  Co-Author: n/a
//

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linum/screens/home_screen/widgets/time_widget.dart';

void main() {
  group("TimeWidget", () {
    testWidgets("should display given text in capslock",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TimeWidget(
              label: "Test text",
              isTranslated: true,
          ),
        ),
      );

      final textFinder = find.text("TEST TEXT");
      expect(textFinder, findsOneWidget);
    });
  });
}
