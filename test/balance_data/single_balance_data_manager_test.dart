//  Single Balance Data Manager Test
//
//  Author: SoTBurst
//  Co-Author: n/a
//

import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linum/models/balance_document.dart';
import 'package:linum/models/single_balance_data.dart';
import 'package:linum/utilities/balance_data/single_balance_data_manager.dart';
import 'package:uuid/uuid.dart';

void main() {
  group("SingleBalanceDataManager", () {
    group("addSingleBalanceToData", () {
      test("singleBalance.category == ''", () {
        // Arrange (Initialization)
        final SingleBalanceData singleBalance = SingleBalanceData(
          amount: 5.55,
          category: "",
          currency: "EUR",
          name: "",
          time: Timestamp.fromDate(DateTime.now()),
        );


        final data = BalanceDocument();

        // Act (Execution)
        final bool result = SingleBalanceDataManager.addSingleBalanceToData(
          singleBalance,
          data,
        );

        // Assert (Observation)
        expect(result, false);
        expect(data.balanceData.length, 0);
      });

      test("singleBalance.currency == ''", () {
        // Arrange (Initialization)
        final SingleBalanceData singleBalance = SingleBalanceData(
          amount: 5.55,
          category: "none",
          currency: "",
          name: "",
          time: Timestamp.fromDate(DateTime.now()),
        );


        final data = BalanceDocument();

        // Act (Execution)
        final bool result = SingleBalanceDataManager.addSingleBalanceToData(
          singleBalance,
          data,
        );

        // Assert (Observation)
        expect(result, false);
        expect(data.balanceData.length, 0);
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

          final SingleBalanceData singleBalance = SingleBalanceData(
            amount: amount,
            category: "none",
            currency: "EUR",
            name: "Item Nr $i",
            time: time,
          );

          // Act (Execution)
          final bool result = SingleBalanceDataManager.addSingleBalanceToData(
            singleBalance,
            data,
          );

          // Assert (Observation)
          expect(result, true);
          expect(
            data.balanceData.last.amount,
            amount,
          );
          expect(
            data.balanceData.last.name,
            "Item Nr $i",
          );
          expect(
            data.balanceData.last.time,
            time,
          );
        }
        expect(data.balanceData.length, max);
      });
    });
    group("removeSingleBalanceFromData", () {
      test("id not found", () {
        // Arrange (Initialization)

        final data = generateRandomData();

        const String id = "Impossible id";


        final int expectedLength = data.balanceData.length;

        // Act (Execution)
        final bool result =
            SingleBalanceDataManager.removeSingleBalanceFromData(id, data);

        // Assert (Observation)
        expect(result, false);
        expect(data.balanceData.length, expectedLength);
      });

      test("random data test", () {
        final math.Random rand = math.Random();


        final int max = rand.nextInt(200) + 1;
        for (int i = 0; i < max; i++) {
          // Arrange (Initialization)

          final data =
              generateRandomData();
          final int expectedLength = data.balanceData.length - 1;
          final int idIndex = rand.nextInt(expectedLength) + 1;
          final String id = data.balanceData[idIndex].id;

          // Act (Execution)
          final bool result =
              SingleBalanceDataManager.removeSingleBalanceFromData(id, data);

          // Assert (Observation)
          expect(result, true);
          expect(data.balanceData.length, expectedLength);
        }
      });
    });

    group("updateSingleBalanceInData", () {
      test("id not found", () {
        // Arrange (Initialization)

        final data =
            generateRandomData();

        const String id = "Impossible id";


        // Act (Execution)
        final bool result = SingleBalanceDataManager
            .updateSingleBalanceInData(id, data, amount: 5);

        // Assert (Observation)
        expect(result, false);
      });

      test("id = ''", () {
        // Arrange (Initialization)
        final data =
            generateRandomData();



        // Act (Execution)
        final bool result = SingleBalanceDataManager
            .updateSingleBalanceInData("", data, amount: 5);

        // Assert (Observation)
        expect(result, false);
      });
      test("category == ''", () {
        // Arrange (Initialization)

        final data =
            generateRandomData();

        final math.Random rand = math.Random();
        final int idIndex = rand.nextInt(data.balanceData.length);
        final String id = data.balanceData[idIndex].id;



        // Act (Execution)
        final bool result = SingleBalanceDataManager
            .updateSingleBalanceInData(id, data, category: "");

        // Assert (Observation)
        expect(result, false);
      });
      test("currency == ''", () {
        // Arrange (Initialization)

        final data =
            generateRandomData();

        final math.Random rand = math.Random();
        final int idIndex = rand.nextInt(data.balanceData.length);
        final String id = data.balanceData[idIndex].id;



        // Act (Execution)
        final bool result = SingleBalanceDataManager
            .updateSingleBalanceInData(id, data, currency: "");

        // Assert (Observation)
        expect(result, false);
      });

      test("random data test", () {
        final math.Random rand = math.Random();


        final int max = rand.nextInt(200) + 1;
        for (int i = 0; i < max; i++) {
          // Arrange (Initialization)

          final data = generateRandomData();
          final int expectedLength = data.balanceData.length;
          final int idIndex = rand.nextInt(data.balanceData.length);
          final String id = data.balanceData[idIndex].id;

          // Act (Execution)
          final bool result =
              SingleBalanceDataManager.updateSingleBalanceInData(
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
          expect(data.balanceData.length, expectedLength);
          expect(data.balanceData[idIndex].amount, 5);
          expect(data.balanceData[idIndex].category, "allowance");
          expect(data.balanceData[idIndex].currency, "EUR");
          expect(data.balanceData[idIndex].name, "New Name");
          expect(
            data.balanceData[idIndex].time,
            Timestamp.fromMillisecondsSinceEpoch(1648000000000),
          );
        }
      });
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

    data.balanceData.add(
      SingleBalanceData(
          amount: amount,
          category: "none",
          currency: "EUR",
          name: "Item Nr $i",
          time: time,
          id: const Uuid().v4(),
      ),
    );
  }

  return data;
}
