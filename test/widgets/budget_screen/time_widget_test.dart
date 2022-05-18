import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linum/utilities/frontend/size_guide.dart';
import 'package:linum/widgets/budget_screen/time_widget.dart';

void main() {
  group("TimeWidget", () {
    testWidgets("should display given text in capslock",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              SizeGuide.init(context);
              return const TimeWidget(
                displayValue: "Test text",
                isTranslated: true,
              );
            },
          ),
        ),
      );

      final textFinder = find.text("TEST TEXT");
      expect(textFinder, findsOneWidget);
    });
  });
}
