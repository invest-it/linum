//  Numerical Field Widget Test
//
//  Author: SoTBurst
//  Co-Author: n/a
//

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linum/widgets/lock_screen/numeric_field.dart';

import '../../../integration_test/robots/general/general_robot.dart';

void main() {
  group('NumericField', () {
    testWidgets('It shows its number', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                NumericField(6, (int _) {}),
              ],
            ),
          ),
        ),
      );
      expect(find.text('6'), findsOneWidget);
    });

    testWidgets('Pressing the button works as expected', (tester) async {
      int thisValue = 0;
      final GeneralRobot generalRobot = GeneralRobot(tester);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                NumericField(4, (int a) {
                  thisValue = a;
                }),
              ],
            ),
          ),
        ),
      );
      expect(thisValue, 0);

      await generalRobot.pressVisibleButtonByString("4");

      expect(thisValue, 4);
    });
  });
}
