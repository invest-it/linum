//  Single Balance Data Manager Test
//
//  Author: SoTBurst
//  Co-Author: n/a
//

import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
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

        final SingleBalanceDataManager singleBalanceDataManager =
            SingleBalanceDataManager();
        final Map<String, dynamic> data = {"balanceData": []};

        // Act (Execution)
        final bool result = singleBalanceDataManager.addSingleBalanceToData(
          singleBalance,
          data,
        );

        // Assert (Observation)
        expect(result, false);
        expect((data["balanceData"] as List<dynamic>).length, 0);
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

        final SingleBalanceDataManager singleBalanceDataManager =
            SingleBalanceDataManager();
        final Map<String, dynamic> data = {"balanceData": []};

        // Act (Execution)
        final bool result = singleBalanceDataManager.addSingleBalanceToData(
          singleBalance,
          data,
        );

        // Assert (Observation)
        expect(result, false);
        expect((data["balanceData"] as List<dynamic>).length, 0);
      });

      test("random data test", () {
        final math.Random rand = math.Random();

        final SingleBalanceDataManager singleBalanceDataManager =
            SingleBalanceDataManager();
        final Map<String, dynamic> data = {"balanceData": []};

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
          final bool result = singleBalanceDataManager.addSingleBalanceToData(
            singleBalance,
            data,
          );

          // Assert (Observation)
          expect(result, true);
          expect(
            ((data["balanceData"] as List<dynamic>).last
                as Map<String, dynamic>)["amount"],
            amount,
          );
          expect(
            ((data["balanceData"] as List<dynamic>).last
                as Map<String, dynamic>)["name"],
            "Item Nr $i",
          );
          expect(
            ((data["balanceData"] as List<dynamic>).last
                as Map<String, dynamic>)["time"],
            time,
          );
        }
        expect((data["balanceData"] as List<dynamic>).length, max);
      });
    });
    group("removeSingleBalanceFromData", () {
      test("id not found", () {
        // Arrange (Initialization)

        final Map<String, List<Map<String, dynamic>>> data =
            generateRandomData();

        const String id = "Impossible id";

        final SingleBalanceDataManager singleBalanceDataManager =
            SingleBalanceDataManager();
        final int expectedLength = data["balanceData"]!.length;

        // Act (Execution)
        final bool result =
            singleBalanceDataManager.removeSingleBalanceFromData(id, data);

        // Assert (Observation)
        expect(result, false);
        expect(data["balanceData"]!.length, expectedLength);
      });

      test("random data test", () {
        final math.Random rand = math.Random();
        final SingleBalanceDataManager singleBalanceDataManager =
            SingleBalanceDataManager();

        final int max = rand.nextInt(200) + 1;
        for (int i = 0; i < max; i++) {
          // Arrange (Initialization)

          final Map<String, List<Map<String, dynamic>>> data =
              generateRandomData();
          final int expectedLength = data["balanceData"]!.length - 1;
          final int idIndex = rand.nextInt(expectedLength) + 1;
          final String id = data["balanceData"]![idIndex]["id"] as String;

          // Act (Execution)
          final bool result =
              singleBalanceDataManager.removeSingleBalanceFromData(id, data);

          // Assert (Observation)
          expect(result, true);
          expect(data["balanceData"]!.length, expectedLength);
        }
      });
    });

    group("updateSingleBalanceInData", () {
      test("id not found", () {
        // Arrange (Initialization)

        final Map<String, List<Map<String, dynamic>>> data =
            generateRandomData();

        const String id = "Impossible id";
        final SingleBalanceDataManager singleBalanceDataManager =
            SingleBalanceDataManager();

        // Act (Execution)
        final bool result = singleBalanceDataManager
            .updateSingleBalanceInData(id, data, amount: 5);

        // Assert (Observation)
        expect(result, false);
      });

      test("id = ''", () {
        // Arrange (Initialization)
        final Map<String, List<Map<String, dynamic>>> data =
            generateRandomData();

        final SingleBalanceDataManager singleBalanceDataManager =
            SingleBalanceDataManager();

        // Act (Execution)
        final bool result = singleBalanceDataManager
            .updateSingleBalanceInData("", data, amount: 5);

        // Assert (Observation)
        expect(result, false);
      });
      test("category == ''", () {
        // Arrange (Initialization)

        final Map<String, List<Map<String, dynamic>>> data =
            generateRandomData();

        final math.Random rand = math.Random();
        final int idIndex = rand.nextInt(data["balanceData"]!.length);
        final String id = data["balanceData"]![idIndex]["id"] as String;

        final SingleBalanceDataManager singleBalanceDataManager =
            SingleBalanceDataManager();

        // Act (Execution)
        final bool result = singleBalanceDataManager
            .updateSingleBalanceInData(id, data, category: "");

        // Assert (Observation)
        expect(result, false);
      });
      test("currency == ''", () {
        // Arrange (Initialization)

        final Map<String, List<Map<String, dynamic>>> data =
            generateRandomData();

        final math.Random rand = math.Random();
        final int idIndex = rand.nextInt(data["balanceData"]!.length);
        final String id = data["balanceData"]![idIndex]["id"] as String;

        final SingleBalanceDataManager singleBalanceDataManager =
            SingleBalanceDataManager();

        // Act (Execution)
        final bool result = singleBalanceDataManager
            .updateSingleBalanceInData(id, data, currency: "");

        // Assert (Observation)
        expect(result, false);
      });

      test("random data test", () {
        final math.Random rand = math.Random();
        final SingleBalanceDataManager singleBalanceDataManager =
            SingleBalanceDataManager();

        final int max = rand.nextInt(200) + 1;
        for (int i = 0; i < max; i++) {
          // Arrange (Initialization)

          final Map<String, List<Map<String, dynamic>>> data =
              generateRandomData();
          final int expectedLength = data["balanceData"]!.length;
          final int idIndex = rand.nextInt(data["balanceData"]!.length);
          final String id = data["balanceData"]![idIndex]["id"] as String;

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
          expect(data["balanceData"]!.length, expectedLength);
          expect(data["balanceData"]![idIndex]["amount"], 5);
          expect(data["balanceData"]![idIndex]["category"], "allowance");
          expect(data["balanceData"]![idIndex]["currency"], "EUR");
          expect(data["balanceData"]![idIndex]["name"], "New Name");
          expect(
            data["balanceData"]![idIndex]["time"],
            Timestamp.fromMillisecondsSinceEpoch(1648000000000),
          );
        }
      });
    });
  });
}

Map<String, List<Map<String, dynamic>>> generateRandomData({
  int averageNumberOfEntries = 1024,
}) {
  final Map<String, List<Map<String, dynamic>>> data = {"balanceData": []};
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
    data["balanceData"]!.add(<String, dynamic>{
      "amount": amount,
      "category": "none",
      "currency": "EUR",
      "name": "Item Nr $i",
      "time": time,
      "id": const Uuid().v4(),
    });
  }

  return data;
}
