//  Repeated Balance Data Manager Test
//
//  Author: SoTBurst
//  Co-Author: n/a
//

import 'dart:developer' as dev;
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linum/constants/repeat_duration_type_enum.dart';
import 'package:linum/constants/repeatable_change_type_enum.dart';
import 'package:linum/models/balance_document.dart';
import 'package:linum/models/repeat_balance_data.dart';
import 'package:linum/utilities/backend/date_time_calculation_functions.dart';
import 'package:linum/utilities/backend/repeated_balance_help_functions.dart';
import 'package:linum/utilities/balance_data/repeated_balance_data_manager.dart';
import 'package:uuid/uuid.dart';

void main() {
  group("RepeatedBalanceDataManager", () {
    group("addRepeatedBalanceToData", () {
      test("repeatBalanceData.category == ''", () {
        // Arrange (Initialization)
        final RepeatedBalanceData repeatBalanceData = RepeatedBalanceData(
          amount: 5.55,
          category: "",
          currency: "EUR",
          name: "",
          initialTime: Timestamp.fromDate(DateTime.now()),
          repeatDuration: 60 * 60 * 24 * 3,
        );

        final data = BalanceDocument();

        // Act (Execution)
        final bool result = RepeatedBalanceDataManager.addRepeatedBalanceToData(
          repeatBalanceData,
          data,
        );

        // Assert (Observation)
        expect(result, false);
        expect(data.repeatedBalance.length, 0);
      });

      test("repeatBalanceData.currency == ''", () {
        // Arrange (Initialization)
        final RepeatedBalanceData repeatBalanceData = RepeatedBalanceData(
          amount: 5.55,
          category: "none",
          currency: "",
          name: "",
          initialTime: Timestamp.fromDate(DateTime.now()),
          repeatDuration: 60 * 60 * 24 * 3,
        );

        final data = BalanceDocument();

        // Act (Execution)
        final bool result = RepeatedBalanceDataManager.addRepeatedBalanceToData(
          repeatBalanceData,
          data,
        );

        // Assert (Observation)
        expect(result, false);
        expect(data.repeatedBalance.length, 0);
      });

      test("random data test", () {
        final math.Random rand = math.Random();

        final data = BalanceDocument();

        final int max = rand.nextInt(2000) + 1;
        for (int i = 0; i < max; i++) {
          // Arrange (Initialization)
          final num amount = rand.nextInt(100000) / 100.0;
          final Timestamp time = Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 365 * 4)).add(
                  Duration(
                    days: rand.nextInt(365 * 4 * 2),
                  ),
                ),
          );
          final int repeatDuration = rand.nextInt(100);
          final RepeatDurationType repeatDurationType = RepeatDurationType
              .values[rand.nextInt(RepeatDurationType.values.length)];

          final RepeatedBalanceData repeatBalanceData = RepeatedBalanceData(
            amount: amount,
            category: "none",
            currency: "EUR",
            name: "Item Nr $i",
            initialTime: time,
            repeatDuration: repeatDuration,
            repeatDurationType: repeatDurationType,
          );

          // Act (Execution)
          final bool result =
              RepeatedBalanceDataManager.addRepeatedBalanceToData(
            repeatBalanceData,
            data,
          );

          // Assert (Observation)
          expect(result, true);
          expect(
            data.repeatedBalance.last.amount,
            amount,
          );
          expect(
            data.repeatedBalance.last.category,
            "none",
          );
          expect(
            data.repeatedBalance.last.currency,
            "EUR",
          );
          expect(
            data.repeatedBalance.last.name,
            "Item Nr $i",
          );
          expect(
            data.repeatedBalance.last.initialTime,
            time,
          );
          expect(
            data.repeatedBalance.last.repeatDuration,
            repeatBalanceData.repeatDuration,
          );
          expect(
            data.repeatedBalance.last.repeatDurationType,
            repeatBalanceData.repeatDurationType.toString().substring(19),
          );
        }
        expect(data.repeatedBalance.length, max);
      });
    });

    group("removeRepeatedBalanceFromData", () {
      test("id not found", () {
        // Arrange (Initialization)
        final data =
            generateRandomData();

        const String id = "Impossible id";


        final int expectedLength = data.repeatedBalance.length;

        for (final removeType in RepeatableChangeType.values) {
          // Act (Execution)
          final bool result =
              RepeatedBalanceDataManager.removeRepeatedBalanceFromData(
            id: id,
            data: data,
            removeType: removeType,
            time: Timestamp.now(),
          );

          // Assert (Observation)
          expect(result, false);
        }

        expect(data.repeatedBalance.length, expectedLength);
      });

      test("removeType == thisAndAllBefore => time != null", () {
        // Arrange (Initialization)
        final data = generateRandomData();

        const String id = "Impossible id";


        final int expectedLength = data.repeatedBalance.length;

        const RepeatableChangeType removeType =
            RepeatableChangeType.thisAndAllBefore;

        // Act (Execution)
        final bool result =
            RepeatedBalanceDataManager.removeRepeatedBalanceFromData(
          id: id,
          data: data,
          removeType: removeType,
        );

        // Assert (Observation)
        expect(result, false);

        expect(data.repeatedBalance.length, expectedLength);
      });

      test("removeType == thisAndAllAfter => time != null", () {
        // Arrange (Initialization)
        final data = generateRandomData();

        const String id = "Impossible id";


        final int expectedLength = data.repeatedBalance.length;

        const RepeatableChangeType removeType =
            RepeatableChangeType.thisAndAllAfter;

        // Act (Execution)
        final bool result =
            RepeatedBalanceDataManager.removeRepeatedBalanceFromData(
          id: id,
          data: data,
          removeType: removeType,
        );

        // Assert (Observation)
        expect(result, false);

        expect(data.repeatedBalance.length, expectedLength);
      });

      test("removeType == onlyThisOne => time != null", () {
        // Arrange (Initialization)
        final data = generateRandomData();

        const String id = "Impossible id";


        final int expectedLength = data.repeatedBalance.length;

        const RepeatableChangeType removeType =
            RepeatableChangeType.onlyThisOne;

        // Act (Execution)
        final bool result =
            RepeatedBalanceDataManager.removeRepeatedBalanceFromData(
          id: id,
          data: data,
          removeType: removeType,
        );

        // Assert (Observation)
        expect(result, false);

        expect(data.repeatedBalance.length, expectedLength);
      });

      test("random data test removeType=all", () {
        final math.Random rand = math.Random();



        final int max = rand.nextInt(200) + 1;
        for (int i = 0; i < max; i++) {
          // Arrange (Initialization)

          final data =
              generateRandomData();
          final int expectedLength = data.repeatedBalance.length - 1;
          final int idIndex = rand.nextInt(expectedLength) + 1;
          final String id = data.repeatedBalance[idIndex].id;

          // Act (Execution)
          final bool result =
              RepeatedBalanceDataManager.removeRepeatedBalanceFromData(
            id: id,
            data: data,
            removeType: RepeatableChangeType.all,
          );

          // Assert (Observation)
          expect(result, true);
          expect(data.repeatedBalance.length, expectedLength);
        }
      });

      test("random data test removeType=thisAndAllBefore", () {
        final math.Random rand = math.Random();



        final int max = rand.nextInt(200) + 1;
        for (int i = 0; i < max; i++) {
          // Arrange (Initialization)

          final data =
              generateRandomData();
          final int expectedLength = data.repeatedBalance.length;
          final int idIndex = rand.nextInt(expectedLength);
          final String id = data.repeatedBalance[idIndex].id;

          final DateTime initialTime =
              (data.repeatedBalance[idIndex].initialTime)
                  .toDate();

          final Timestamp time = Timestamp.fromDate(
            calculateOneTimeStep(
              data.repeatedBalance[idIndex].repeatDuration,
              initialTime,
              monthly: isMonthly(
                data.repeatedBalance[idIndex],
              ),
            ),
          );

          // Act (Execution)
          final bool result =
              RepeatedBalanceDataManager.removeRepeatedBalanceFromData(
            id: id,
            data: data,
            removeType: RepeatableChangeType.thisAndAllBefore,
            time: time,
          );

          // Assert (Observation)
          expect(result, true);
          expect(data.repeatedBalance.length, expectedLength);
          expect(
            (data.repeatedBalance[idIndex].initialTime)
                .toDate()
                .isAfter(initialTime),
            true,
          );
        }
      });

      test("random data test removeType=thisAndAllAfter", () {
        final math.Random rand = math.Random();



        final int max = rand.nextInt(200) + 1;
        for (int i = 0; i < max; i++) {
          // Arrange (Initialization)

          final data =
              generateRandomData();
          final int expectedLength = data.repeatedBalance.length;
          final int idIndex = rand.nextInt(expectedLength);
          final String id = data.repeatedBalance[idIndex].id;

          final Timestamp? endTime =
              data.repeatedBalance[idIndex].endTime;
          final DateTime initialTime =
              (data.repeatedBalance[idIndex].initialTime)
                  .toDate();

          final Timestamp time = Timestamp.fromDate(
            calculateOneTimeStep(
              data.repeatedBalance[idIndex].repeatDuration,
              initialTime,
              monthly: isMonthly(data.repeatedBalance[idIndex]),
            ),
          );

          // Act (Execution)
          final bool result =
              RepeatedBalanceDataManager.removeRepeatedBalanceFromData(
            id: id,
            data: data,
            removeType: RepeatableChangeType.thisAndAllAfter,
            time: time,
          );

          // Assert (Observation)
          expect(result, true);
          expect(data.repeatedBalance.length, expectedLength);
          if (endTime != null) {
            expect(
              (data.repeatedBalance[idIndex].endTime!)
                  .toDate()
                  .isBefore(endTime.toDate()),
              true,
            );
          } else {
            expect(
              data.repeatedBalance[idIndex].endTime != null,
              true,
            );
          }
        }
      });

      test("random data test removeType=onlyThisOne", () {
        final math.Random rand = math.Random();



        final int max = rand.nextInt(200) + 1;
        for (int i = 0; i < max; i++) {
          // Arrange (Initialization)

          final data =
              generateRandomData();
          final int expectedLength = data.repeatedBalance.length;
          final int idIndex = rand.nextInt(expectedLength);
          final String id = data.repeatedBalance[idIndex].id;

          final DateTime initialTime =
              (data.repeatedBalance[idIndex].initialTime)
                  .toDate();

          final Timestamp time = Timestamp.fromDate(
            calculateOneTimeStep(
              data.repeatedBalance[idIndex].repeatDuration,
              initialTime,
              monthly: isMonthly(data.repeatedBalance[idIndex]),
            ),
          );

          // Act (Execution)
          final bool result =
              RepeatedBalanceDataManager.removeRepeatedBalanceFromData(
            id: id,
            data: data,
            removeType: RepeatableChangeType.onlyThisOne,
            time: time,
          );

          // Assert (Observation)
          expect(result, true);
          expect(data.repeatedBalance.length, expectedLength);
          expect(data.repeatedBalance[idIndex].changed != null, true);
          expect(
            (data.repeatedBalance[idIndex].changed!)
                .values
                .last.deleted,
            true,
          );
        }
      });
    });

    group("updateSingleBalanceInData", () {
      test("id not found", () {
        // Arrange (Initialization)

        final data =
            generateRandomData();

        const String id = "Impossible id";

        for (final changeType in RepeatableChangeType.values) {
          // Act (Execution)
          final bool result =
              RepeatedBalanceDataManager.updateRepeatedBalanceInData(
            id: id,
            data: data,
            changeType: changeType,
            amount: 5,
          );

          // Assert (Observation)
          expect(result, false);
        }
      });

      test("id = ''", () {
        // Arrange (Initialization)
        final data =
            generateRandomData();

        const String id = "";

        for (final changeType in RepeatableChangeType.values) {
          // Act (Execution)
          final bool result =
              RepeatedBalanceDataManager.updateRepeatedBalanceInData(
            id: id,
            data: data,
            changeType: changeType,
            amount: 5,
          );

          // Assert (Observation)
          expect(result, false);
        }
      });
      test("category == ''", () {
        // Arrange (Initialization)

        final data =
            generateRandomData();

        final math.Random rand = math.Random();
        final int idIndex = rand.nextInt(data.repeatedBalance.length);
        final String id = data.repeatedBalance[idIndex].id;


        for (final changeType in RepeatableChangeType.values) {
          // Act (Execution)
          final bool result =
              RepeatedBalanceDataManager.updateRepeatedBalanceInData(
            id: id,
            data: data,
            changeType: changeType,
            category: "",
          );

          // Assert (Observation)
          expect(result, false);
        }
      });
      test("currency == ''", () {
        // Arrange (Initialization)

        final data =
            generateRandomData();

        final math.Random rand = math.Random();
        final int idIndex = rand.nextInt(data.repeatedBalance.length);
        final String id = data.repeatedBalance[idIndex].id;


        for (final changeType in RepeatableChangeType.values) {
          // Act (Execution)
          final bool result =
              RepeatedBalanceDataManager.updateRepeatedBalanceInData(
            id: id,
            data: data,
            changeType: changeType,
            currency: "",
          );

          // Assert (Observation)
          expect(result, false);
        }
      });

      test("thisAndAllBefore => time != null", () {
        // Arrange (Initialization)

        final data =
            generateRandomData();

        final math.Random rand = math.Random();
        final int idIndex = rand.nextInt(data.repeatedBalance.length);
        final String id = data.repeatedBalance[idIndex].id;



        const RepeatableChangeType changeType =
            RepeatableChangeType.thisAndAllBefore;
        // Act (Execution)
        final bool result =
            RepeatedBalanceDataManager.updateRepeatedBalanceInData(
          id: id,
          data: data,
          changeType: changeType,
          currency: "EUR",
        );

        // Assert (Observation)
        expect(result, false);
      });

      test("thisAndAllAfter => time != null", () {
        // Arrange (Initialization)

        final data =
            generateRandomData();

        final math.Random rand = math.Random();
        final int idIndex = rand.nextInt(data.repeatedBalance.length);
        final String id = data.repeatedBalance[idIndex].id;



        const RepeatableChangeType changeType =
            RepeatableChangeType.thisAndAllAfter;
        // Act (Execution)
        final bool result =
            RepeatedBalanceDataManager.updateRepeatedBalanceInData(
          id: id,
          data: data,
          changeType: changeType,
          currency: "EUR",
        );

        // Assert (Observation)
        expect(result, false);
      });

      test("onlyThisOne => time != null", () {
        // Arrange (Initialization)

        final data =
            generateRandomData();

        final math.Random rand = math.Random();
        final int idIndex = rand.nextInt(data.repeatedBalance.length);
        final String id = data.repeatedBalance[idIndex].id;



        const RepeatableChangeType changeType =
            RepeatableChangeType.onlyThisOne;
        // Act (Execution)
        final bool result =
            RepeatedBalanceDataManager.updateRepeatedBalanceInData(
          id: id,
          data: data,
          changeType: changeType,
          currency: "EUR",
        );

        // Assert (Observation)
        expect(result, false);
      });

      test("random data test changeType=all (all except newTime)", () {
        final math.Random rand = math.Random();



        final int max = rand.nextInt(200) + 1;
        for (int i = 0; i < max; i++) {
          // Arrange (Initialization)

          final data =
              generateRandomData();
          final int expectedLength = data.repeatedBalance.length;
          final int idIndex = rand.nextInt(expectedLength);
          final String id = data.repeatedBalance[idIndex].id;

          num amount = rand.nextInt(100000) / 100.0;
          amount = -1 * math.pow(amount, 2);
          final Timestamp initialTime = Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 365 * 4)).add(
                  Duration(
                    days: rand.nextInt(365 * 4 * 2),
                  ),
                ),
          );
          final int repeatDuration = rand.nextInt(500) + 1;
          final RepeatDurationType repeatDurationType = RepeatDurationType
              .values[rand.nextInt(RepeatDurationType.values.length)];
          Timestamp? endTime = Timestamp.fromDate(
            initialTime.toDate().add(
                  Duration(
                    days: rand.nextInt(365 * 2),
                  ),
                ),
          );
          if (rand.nextInt(2) == 0) {
            endTime = null;
          }
          final singleRepeatedBalance = data.repeatedBalance[idIndex];

          // Act (Execution)
          final bool result =
              RepeatedBalanceDataManager.updateRepeatedBalanceInData(
            id: id,
            data: data,
            changeType: RepeatableChangeType.all,
            amount: amount,
            category: "food",
            name: "New Name $i",
            initialTime: initialTime,
            repeatDuration: repeatDuration,
            repeatDurationType: repeatDurationType,
            endTime: endTime,
            resetEndTime: endTime == null,
          );

          // Assert (Observation)
          expect(result, true);
          expect(data.repeatedBalance.length, expectedLength);
          expect(singleRepeatedBalance.amount, amount);
          expect(singleRepeatedBalance.category, "food");
          expect(singleRepeatedBalance.name, "New Name $i");
          expect(singleRepeatedBalance.initialTime, initialTime);
          expect(singleRepeatedBalance.repeatDuration, repeatDuration);
          expect(
            singleRepeatedBalance.repeatDurationType,
            repeatDurationType.toString().substring(19),
          );
          expect(singleRepeatedBalance.endTime, endTime);
        }
      });

      test("random data test changeType=all (only newTime)", () {
        final math.Random rand = math.Random();



        final int max = rand.nextInt(200) + 1;
        for (int i = 0; i < max; i++) {
          // Arrange (Initialization)

          final data =
              generateRandomData();
          final int expectedLength = data.repeatedBalance.length;
          final int idIndex = rand.nextInt(expectedLength);
          final String id = data.repeatedBalance[idIndex].id;

          final singleRepeatedBalance = data.repeatedBalance[idIndex];

          final Timestamp newTime = Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 365 * 4)).add(
                  Duration(
                    days: rand.nextInt(365 * 4 * 2),
                  ),
                ),
          );
          final Timestamp formerInitialTime =
              singleRepeatedBalance.initialTime;

          final Timestamp? formerEndTime =
              singleRepeatedBalance.endTime;

          // Act (Execution)
          final bool result =
              RepeatedBalanceDataManager.updateRepeatedBalanceInData(
            id: id,
            data: data,
            changeType: RepeatableChangeType.all,
            newTime: newTime,
            time: formerInitialTime,
          );

          // Assert (Observation)
          expect(result, true);
          expect(data.repeatedBalance.length, expectedLength);
          if (formerEndTime == null) {
            expect(singleRepeatedBalance.endTime, null);
          } else {
            expect(
              (singleRepeatedBalance.endTime!).toDate(),
              formerEndTime.toDate().subtract(
                    formerInitialTime.toDate().difference(
                          newTime.toDate(),
                        ),
                  ),
            );
          }
          expect(singleRepeatedBalance.initialTime, newTime);
        }
      });

      test("random data test changeType=thisAndAllBefore (all except newTime)",
          () {
        final math.Random rand = math.Random();



        final int max = rand.nextInt(200) + 1;
        for (int i = 0; i < max; i++) {
          // Arrange (Initialization)

          final data =
              generateRandomData();
          final int expectedLength = data.repeatedBalance.length + 1;
          final int idIndex = rand.nextInt(expectedLength - 1);
          final String oldId =
              data.repeatedBalance[idIndex].id;

          final oldSingleRepeatedBalance = data.repeatedBalance[idIndex];

          final num oldAmount = oldSingleRepeatedBalance.amount;
          final String oldCategory =
              oldSingleRepeatedBalance.category;
          final String oldName = oldSingleRepeatedBalance.name;

          final int oldRepeatDuration =
              oldSingleRepeatedBalance.repeatDuration;

          final String oldRepeatDurationTypeAsString = oldSingleRepeatedBalance.repeatDurationType.toString();

          final Timestamp? oldEndTime =
              oldSingleRepeatedBalance.endTime;

          final Timestamp oldInitialTime =
              oldSingleRepeatedBalance.initialTime;

          num newAmount = rand.nextInt(100000) / 100.0;
          newAmount = -1 * math.pow(newAmount, 2);
          final Timestamp newInitialTime = Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 365 * 4)).add(
                  Duration(
                    days: rand.nextInt(365 * 4 * 2),
                  ),
                ),
          );
          final int newRepeatDuration = rand.nextInt(500) + 1;
          final RepeatDurationType newRepeatDurationType = RepeatDurationType
              .values[rand.nextInt(RepeatDurationType.values.length)];

          final Timestamp time = Timestamp.fromDate(
            calculateOneTimeStep(
              data.repeatedBalance[idIndex].repeatDuration,
              oldInitialTime.toDate(),
              monthly: isMonthly(data.repeatedBalance[idIndex]),
            ),
          );

          // Act (Execution)
          final bool result =
              RepeatedBalanceDataManager.updateRepeatedBalanceInData(
            id: oldId,
            data: data,
            changeType: RepeatableChangeType.thisAndAllBefore,
            amount: newAmount,
            category: "food",
            name: "New Name $i",
            initialTime: newInitialTime,
            repeatDuration: newRepeatDuration,
            repeatDurationType: newRepeatDurationType,
            time: time,
          );

          final newSingleRepeatedBalance = data.repeatedBalance.last;

          // Assert (Observation)
          expect(result, true);
          expect(data.repeatedBalance.length, expectedLength);
          // old repeated balance
          expect(oldSingleRepeatedBalance.amount, oldAmount);
          expect(oldSingleRepeatedBalance.category, oldCategory);
          expect(oldSingleRepeatedBalance.name, oldName);
          // the old repeated balance has been moved one time step after this.time
          expect(
            oldSingleRepeatedBalance.initialTime,
            Timestamp.fromDate(
              calculateOneTimeStep(
                data.repeatedBalance[idIndex].repeatDuration,
                time.toDate(),
                monthly: isMonthly(data.repeatedBalance[idIndex]),
                dayOfTheMonth: time.toDate().day,
              ),
            ),
          );
          expect(oldSingleRepeatedBalance.repeatDuration, oldRepeatDuration);
          expect(
            oldSingleRepeatedBalance.repeatDurationType,
            oldRepeatDurationTypeAsString,
          );
          expect(oldSingleRepeatedBalance.endTime, oldEndTime);
          // new repeated balance
          expect(newSingleRepeatedBalance.amount, newAmount);
          expect(newSingleRepeatedBalance.category, "food");
          expect(newSingleRepeatedBalance.name, "New Name $i");
          // the new repeated balance has the old initialTime
          expect(newSingleRepeatedBalance.initialTime, newInitialTime);
          expect(newSingleRepeatedBalance.repeatDuration, newRepeatDuration);
          expect(
            newSingleRepeatedBalance.repeatDurationType,
            newRepeatDurationType.toString().substring(19),
          );
        }
      });

      test("random data test changeType=thisAndAllBefore (only newTime)", () {
        final math.Random rand = math.Random();



        final int max = rand.nextInt(200) + 1;
        for (int i = 0; i < max; i++) {
          dev.log("$i");
          // Arrange (Initialization)

          final data =
              generateRandomData();
          final int expectedLength = data.repeatedBalance.length + 1;
          final int idIndex = rand.nextInt(expectedLength - 1);
          final String oldId =
              data.repeatedBalance[idIndex].id;

          final oldSingleRepeatedBalance = data.repeatedBalance[idIndex];

          final Timestamp? oldEndTime = oldSingleRepeatedBalance.endTime;
          Timestamp oldInitialTime = oldSingleRepeatedBalance.initialTime;

          final Timestamp time = oldInitialTime;

          final Duration moveDuration = Duration(seconds: rand.nextInt(100));

          final Timestamp newTime = Timestamp.fromDate(
            time.toDate().add(moveDuration),
          );

          // time gets moved by one time step
          oldInitialTime = Timestamp.fromDate(
            oldInitialTime.toDate().add(moveDuration),
          );

          final Timestamp newInitialTime = Timestamp.fromDate(
            calculateOneTimeStep(
              data.repeatedBalance[idIndex].repeatDuration,
              time.toDate(),
              monthly: isMonthly(data.repeatedBalance[idIndex]),
              dayOfTheMonth: time.toDate().day,
            ),
          );

          final Timestamp newEndTime = newTime;

          // Act (Execution)
          final bool result =
              RepeatedBalanceDataManager.updateRepeatedBalanceInData(
            id: oldId,
            data: data,
            changeType: RepeatableChangeType.thisAndAllBefore,
            time: time,
            newTime: newTime,
          );

          final newSingleRepeatedBalance = data.repeatedBalance.last;

          // Assert (Observation)
          expect(result, true);
          expect(data.repeatedBalance.length, expectedLength);
          // old repeated balance
          expect(oldSingleRepeatedBalance.endTime, oldEndTime);
          expect(oldSingleRepeatedBalance.initialTime, newInitialTime);
          // new repeated balance
          expect(newSingleRepeatedBalance.endTime, newEndTime);
          expect(newSingleRepeatedBalance.initialTime, oldInitialTime);
        }
      });

      test("random data test changeType=thisAndAllAfter (all except newTime)",
          () {
        final math.Random rand = math.Random();



        final int max = rand.nextInt(200) + 1;
        for (int i = 0; i < max; i++) {
          // Arrange (Initialization)

          final data =
              generateRandomData();
          final int expectedLength = data.repeatedBalance.length + 1;
          final int idIndex = rand.nextInt(expectedLength - 1);
          final String oldId =
              data.repeatedBalance[idIndex].id;

          final oldSingleRepeatedBalance = data.repeatedBalance[idIndex];

          final num oldAmount = oldSingleRepeatedBalance.amount;
          final String oldCategory = oldSingleRepeatedBalance.category;
          final String oldName = oldSingleRepeatedBalance.name;

          final int oldRepeatDuration =
              oldSingleRepeatedBalance.repeatDuration;

          final String oldRepeatDurationTypeAsString = oldSingleRepeatedBalance.repeatDurationType.toString();

          final Timestamp oldInitialTime =
              oldSingleRepeatedBalance.initialTime;

          num newAmount = rand.nextInt(100000) / 100.0;
          newAmount = -1 * math.pow(newAmount, 2);
          Timestamp? newEndTime = Timestamp.fromDate(
            DateTime.now().add(
              Duration(
                days: rand.nextInt(365 * 8 * 2),
              ),
            ),
          );
          if (rand.nextInt(2) == 0) {
            newEndTime = null;
          }
          final int newRepeatDuration = rand.nextInt(500) + 1;
          final RepeatDurationType newRepeatDurationType = RepeatDurationType
              .values[rand.nextInt(RepeatDurationType.values.length)];

          final Timestamp time = Timestamp.fromDate(
            calculateOneTimeStep(
              data.repeatedBalance[idIndex].repeatDuration,
              oldInitialTime.toDate(),
              monthly: isMonthly(data.repeatedBalance[idIndex]),
            ),
          );

          // Act (Execution)
          final bool result =
              RepeatedBalanceDataManager.updateRepeatedBalanceInData(
            id: oldId,
            data: data,
            changeType: RepeatableChangeType.thisAndAllAfter,
            amount: newAmount,
            category: "food",
            name: "New Name $i",
            repeatDuration: newRepeatDuration,
            repeatDurationType: newRepeatDurationType,
            time: time,
            endTime: newEndTime,
            resetEndTime: newEndTime == null,
          );

          final newSingleRepeatedBalance = data.repeatedBalance.last;

          // Assert (Observation)
          expect(result, true);
          expect(data.repeatedBalance.length, expectedLength);
          // old repeated balance
          expect(oldSingleRepeatedBalance.amount, oldAmount);
          expect(oldSingleRepeatedBalance.category, oldCategory);
          expect(oldSingleRepeatedBalance.name, oldName);
          // the old repeated balance has been moved one time step after this.time
          expect(oldSingleRepeatedBalance.initialTime, oldInitialTime);

          expect(oldSingleRepeatedBalance.repeatDuration, oldRepeatDuration);
          expect(
            oldSingleRepeatedBalance.repeatDurationType,
            oldRepeatDurationTypeAsString,
          );
          expect(
            oldSingleRepeatedBalance.endTime,
            Timestamp.fromDate(
              calculateOneTimeStepBackwards(
                data.repeatedBalance[idIndex].repeatDuration,
                time.toDate(),
                monthly: isMonthly(data.repeatedBalance[idIndex]),
              ),
            ),
          );
          // new repeated balance
          expect(newSingleRepeatedBalance.amount, newAmount);
          expect(newSingleRepeatedBalance.category, "food");
          expect(newSingleRepeatedBalance.name, "New Name $i");
          // the new repeated balance has the old initialTime
          expect(newSingleRepeatedBalance.initialTime, time);
          expect(newSingleRepeatedBalance.repeatDuration, newRepeatDuration);
          expect(
            newSingleRepeatedBalance.repeatDurationType,
            newRepeatDurationType.toString().substring(19),
          );
        }
      });

      test("random data test changeType=thisAndAllAfter (only newTime)", () {
        final math.Random rand = math.Random();



        final int max = rand.nextInt(200) + 1;
        for (int i = 0; i < max; i++) {
          // Arrange (Initialization)

          final data =
              generateRandomData();
          final int expectedLength = data.repeatedBalance.length + 1;
          final int idIndex = rand.nextInt(expectedLength - 1);
          final String oldId =
              data.repeatedBalance[idIndex].id;

          final oldSingleRepeatedBalance = data.repeatedBalance[idIndex];

          Timestamp? oldEndTime = oldSingleRepeatedBalance.endTime;
          final Timestamp oldInitialTime = oldSingleRepeatedBalance.initialTime;

          final Timestamp time = oldInitialTime;

          final Duration moveDuration = Duration(seconds: rand.nextInt(100));

          final Timestamp newTime = Timestamp.fromDate(
            time.toDate().add(moveDuration),
          );

          oldEndTime = oldEndTime != null
              ? Timestamp.fromDate(oldEndTime.toDate().add(moveDuration))
              : null;

          Timestamp newInitialTime = time;
          // time gets moved by one time step
          newInitialTime = Timestamp.fromDate(
            newInitialTime.toDate().add(moveDuration),
          );

          final Timestamp newEndTime = Timestamp.fromDate(
            calculateOneTimeStepBackwards(
              data.repeatedBalance[idIndex].repeatDuration,
              time.toDate(),
              monthly: isMonthly(data.repeatedBalance[idIndex]),
              dayOfTheMonth: time.toDate().day,
            ),
          );

          // Act (Execution)
          final bool result =
              RepeatedBalanceDataManager.updateRepeatedBalanceInData(
            id: oldId,
            data: data,
            changeType: RepeatableChangeType.thisAndAllAfter,
            time: time,
            newTime: newTime,
          );

          final newSingleRepeatedBalance = data.repeatedBalance.last;

          // Assert (Observation)
          expect(result, true);
          expect(data.repeatedBalance.length, expectedLength);
          // old repeated balance
          expect(oldSingleRepeatedBalance.endTime, newEndTime);
          expect(oldSingleRepeatedBalance.initialTime, oldInitialTime);
          // new repeated balance
          expect(newSingleRepeatedBalance.endTime, oldEndTime);
          expect(newSingleRepeatedBalance.initialTime, newInitialTime);
        }
      });

      test("random data test changeType=onlyThisOne", () {
        final math.Random rand = math.Random();



        final int max = rand.nextInt(200) + 1;
        for (int i = 0; i < max; i++) {
          // Arrange (Initialization)

          final data =
              generateRandomData();
          final int expectedLength = data.repeatedBalance.length;
          final int idIndex = rand.nextInt(expectedLength - 1);
          final String id = data.repeatedBalance[idIndex].id;

          final singleRepeatedBalance = data.repeatedBalance[idIndex];

          final Timestamp initialTime = singleRepeatedBalance.initialTime;

          num newAmount = rand.nextInt(100000) / 100.0;
          newAmount = -1 * math.pow(newAmount, 2);

          final Timestamp time = Timestamp.fromDate(
            calculateOneTimeStep(
              data.repeatedBalance[idIndex].repeatDuration,
              initialTime.toDate(),
              monthly: isMonthly(data.repeatedBalance[idIndex]),
            ),
          );

          final Duration moveDuration = Duration(seconds: rand.nextInt(100));

          final Timestamp newTime = Timestamp.fromDate(
            time.toDate().add(moveDuration),
          );

          // Act (Execution)
          final bool result =
              RepeatedBalanceDataManager.updateRepeatedBalanceInData(
            id: id,
            data: data,
            changeType: RepeatableChangeType.onlyThisOne,
            amount: newAmount,
            category: "food",
            currency: "USD",
            name: "New Name $i",
            time: time,
            newTime: newTime,
          );

          // Assert (Observation)
          expect(result, true);
          expect(data.repeatedBalance.length, expectedLength);
          expect(singleRepeatedBalance.changed != null, true);

          final singleRepeatedBalanceChanged =
              singleRepeatedBalance.changed![time.millisecondsSinceEpoch.toString()];
          expect(singleRepeatedBalanceChanged?.amount, newAmount);
          expect(singleRepeatedBalanceChanged?.category, "food");
          expect(singleRepeatedBalanceChanged?.currency, "USD");
          expect(singleRepeatedBalanceChanged?.name, "New Name $i");
        }
      });
/*
      test("random data test changeType=all", () {
        final math.Random rand = math.Random();



        final int max = rand.nextInt(200) + 1;
        for (int i = 0; i < max; i++) {
          // Arrange (Initialization)

          final data =
              generateRandomData();
          final int expectedLength = data.repeatedBalance.length;
          final int idIndex = rand.nextInt(expectedLength);
          final String id = data.repeatedBalance[idIndex].id;

          final DateTime initialTime =
              (data.repeatedBalance[idIndex].initialTime)
                  .toDate();

          final Timestamp time = Timestamp.fromDate(
            calculateOneTimeStep(
              data.repeatedBalance[idIndex].repeatDuration,
              initialTime,
              monthly: isMonthly(
                RepeatedBalanceData.fromMap(data.repeatedBalance[idIndex]),
              ),
            ),
          );

          // Act (Execution)
          final bool result =
              RepeatedBalanceDataManager.updateRepeatedBalanceInData(
            id: id,
            data: data,
            changeType: RepeatableChangeType.all,
            time: time,
          );

          // Assert (Observation)
          expect(result, true);
          expect(data.repeatedBalance.length, expectedLength);
          expect(data.repeatedBalance[idIndex]["changed"] != null, true);
          expect(
            (data.repeatedBalance[idIndex]["changed"]
                    as Map<String, Map<String, dynamic>>)
                .values
                .last["deleted"] as bool,
            true,
          );
        }
      });

    


      test("random data test", () {
        final math.Random rand = math.Random();
        final SingleBalanceDataManager singleBalanceDataManager =
            SingleBalanceDataManager();

        final int max = rand.nextInt(200) + 1;
        for (int i = 0; i < max; i++) {
          // Arrange (Initialization)

          final data =
              generateRandomData();
          final int expectedLength = data.repeatedBalance.length;
          final int idIndex = rand.nextInt(data.repeatedBalance.length);
          final String id = data.repeatedBalance[idIndex].id;

          // Act (Execution)
          final bool result =
              singleBalanceDataManager.updateSingleBalanceInData(
            id,
            data,
            amount: 5,
            category: "allowance",
            currency: "EUR",
            name: "New Name",
            time: Timestamp.fromMillisecondsSinceEpoch(1648000000000),
          );

          // Assert (Observation)
          expect(result, true);
          expect(data.repeatedBalance.length, expectedLength);
          expect(data.repeatedBalance[idIndex].amount, 5);
          expect(data.repeatedBalance[idIndex].category, "allowance");
          expect(data.repeatedBalance[idIndex].currency, "EUR");
          expect(data.repeatedBalance[idIndex].name, "New Name");
          expect(
            data.repeatedBalance[idIndex]["time"],
            Timestamp.fromMillisecondsSinceEpoch(1648000000000),
          );
        }
      });*/
    });
  });
}

BalanceDocument generateRandomData({
  int averageNumberOfEntries = 1024,
}) {
  final data = BalanceDocument();
  final math.Random rand = math.Random();
  final int max = rand.nextInt(averageNumberOfEntries * 2) + 1;
  for (int i = 0; i < max; i++) {
    final num amount = rand.nextInt(100000) / 100.0;
    final Timestamp time = Timestamp.fromDate(
      DateTime.now().subtract(const Duration(days: 365 * 4)).add(
            Duration(
              days: rand.nextInt(365 * 4 * 2),
            ),
          ),
    );
    final int repeatDuration = rand.nextInt(500) + 1;
    final RepeatDurationType repeatDurationType = RepeatDurationType
        .values[rand.nextInt(RepeatDurationType.values.length)];
    Timestamp? endTime = Timestamp.fromDate(
      time.toDate().add(
            Duration(
              days: rand.nextInt(365 * 2),
            ),
          ),
    );
    if (rand.nextInt(2) == 0) {
      endTime = null;
    }
    data.repeatedBalance.add(
      RepeatedBalanceData(
          amount: amount,
          category: "none",
          currency: "EUR",
          name: "Item Nr $i",
          id: const Uuid().v4(),
          initialTime: time,
          endTime: endTime,
          repeatDuration: repeatDuration,
          repeatDurationType: repeatDurationType,
      )
    );
  }

  return data;
}
