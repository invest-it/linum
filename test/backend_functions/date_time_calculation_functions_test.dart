import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';
import 'package:linum/backend_functions/date_time_calculation_functions.dart';

void main() {
  group("date_time_calculation_functions", () {
    group("calculateOneTimeStep", () {});
    group("monthlyStepCalculator", () {
      test("random year, month and day (with day <= 28)", () {
        final math.Random rand = math.Random();
        for (int i = 0; i < 100; i++) {
          // Arrange (Initialization)
          final int year = rand.nextInt(40) + 2000;
          final int month = rand.nextInt(12) + 1;
          final int day = rand.nextInt(28) + 1;

          final int monthStep = math.sqrt(rand.nextInt(576)).floor() + 1;

          final DateTime expectedDateTime =
              DateTime(year, month + monthStep, day);

          // Act (Execution)
          final DateTime dateTime =
              monthlyStepCalculator(year, month + monthStep, day);

          // Assert (Observation)
          expect(dateTime, expectedDateTime);
        }
      });
    });
  });
}
