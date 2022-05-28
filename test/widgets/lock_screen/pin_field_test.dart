//  PIN Field Widget Test
//
//  Author: SoTBurst
//  Co-Author: n/a
//

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linum/constants/main_theme_data.dart';
import 'package:linum/constants/ring_colors.dart';
import 'package:linum/utilities/frontend/size_guide.dart';
import 'package:linum/widgets/lock_screen/pin_field.dart';

void main() {
  group('PinField', () {
    const Key key = Key("MyPinFieldKey");
    testWidgets('Test the initial state of the widget', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: MainThemeData.lightTheme,
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                SizeGuide.init(context);
                return const PinField(1, 0, RingColors.green, key: key);
              },
            ),
          ),
        ),
      );
      final Finder ring = find.byKey(key);
      final colorScheme = MainThemeData.lightTheme.colorScheme;
      final bool Function(Widget) hasWidgetBoxDecoration = (Widget widget) =>
          widget is Container && widget.decoration is BoxDecoration;

      expect(ring, findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              hasWidgetBoxDecoration(widget) &&
              ((widget as Container).decoration! as BoxDecoration).color ==
                  colorScheme.background,
        ),
        findsOneWidget,
      );

      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              hasWidgetBoxDecoration(widget) &&
              ((widget as Container).decoration! as BoxDecoration)
                      .boxShadow?[1]
                      .color ==
                  RingColors.green,
        ),
        findsOneWidget,
      );
    });

    testWidgets('Test when Pin is already written', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: MainThemeData.lightTheme,
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                SizeGuide.init(context);
                return const PinField(1, 2, RingColors.green, key: key);
              },
            ),
          ),
        ),
      );
      final Finder ring = find.byKey(key);
      final colorScheme = MainThemeData.lightTheme.colorScheme;
      final bool Function(Widget) hasWidgetBoxDecoration = (Widget widget) =>
          widget is Container && widget.decoration is BoxDecoration;

      expect(ring, findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              hasWidgetBoxDecoration(widget) &&
              ((widget as Container).decoration! as BoxDecoration).color ==
                  colorScheme.tertiary,
        ),
        findsOneWidget,
      );

      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              hasWidgetBoxDecoration(widget) &&
              ((widget as Container).decoration! as BoxDecoration)
                      .boxShadow?[1]
                      .color ==
                  Colors.black.withAlpha(0), // no color
        ),
        findsOneWidget,
      );
    });
  });
}
