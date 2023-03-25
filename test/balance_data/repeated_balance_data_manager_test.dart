//  Repeated Balance Data Manager Test
//
//  Author: SoTBurst
//  Co-Author: n/a
//

import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linum/core/balance/enums/serial_transaction_change_type_enum.dart';
import 'package:linum/core/balance/models/balance_document.dart';
import 'package:linum/core/balance/models/serial_transaction.dart';
import 'package:linum/core/balance/utils/date_time_calculation_functions.dart';
import 'package:linum/core/balance/utils/serial_transaction_manager.dart';
import 'package:linum/core/repeating/enums/repeat_duration_type_enum.dart';
import 'package:linum/core/repeating/utils/repeated_balance_help_functions.dart';
import 'package:uuid/uuid.dart';

void main() {
  group("SerialTransactionManager", () {
    group("addSerialTransactionToData", () {
      test("serialTransaction.category == ''", () {
        // Arrange (Initialization)
        final SerialTransaction repeatBalanceData = SerialTransaction(
          amount: 5.55,
          category: "",
          currency: "EUR",
          name: "",
          startDate: Timestamp.fromDate(DateTime.now()),
          repeatDuration: 60 * 60 * 24 * 3,
        );

        final data = BalanceDocument();

        // Act (Execution)
        final bool result = SerialTransactionManager.addSerialTransactionToData(
          repeatBalanceData,
          data,
        );

        // Assert (Observation)
        expect(result, false);
        expect(data.serialTransactions.length, 0);
      });

      test("repeatBalanceData.currency == ''", () {
        // Arrange (Initialization)
        final SerialTransaction repeatBalanceData = SerialTransaction(
          amount: 5.55,
          category: "none",
          currency: "",
          name: "",
          startDate: Timestamp.fromDate(DateTime.now()),
          repeatDuration: 60 * 60 * 24 * 3,
        );

        final data = BalanceDocument();

        // Act (Execution)
        final bool result = SerialTransactionManager.addSerialTransactionToData(
          repeatBalanceData,
          data,
        );

        // Assert (Observation)
        expect(result, false);
        expect(data.serialTransactions.length, 0);
      });

      test("random data test", () {
        final math.Random rand = math.Random();

        final data = BalanceDocument();

        final int max = rand.nextInt(2000) + 1;
        for (int i = 0; i < max; i++) {
          // Arrange (Initialization)
          final num amount = rand.nextInt(100000) / 100.0;
          final Timestamp date = Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 365 * 4)).add(
                  Duration(
                    days: rand.nextInt(365 * 4 * 2),
                  ),
                ),
          );
          final int repeatDuration = rand.nextInt(100);
          final RepeatDurationType repeatDurationType = RepeatDurationType
              .values[rand.nextInt(RepeatDurationType.values.length)];

          final SerialTransaction repeatBalanceData = SerialTransaction(
            amount: amount,
            category: "none",
            currency: "EUR",
            name: "Item Nr $i",
            startDate: date,
            repeatDuration: repeatDuration,
            repeatDurationType: repeatDurationType,
          );

          // Act (Execution)
          final bool result =
              SerialTransactionManager.addSerialTransactionToData(
            repeatBalanceData,
            data,
          );

          // Assert (Observation)
          expect(result, true);
          expect(
            data.serialTransactions.last.amount,
            amount,
          );
          expect(
            data.serialTransactions.last.category,
            "none",
          );
          expect(
            data.serialTransactions.last.currency,
            "EUR",
          );
          expect(
            data.serialTransactions.last.name,
            "Item Nr $i",
          );
          expect(
            data.serialTransactions.last.startDate,
            date,
          );
          expect(
            data.serialTransactions.last.repeatDuration,
            repeatBalanceData.repeatDuration,
          );
          expect(
            data.serialTransactions.last.repeatDurationType,
            repeatBalanceData.repeatDurationType,
          );
        }
        expect(data.serialTransactions.length, max);
      });
    });

    group("removeSerialTransactionFromData", () {
      test("id not found", () {
        // Arrange (Initialization)
        final data = generateRandomData();

        const String id = "Impossible id";

        final int expectedLength = data.serialTransactions.length;

        for (final removeType in SerialTransactionChangeMode.values) {
          // Act (Execution)
          final bool result =
              SerialTransactionManager.removeSerialTransactionFromData(
            id: id,
            data: data,
            removeType: removeType,
            date: Timestamp.now(),
          );

          // Assert (Observation)
          expect(result, false);
        }

        expect(data.serialTransactions.length, expectedLength);
      });

      test("removeType == thisAndAllBefore => time != null", () {
        // Arrange (Initialization)
        final data = generateRandomData();

        const String id = "Impossible id";

        final int expectedLength = data.serialTransactions.length;

        const SerialTransactionChangeMode removeType =
            SerialTransactionChangeMode.thisAndAllBefore;

        // Act (Execution)
        final bool result =
            SerialTransactionManager.removeSerialTransactionFromData(
          id: id,
          data: data,
          removeType: removeType,
        );

        // Assert (Observation)
        expect(result, false);

        expect(data.serialTransactions.length, expectedLength);
      });

      test("removeType == thisAndAllAfter => time != null", () {
        // Arrange (Initialization)
        final data = generateRandomData();

        const String id = "Impossible id";

        final int expectedLength = data.serialTransactions.length;

        const SerialTransactionChangeMode removeType =
            SerialTransactionChangeMode.thisAndAllAfter;

        // Act (Execution)
        final bool result =
            SerialTransactionManager.removeSerialTransactionFromData(
          id: id,
          data: data,
          removeType: removeType,
        );

        // Assert (Observation)
        expect(result, false);

        expect(data.serialTransactions.length, expectedLength);
      });

      test("removeType == onlyThisOne => time != null", () {
        // Arrange (Initialization)
        final data = generateRandomData();

        const String id = "Impossible id";

        final int expectedLength = data.serialTransactions.length;

        const SerialTransactionChangeMode removeType =
            SerialTransactionChangeMode.onlyThisOne;

        // Act (Execution)
        final bool result =
            SerialTransactionManager.removeSerialTransactionFromData(
          id: id,
          data: data,
          removeType: removeType,
        );

        // Assert (Observation)
        expect(result, false);

        expect(data.serialTransactions.length, expectedLength);
      });

      test("random data test removeType=all", () {
        final math.Random rand = math.Random();

        final int max = rand.nextInt(200) + 1;
        for (int i = 0; i < max; i++) {
          // Arrange (Initialization)

          final data = generateRandomData();
          final int expectedLength = data.serialTransactions.length - 1;
          final int idIndex = rand.nextInt(expectedLength) + 1;
          final String id = data.serialTransactions[idIndex].id;

          // Act (Execution)
          final bool result =
              SerialTransactionManager.removeSerialTransactionFromData(
            id: id,
            data: data,
            removeType: SerialTransactionChangeMode.all,
          );

          // Assert (Observation)
          expect(result, true);
          expect(data.serialTransactions.length, expectedLength);
        }
      });

      test("random data test removeType=thisAndAllBefore", () {
        final math.Random rand = math.Random();

        final int max = rand.nextInt(200) + 1;
        for (int i = 0; i < max; i++) {
          // Arrange (Initialization)

          final data = generateRandomData();
          final int expectedLength = data.serialTransactions.length;
          final int idIndex = rand.nextInt(expectedLength);
          final String id = data.serialTransactions[idIndex].id;

          final DateTime initialTime =
              (data.serialTransactions[idIndex].startDate).toDate();

          final Timestamp date = Timestamp.fromDate(
            calculateOneTimeStep(
              data.serialTransactions[idIndex].repeatDuration,
              initialTime,
              monthly: isMonthly(
                data.serialTransactions[idIndex],
              ),
            ),
          );

          // Act (Execution)
          final bool result =
              SerialTransactionManager.removeSerialTransactionFromData(
            id: id,
            data: data,
            removeType: SerialTransactionChangeMode.thisAndAllBefore,
            date: date,
          );

          // Assert (Observation)
          expect(result, true);
          expect(data.serialTransactions.length, expectedLength);
          expect(
            (data.serialTransactions[idIndex].startDate)
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

          final data = generateRandomData();
          final int expectedLength = data.serialTransactions.length;
          final int idIndex = rand.nextInt(expectedLength);
          final String id = data.serialTransactions[idIndex].id;

          final Timestamp? endTime = data.serialTransactions[idIndex].endDate;
          final DateTime initialTime =
              data.serialTransactions[idIndex].startDate.toDate();

          final Timestamp date = Timestamp.fromDate(
            calculateOneTimeStep(
              data.serialTransactions[idIndex].repeatDuration,
              initialTime,
              monthly: isMonthly(data.serialTransactions[idIndex]),
            ),
          );

          // Act (Execution)
          final bool result =
              SerialTransactionManager.removeSerialTransactionFromData(
            id: id,
            data: data,
            removeType: SerialTransactionChangeMode.thisAndAllAfter,
            date: date,
          );

          // Assert (Observation)
          expect(result, true);
          expect(data.serialTransactions.length, expectedLength);
          if (endTime != null) {
            expect(
              data.serialTransactions[idIndex].endDate!
                  .toDate()
                  .isBefore(endTime.toDate()),
              true,
            );
          } else {
            expect(
              data.serialTransactions[idIndex].endDate != null,
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

          final data = generateRandomData();
          final int expectedLength = data.serialTransactions.length;
          final int idIndex = rand.nextInt(expectedLength);
          final String id = data.serialTransactions[idIndex].id;

          final DateTime initialTime =
              (data.serialTransactions[idIndex].startDate).toDate();

          final Timestamp date = Timestamp.fromDate(
            calculateOneTimeStep(
              data.serialTransactions[idIndex].repeatDuration,
              initialTime,
              monthly: isMonthly(data.serialTransactions[idIndex]),
            ),
          );

          // Act (Execution)
          final bool result =
              SerialTransactionManager.removeSerialTransactionFromData(
            id: id,
            data: data,
            removeType: SerialTransactionChangeMode.onlyThisOne,
            date: date,
          );

          // Assert (Observation)
          expect(result, true);
          expect(data.serialTransactions.length, expectedLength);
          expect(data.serialTransactions[idIndex].changed != null, true);
          expect(
            (data.serialTransactions[idIndex].changed!).values.last.deleted,
            true,
          );
        }
      });
    });

    group("updateTransactionInData", () {
      test("id not found", () {
        // Arrange (Initialization)

        final data = generateRandomData();

        const String id = "Impossible id";

        for (final changeType in SerialTransactionChangeMode.values) {
          // Act (Execution)
          final bool result =
              SerialTransactionManager.updateSerialTransactionInData(
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
        final data = generateRandomData();

        const String id = "";

        for (final changeType in SerialTransactionChangeMode.values) {
          // Act (Execution)
          final bool result =
              SerialTransactionManager.updateSerialTransactionInData(
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

        final data = generateRandomData();

        final math.Random rand = math.Random();
        final int idIndex = rand.nextInt(data.serialTransactions.length);
        final String id = data.serialTransactions[idIndex].id;

        for (final changeType in SerialTransactionChangeMode.values) {
          // Act (Execution)
          final bool result =
              SerialTransactionManager.updateSerialTransactionInData(
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

        final data = generateRandomData();

        final math.Random rand = math.Random();
        final int idIndex = rand.nextInt(data.serialTransactions.length);
        final String id = data.serialTransactions[idIndex].id;

        for (final changeType in SerialTransactionChangeMode.values) {
          // Act (Execution)
          final bool result =
              SerialTransactionManager.updateSerialTransactionInData(
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

        final data = generateRandomData();

        final math.Random rand = math.Random();
        final int idIndex = rand.nextInt(data.serialTransactions.length);
        final String id = data.serialTransactions[idIndex].id;

        const SerialTransactionChangeMode changeType =
            SerialTransactionChangeMode.thisAndAllBefore;
        // Act (Execution)
        final bool result =
            SerialTransactionManager.updateSerialTransactionInData(
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

        final data = generateRandomData();

        final math.Random rand = math.Random();
        final int idIndex = rand.nextInt(data.serialTransactions.length);
        final String id = data.serialTransactions[idIndex].id;

        const SerialTransactionChangeMode changeType =
            SerialTransactionChangeMode.thisAndAllAfter;
        // Act (Execution)
        final bool result =
            SerialTransactionManager.updateSerialTransactionInData(
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

        final data = generateRandomData();

        final math.Random rand = math.Random();
        final int idIndex = rand.nextInt(data.serialTransactions.length);
        final String id = data.serialTransactions[idIndex].id;

        const SerialTransactionChangeMode changeType =
            SerialTransactionChangeMode.onlyThisOne;
        // Act (Execution)
        final bool result =
            SerialTransactionManager.updateSerialTransactionInData(
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

          final data = generateRandomData();
          final int expectedLength = data.serialTransactions.length;
          final int idIndex = rand.nextInt(expectedLength);
          final String id = data.serialTransactions[idIndex].id;

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
          var serialTransaction = data.serialTransactions[idIndex];

          // Act (Execution)
          final bool result =
              SerialTransactionManager.updateSerialTransactionInData(
            id: id,
            data: data,
            changeType: SerialTransactionChangeMode.all,
            amount: amount,
            category: "food",
            name: "New Name $i",
            startDate: initialTime,
            repeatDuration: repeatDuration,
            repeatDurationType: repeatDurationType,
            endDate: endTime,
            resetEndDate: endTime == null,
          );

          serialTransaction = data.serialTransactions[idIndex];

          // Assert (Observation)
          expect(result, true);
          expect(data.serialTransactions.length, expectedLength);
          expect(serialTransaction.amount, amount);
          expect(serialTransaction.category, "food");
          expect(serialTransaction.name, "New Name $i");
          expect(serialTransaction.startDate, initialTime);
          expect(serialTransaction.repeatDuration, repeatDuration);
          expect(
            serialTransaction.repeatDurationType,
            repeatDurationType,
          );
          expect(serialTransaction.endDate, endTime);
        }
      });

      test("random data test changeType=all (only newTime)", () {
        final math.Random rand = math.Random();

        final int max = rand.nextInt(200) + 1;
        for (int i = 0; i < max; i++) {
          // Arrange (Initialization)

          final data = generateRandomData();
          final int expectedLength = data.serialTransactions.length;
          final int idIndex = rand.nextInt(expectedLength);
          final String id = data.serialTransactions[idIndex].id;

          var serialTransaction = data.serialTransactions[idIndex];

          final Timestamp newTime = Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 365 * 4)).add(
                  Duration(
                    days: rand.nextInt(365 * 4 * 2),
                  ),
                ),
          );
          final Timestamp formerInitialTime = serialTransaction.startDate;

          final Timestamp? formerEndTime = serialTransaction.endDate;

          // Act (Execution)
          final bool result =
              SerialTransactionManager.updateSerialTransactionInData(
            id: id,
            data: data,
            changeType: SerialTransactionChangeMode.all,
            newDate: newTime,
            oldDate: formerInitialTime,
          );

          serialTransaction = data.serialTransactions[idIndex];

          // Assert (Observation)
          expect(result, true);
          expect(data.serialTransactions.length, expectedLength);
          if (formerEndTime == null) {
            expect(serialTransaction.endDate, null);
          } else {
            expect(
              (serialTransaction.endDate!).toDate(),
              formerEndTime.toDate().subtract(
                    formerInitialTime.toDate().difference(
                          newTime.toDate(),
                        ),
                  ),
            );
          }
          expect(serialTransaction.startDate, newTime);
        }
      });

      test("random data test changeType=thisAndAllBefore (all except newTime)",
          () {
        final math.Random rand = math.Random();

        final int max = rand.nextInt(200) + 1;
        for (int i = 0; i < max; i++) {
          // Arrange (Initialization)

          final data = generateRandomData();
          final int expectedLength = data.serialTransactions.length + 1;
          final int idIndex = rand.nextInt(expectedLength - 1);
          final String oldId = data.serialTransactions[idIndex].id;

          var oldSerialTransaction = data.serialTransactions[idIndex];

          final oldAmount = oldSerialTransaction.amount;
          final oldCategory = oldSerialTransaction.category;
          final oldName = oldSerialTransaction.name;

          final int oldRepeatDuration = oldSerialTransaction.repeatDuration;

          final oldRepeatDurationType = oldSerialTransaction.repeatDurationType;

          final Timestamp? oldEndTime = oldSerialTransaction.endDate;

          final Timestamp oldInitialTime = oldSerialTransaction.startDate;

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
              data.serialTransactions[idIndex].repeatDuration,
              oldInitialTime.toDate(),
              monthly: isMonthly(data.serialTransactions[idIndex]),
            ),
          );

          // Act (Execution)
          final bool result =
              SerialTransactionManager.updateSerialTransactionInData(
            id: oldId,
            data: data,
            changeType: SerialTransactionChangeMode.thisAndAllBefore,
            amount: newAmount,
            category: "food",
            name: "New Name $i",
            startDate: newInitialTime,
            repeatDuration: newRepeatDuration,
            repeatDurationType: newRepeatDurationType,
            oldDate: time,
          );

          final newSerialTransaction = data.serialTransactions.last;
          oldSerialTransaction = data.serialTransactions[idIndex];

          // Assert (Observation)
          expect(result, true);
          expect(data.serialTransactions.length, expectedLength);
          // old repeated balance
          expect(oldSerialTransaction.amount, oldAmount);
          expect(oldSerialTransaction.category, oldCategory);
          expect(oldSerialTransaction.name, oldName);
          // the old repeated balance has been moved one time step after this.time
          expect(
            oldSerialTransaction.startDate,
            Timestamp.fromDate(
              calculateOneTimeStep(
                data.serialTransactions[idIndex].repeatDuration,
                time.toDate(),
                monthly: isMonthly(data.serialTransactions[idIndex]),
                dayOfTheMonth: time.toDate().day,
              ),
            ),
          );
          expect(oldSerialTransaction.repeatDuration, oldRepeatDuration);
          expect(
            oldSerialTransaction.repeatDurationType,
            oldRepeatDurationType,
          );
          expect(oldSerialTransaction.endDate, oldEndTime);
          // new repeated balance
          expect(newSerialTransaction.amount, newAmount);
          expect(newSerialTransaction.category, "food");
          expect(newSerialTransaction.name, "New Name $i");
          // the new repeated balance has the old initialTime
          expect(newSerialTransaction.startDate, newInitialTime);
          expect(newSerialTransaction.repeatDuration, newRepeatDuration);
          expect(
            newSerialTransaction.repeatDurationType,
            newRepeatDurationType,
          );
        }
      });

      test("random data test changeType=thisAndAllBefore (only newTime)", () {
        final math.Random rand = math.Random();

        final int max = rand.nextInt(200) + 1;
        for (int i = 0; i < max; i++) {
          // Arrange (Initialization)

          final data = generateRandomData();
          final int expectedLength = data.serialTransactions.length + 1;
          final int idIndex = rand.nextInt(expectedLength - 1);
          final String oldId = data.serialTransactions[idIndex].id;

          var oldSerialTransaction = data.serialTransactions[idIndex];

          final Timestamp? oldEndTime = oldSerialTransaction.endDate;
          Timestamp oldInitialTime = oldSerialTransaction.startDate;

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
              data.serialTransactions[idIndex].repeatDuration,
              time.toDate(),
              monthly: isMonthly(data.serialTransactions[idIndex]),
              dayOfTheMonth: time.toDate().day,
            ),
          );

          final Timestamp newEndTime = newTime;

          // Act (Execution)
          final bool result =
              SerialTransactionManager.updateSerialTransactionInData(
            id: oldId,
            data: data,
            changeType: SerialTransactionChangeMode.thisAndAllBefore,
            oldDate: time,
            newDate: newTime,
          );

          final newSerialTransaction = data.serialTransactions.last;
          oldSerialTransaction = data.serialTransactions[idIndex];

          // Assert (Observation)
          expect(result, true);
          expect(data.serialTransactions.length, expectedLength);
          // old repeated balance
          expect(oldSerialTransaction.endDate, oldEndTime);
          expect(oldSerialTransaction.startDate, newInitialTime);
          // new repeated balance
          expect(newSerialTransaction.endDate, newEndTime);
          expect(newSerialTransaction.startDate, oldInitialTime);
        }
      });

      test("random data test changeType=thisAndAllAfter (all except newTime)",
          () {
        final math.Random rand = math.Random();

        final int max = rand.nextInt(200) + 1;
        for (int i = 0; i < max; i++) {
          // Arrange (Initialization)

          final data = generateRandomData();
          final int expectedLength = data.serialTransactions.length + 1;
          final int idIndex = rand.nextInt(expectedLength - 1);
          final String oldId = data.serialTransactions[idIndex].id;

          var oldSerialTransaction = data.serialTransactions[idIndex];

          final oldAmount = oldSerialTransaction.amount;
          final oldCategory = oldSerialTransaction.category;
          final oldName = oldSerialTransaction.name;

          final int oldRepeatDuration = oldSerialTransaction.repeatDuration;

          final oldRepeatDurationType = oldSerialTransaction.repeatDurationType;

          final Timestamp oldInitialTime = oldSerialTransaction.startDate;

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
              data.serialTransactions[idIndex].repeatDuration,
              oldInitialTime.toDate(),
              monthly: isMonthly(data.serialTransactions[idIndex]),
            ),
          );
          // Act (Execution)
          final bool result =
              SerialTransactionManager.updateSerialTransactionInData(
            id: oldId,
            data: data,
            changeType: SerialTransactionChangeMode.thisAndAllAfter,
            amount: newAmount,
            category: "food",
            name: "New Name $i",
            repeatDuration: newRepeatDuration,
            repeatDurationType: newRepeatDurationType,
            oldDate: time,
            endDate: newEndTime,
            resetEndDate: newEndTime == null,
          );

          final newSerialTransaction = data.serialTransactions.last;
          oldSerialTransaction = data.serialTransactions[idIndex];
          // Assert (Observation)
          expect(result, true);
          expect(data.serialTransactions.length, expectedLength);
          // old repeated balance
          expect(oldSerialTransaction.amount, oldAmount);
          expect(oldSerialTransaction.category, oldCategory);
          expect(oldSerialTransaction.name, oldName);
          // the old repeated balance has been moved one time step after this.time
          expect(oldSerialTransaction.startDate, oldInitialTime);

          expect(oldSerialTransaction.repeatDuration, oldRepeatDuration);
          expect(
            oldSerialTransaction.repeatDurationType,
            oldRepeatDurationType,
          );
          expect(
            oldSerialTransaction.endDate,
            Timestamp.fromDate(
              calculateOneTimeStepBackwards(
                data.serialTransactions[idIndex].repeatDuration,
                time.toDate(),
                monthly: isMonthly(data.serialTransactions[idIndex]),
                dayOfTheMonth: time.toDate().day,
              ),
            ),
          );
          // new repeated balance
          expect(newSerialTransaction.amount, newAmount);
          expect(newSerialTransaction.category, "food");
          expect(newSerialTransaction.name, "New Name $i");
          // the new repeated balance has the old initialTime
          expect(newSerialTransaction.startDate, time);
          expect(newSerialTransaction.repeatDuration, newRepeatDuration);
          expect(
            newSerialTransaction.repeatDurationType,
            newRepeatDurationType,
          );
        }
      });

      test("random data test changeType=thisAndAllAfter (only newTime)", () {
        final math.Random rand = math.Random();

        final int max = rand.nextInt(200) + 1;
        for (int i = 0; i < max; i++) {
          // Arrange (Initialization)

          final data = generateRandomData();
          final int expectedLength = data.serialTransactions.length + 1;
          final int idIndex = rand.nextInt(expectedLength - 1);
          final String oldId = data.serialTransactions[idIndex].id;

          var oldSerialTransaction = data.serialTransactions[idIndex];

          Timestamp? oldEndTime = oldSerialTransaction.endDate;
          final Timestamp oldInitialTime = oldSerialTransaction.startDate;

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
              data.serialTransactions[idIndex].repeatDuration,
              time.toDate(),
              monthly: isMonthly(data.serialTransactions[idIndex]),
              dayOfTheMonth: time.toDate().day,
            ),
          );

          // Act (Execution)
          final bool result =
              SerialTransactionManager.updateSerialTransactionInData(
            id: oldId,
            data: data,
            changeType: SerialTransactionChangeMode.thisAndAllAfter,
            oldDate: time,
            newDate: newTime,
          );

          final newSerialTransaction = data.serialTransactions.last;
          oldSerialTransaction = data.serialTransactions[idIndex];

          // Assert (Observation)
          expect(result, true);
          expect(data.serialTransactions.length, expectedLength);
          // old repeated balance
          expect(oldSerialTransaction.endDate, newEndTime);
          expect(oldSerialTransaction.startDate, oldInitialTime);
          // new repeated balance
          expect(newSerialTransaction.endDate, oldEndTime);
          expect(newSerialTransaction.startDate, newInitialTime);
        }
      });

      test("random data test changeType=onlyThisOne", () {
        final math.Random rand = math.Random();

        final int max = rand.nextInt(200) + 1;
        for (int i = 0; i < max; i++) {
          // Arrange (Initialization)

          final data = generateRandomData();
          final int expectedLength = data.serialTransactions.length;
          int idIndex = rand.nextInt(expectedLength) - 1;
          idIndex = idIndex == -1 ? 0 : idIndex;
          final String id = data.serialTransactions[idIndex].id;

          var serialTransaction = data.serialTransactions[idIndex];

          final Timestamp initialTime = serialTransaction.startDate;

          num newAmount = rand.nextInt(100000) / 100.0;
          newAmount = -1 * math.pow(newAmount, 2);

          final Timestamp time = Timestamp.fromDate(
            calculateOneTimeStep(
              data.serialTransactions[idIndex].repeatDuration,
              initialTime.toDate(),
              monthly: isMonthly(data.serialTransactions[idIndex]),
            ),
          );

          final Duration moveDuration = Duration(seconds: rand.nextInt(100));

          final Timestamp newTime = Timestamp.fromDate(
            time.toDate().add(moveDuration),
          );

          // Act (Execution)
          final bool result =
              SerialTransactionManager.updateSerialTransactionInData(
            id: id,
            data: data,
            changeType: SerialTransactionChangeMode.onlyThisOne,
            amount: newAmount,
            category: "food",
            currency: "USD",
            name: "New Name $i",
            oldDate: time,
            newDate: newTime,
          );

          serialTransaction = data.serialTransactions[idIndex];

          // Assert (Observation)
          expect(result, true);
          expect(data.serialTransactions.length, expectedLength);
          expect(serialTransaction.changed != null, true);

          final changedTransaction = serialTransaction
              .changed![time.millisecondsSinceEpoch.toString()];
          expect(changedTransaction?.amount, newAmount);
          expect(changedTransaction?.category, "food");
          expect(changedTransaction?.currency, "USD");
          expect(changedTransaction?.name, "New Name $i");
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
          final int expectedLength = data.serialTransactions.length;
          final int idIndex = rand.nextInt(expectedLength);
          final String id = data.serialTransactions[idIndex].id;

          final DateTime initialTime =
              (data.serialTransactions[idIndex].initialTime)
                  .toDate();

          final Timestamp time = Timestamp.fromDate(
            calculateOneTimeStep(
              data.serialTransactions[idIndex].repeatDuration,
              initialTime,
              monthly: isMonthly(
                RepeatedBalanceData.fromMap(data.serialTransactions[idIndex]),
              ),
            ),
          );

          // Act (Execution)
          final bool result =
              SerialTransactionManager.updateRepeatedBalanceInData(
            id: id,
            data: data,
            changeType: RepeatableChangeType.all,
            time: time,
          );

          // Assert (Observation)
          expect(result, true);
          expect(data.serialTransactions.length, expectedLength);
          expect(data.serialTransactions[idIndex]["changed"] != null, true);
          expect(
            (data.serialTransactions[idIndex]["changed"]
                    as Map<String, Map<String, dynamic>>)
                .values
                .last["deleted"] as bool,
            true,
          );
        }
      });

    


      test("random data test", () {
        final math.Random rand = math.Random();
        final TransactionManager singleBalanceDataManager =
            TransactionManager();

        final int max = rand.nextInt(200) + 1;
        for (int i = 0; i < max; i++) {
          // Arrange (Initialization)

          final data =
              generateRandomData();
          final int expectedLength = data.serialTransactions.length;
          final int idIndex = rand.nextInt(data.serialTransactions.length);
          final String id = data.serialTransactions[idIndex].id;

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
          expect(data.serialTransactions.length, expectedLength);
          expect(data.serialTransactions[idIndex].amount, 5);
          expect(data.serialTransactions[idIndex].category, "allowance");
          expect(data.serialTransactions[idIndex].currency, "EUR");
          expect(data.serialTransactions[idIndex].name, "New Name");
          expect(
            data.serialTransactions[idIndex]["time"],
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
    data.serialTransactions.add(
      SerialTransaction(
        amount: amount,
        category: "none",
        currency: "EUR",
        name: "Item Nr $i",
        id: const Uuid().v4(),
        startDate: time,
        endDate: endTime,
        repeatDuration: repeatDuration,
        repeatDurationType: repeatDurationType,
      ),
    );
  }

  return data;
}
