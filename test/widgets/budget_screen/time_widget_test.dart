//  Time Widget Test
//
//  Author: SoTBurst
//  Co-Author: n/a
//

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linum/providers/size_guide_provider.dart';
import 'package:linum/widgets/budget_screen/time_widget.dart';
import 'package:provider/provider.dart';

void main() {
  group("TimeWidget", () {
    testWidgets("should display given text in capslock",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<SizeGuideProvider>(
                create: (ctx) => SizeGuideProvider(ctx),
              )
            ],
            child: const TimeWidget(
              displayValue: "Test text",
              isTranslated: true,
            ),
          ),
        ),
      );

      final textFinder = find.text("TEST TEXT");
      expect(textFinder, findsOneWidget);
    });
  });
}
