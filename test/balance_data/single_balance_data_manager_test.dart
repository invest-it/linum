import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linum/balance_data/single_balance_data_manager.dart';
import 'package:linum/models/single_balance_data.dart';

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
        final Map<String, dynamic> data = {};

        // Act (Execution)
        singleBalanceDataManager.addSingleBalanceToData(singleBalance, data);

        // Assert (Observation)
        expect(data.keys.length, 0);
      });

      test("singleBalance.currency == ''", () {
        // Arrange (Initialization)
        final SingleBalanceData singleBalance = SingleBalanceData(
          amount: 5.55,
          category: "None",
          currency: "",
          name: "",
          time: Timestamp.fromDate(DateTime.now()),
        );

        final SingleBalanceDataManager singleBalanceDataManager =
            SingleBalanceDataManager();
        final Map<String, dynamic> data = {};

        // Act (Execution)
        singleBalanceDataManager.addSingleBalanceToData(singleBalance, data);

        // Assert (Observation)
        expect(data.keys.length, 0);
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
            category: "None",
            currency: "EUR",
            name: "Item Nr $i",
            time: time,
          );

          // Act (Execution)
          singleBalanceDataManager.addSingleBalanceToData(singleBalance, data);

          // Assert (Observation)
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
    group("removeSingleBalanceFromData", () {});
    group("updateSingleBalanceInData", () {});
  });
}
