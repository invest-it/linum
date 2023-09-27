//  Date Time Calculation Functions
//
//  Author: SoTBurst
//  Co-Author: n/a
//

import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';
import 'package:linum/core/balance/utils/date_time_calculation_functions.dart';

void main() {
  group("date_time_calculation_functions", () {
    group("calculateOneTimeStep", () {
      test("random data test (seconds)", () {
        final math.Random rand = math.Random();
        for (int i = 0; i < 1000; i++) {
          // Arrange (Initialization)
          final int stepsize =
              (math.sqrt(rand.nextInt(400 * 400)).floor() + 1) * 60 * 60 * 24;
          final DateTime currentTime = DateTime(
            rand.nextInt(40) + 2000,
            rand.nextInt(12) + 1,
            rand.nextInt(31) + 1,
          );

          final DateTime expectedDateTime =
              currentTime.add(Duration(seconds: stepsize));
          // Act (Execution)
          final DateTime dateTime =
              calculateOneTimeStep(stepsize, currentTime, monthly: false);

          // Assert (Observation)
          expect(dateTime, expectedDateTime);
        }
      });

      test("example data test (monthly)", () {
        // Arrange (Initialization)
        final DateTime currentTime = DateTime(2020, 7, 31);

        const int monthStep = 4;

        final DateTime expectedDateTime = DateTime(2020, 11, 30);

        // Act (Execution)
        final DateTime dateTime = calculateOneTimeStep(
          monthStep,
          currentTime,
          monthly: true,
          dayOfTheMonth: currentTime.day,
        );

        // Assert (Observation)
        expect(dateTime, expectedDateTime);
      });
    });

    group("calculateOneTimeStepBackwords", () {
      test("random data forward backward test (seconds)", () {
        final math.Random rand = math.Random();

        for (int i = 0; i < 4000; i++) {
          final int stepsize =
              (math.sqrt(rand.nextInt(400 * 400)).floor() + 1) * 60 * 60 * 24;
          final DateTime currentTime = DateTime(
            rand.nextInt(40) + 2000,
            rand.nextInt(12) + 1,
            rand.nextInt(31) + 1,
          );

          final DateTime dateTime1 = calculateOneTimeStepBackwards(
            stepsize,
            calculateOneTimeStep(stepsize, currentTime, monthly: false),
            monthly: false,
          );

          final DateTime dateTime2 = calculateOneTimeStep(
            stepsize,
            calculateOneTimeStepBackwards(
              stepsize,
              currentTime,
              monthly: false,
            ),
            monthly: false,
          );

          expect(dateTime1, currentTime);
          expect(dateTime2, currentTime);
        }
      });

      test("random data forward backward test (months)", () {
        final math.Random rand = math.Random();

        for (int i = 0; i < 4000; i++) {
          final int stepsize = math.sqrt(rand.nextInt(24 * 24)).floor() + 1;
          final DateTime currentTime = DateTime(
            rand.nextInt(40) + 2000,
            rand.nextInt(12) + 1,
            rand.nextInt(31) + 1,
          );

          final DateTime dateTime1 = calculateOneTimeStepBackwards(
            stepsize,
            calculateOneTimeStep(
              stepsize,
              currentTime,
              monthly: true,
              dayOfTheMonth: currentTime.day,
            ),
            monthly: true,
            dayOfTheMonth: currentTime.day,
          );

          final DateTime dateTime2 = calculateOneTimeStep(
            stepsize,
            calculateOneTimeStepBackwards(
              stepsize,
              currentTime,
              monthly: true,
              dayOfTheMonth: currentTime.day,
            ),
            monthly: true,
            dayOfTheMonth: currentTime.day,
          );

          expect(dateTime1, currentTime);
          expect(dateTime2, currentTime);
        }
      });

      // TODO
      /*
      test("random data test (seconds)", () {
        final math.Random rand = math.Random();
        for (int i = 0; i < 1000; i++) {
          // Arrange (Initialization)
          final int stepsize =
              (math.sqrt(rand.nextInt(400 * 400)).floor() + 1) * 60 * 60 * 24;
          final DateTime currentTime = DateTime(
            rand.nextInt(40) + 2000,
            rand.nextInt(12) + 1,
            rand.nextInt(31) + 1,
          );

          final DateTime expectedDateTime =
              currentTime.add(Duration(seconds: stepsize));
          // Act (Execution)
          final DateTime dateTime =
              calculateOneTimeStep(stepsize, currentTime, monthly: false);

          // Assert (Observation)
          expect(dateTime, expectedDateTime);
        }
      });

      test("example data test (monthly)", () {
        // Arrange (Initialization)
        final DateTime currentTime = DateTime(2020, 7, 31);

        const int monthStep = 4;

        final DateTime expectedDateTime = DateTime(2020, 11, 30);

        // Act (Execution)
        final DateTime dateTime = calculateOneTimeStep(
          monthStep,
          currentTime,
          monthly: true,
          dayOfTheMonth: currentTime.day,
        );

        // Assert (Observation)
        expect(dateTime, expectedDateTime);
      });
      
      */
    });

    group("monthlyStepCalculator", () {
      test("example 1 (day = 29)", () {
        // Arrange (Initialization)
        const int year = 2020;
        const int month = 5;
        const int day = 29;

        const int monthStep = 1;

        final DateTime expectedDateTime = DateTime(2020, 6, 29);

        // Act (Execution)
        final DateTime dateTime =
            monthlyStepCalculator(year, month + monthStep, day);

        // Assert (Observation)
        expect(dateTime, expectedDateTime);
      });

      test("example 2 (day = 29, target month=2, year=2021)", () {
        // Arrange (Initialization)
        const int year = 2021;
        const int month = 1;
        const int day = 29;

        const int monthStep = 1;

        final DateTime expectedDateTime = DateTime(2021, 2, 28);

        // Act (Execution)
        final DateTime dateTime =
            monthlyStepCalculator(year, month + monthStep, day);

        // Assert (Observation)
        expect(dateTime, expectedDateTime);
      });
      test("example 3 (day = 29, target month=2, year=2020)", () {
        // Arrange (Initialization)
        const int year = 2020;
        const int month = 1;
        const int day = 29;

        const int monthStep = 1;

        final DateTime expectedDateTime = DateTime(2020, 2, 29);

        // Act (Execution)
        final DateTime dateTime =
            monthlyStepCalculator(year, month + monthStep, day);

        // Assert (Observation)
        expect(dateTime, expectedDateTime);
      });

      test("example 4 (day = 30)", () {
        // Arrange (Initialization)
        const int year = 2020;
        const int month = 7;
        const int day = 30;

        const int monthStep = 3;

        final DateTime expectedDateTime = DateTime(2020, 10, 30);

        // Act (Execution)
        final DateTime dateTime =
            monthlyStepCalculator(year, month + monthStep, day);

        // Assert (Observation)
        expect(dateTime, expectedDateTime);
      });

      test("example 5 (day = 30, target month=2)", () {
        // Arrange (Initialization)
        const int year = 2018;
        const int month = 10;
        const int day = 30;

        const int monthStep = 4;

        final DateTime expectedDateTime = DateTime(2019, 2, 28);

        // Act (Execution)
        final DateTime dateTime =
            monthlyStepCalculator(year, month + monthStep, day);

        // Assert (Observation)
        expect(dateTime, expectedDateTime);
      });

      test("example 6 (day = 30, target month=2, year=2016)", () {
        // Arrange (Initialization)
        const int year = 2015;
        const int month = 7;
        const int day = 30;

        const int monthStep = 7;

        final DateTime expectedDateTime = DateTime(2016, 2, 29);

        // Act (Execution)
        final DateTime dateTime =
            monthlyStepCalculator(year, month + monthStep, day);

        // Assert (Observation)
        expect(dateTime, expectedDateTime);
      });

      test("example 7 (day = 31, target month=10)", () {
        // Arrange (Initialization)
        const int year = 2014;
        const int month = 7;
        const int day = 31;

        const int monthStep = 3;

        final DateTime expectedDateTime = DateTime(2014, 10, 31);

        // Act (Execution)
        final DateTime dateTime =
            monthlyStepCalculator(year, month + monthStep, day);

        // Assert (Observation)
        expect(dateTime, expectedDateTime);
      });

      test("example 8 (day = 31, target month=11)", () {
        // Arrange (Initialization)
        const int year = 2013;
        const int month = 4;
        const int day = 31;

        const int monthStep = 7;

        final DateTime expectedDateTime = DateTime(2013, 11, 30);

        // Act (Execution)
        final DateTime dateTime =
            monthlyStepCalculator(year, month + monthStep, day);

        // Assert (Observation)
        expect(dateTime, expectedDateTime);
      });

      test("random year, month and day (with day <= 28)", () {
        final math.Random rand = math.Random();
        for (int i = 0; i < 200; i++) {
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
