//  Single Balance Data Manager Test
//
//  Author: SoTBurst
//  Co-Author: n/a
//

import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:flutter_test/flutter_test.dart';
import 'package:linum/core/balance/models/balance_document.dart';
import 'package:linum/core/balance/models/transaction.dart';
import 'package:linum/core/balance/utils/transaction_manager.dart';
import 'package:uuid/uuid.dart';

void main() {
  group("TransactionDataManager", () {
    group("addTransactionToData", () {
      test("transaction.category == ''", () {
        // Arrange (Initialization)
        final Transaction transaction = Transaction(
          amount: 5.55,
          category: "",
          currency: "EUR",
          name: "",
          time: firestore.Timestamp.fromDate(DateTime.now()),
        );


        final data = BalanceDocument();

        // Act (Execution)
        final bool result = TransactionManager.addTransactionToData(
          transaction,
          data,
        );

        // Assert (Observation)
        expect(result, false);
        expect(data.transactions.length, 0);
      });

      test("transaction.currency == ''", () {
        // Arrange (Initialization)
        final Transaction transaction = Transaction(
          amount: 5.55,
          category: "none",
          currency: "",
          name: "",
          time: firestore.Timestamp.fromDate(DateTime.now()),
        );


        final data = BalanceDocument();

        // Act (Execution)
        final bool result = TransactionManager.addTransactionToData(
          transaction,
          data,
        );

        // Assert (Observation)
        expect(result, false);
        expect(data.transactions.length, 0);
      });

      test("random data test", () {
        final math.Random rand = math.Random();


        final data = BalanceDocument();

        final int max = rand.nextInt(2000) + 1;
        for (int i = 0; i < max; i++) {
          // Arrange (Initialization)
          final num amount = rand.nextInt(100000) / 100.0;
          final firestore.Timestamp time = firestore.Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 365 * 4)).add(
                  Duration(
                    days: rand.nextInt(365 * 4 * 2),
                  ),
                ),
          );

          final Transaction transaction = Transaction(
            amount: amount,
            category: "none",
            currency: "EUR",
            name: "Item Nr $i",
            time: time,
          );

          // Act (Execution)
          final bool result = TransactionManager.addTransactionToData(
            transaction,
            data,
          );

          // Assert (Observation)
          expect(result, true);
          expect(
            data.transactions.last.amount,
            amount,
          );
          expect(
            data.transactions.last.name,
            "Item Nr $i",
          );
          expect(
            data.transactions.last.time,
            time,
          );
        }
        expect(data.transactions.length, max);
      });
    });
    group("removeTransactionFromData", () {
      test("id not found", () {
        // Arrange (Initialization)

        final data = generateRandomData();

        const String id = "Impossible id";


        final int expectedLength = data.transactions.length;

        // Act (Execution)
        final bool result =
            TransactionManager.removeTransactionFromData(id, data);

        // Assert (Observation)
        expect(result, false);
        expect(data.transactions.length, expectedLength);
      });

      test("random data test", () {
        final math.Random rand = math.Random();


        final int max = rand.nextInt(200) + 1;
        for (int i = 0; i < max; i++) {
          // Arrange (Initialization)

          final data = generateRandomData();
          final int expectedLength = data.transactions.length - 1;

          int idIndex = rand.nextInt(expectedLength + 1) - 1;
          idIndex = idIndex == -1 ? 0 : idIndex;
          final String id = data.transactions[idIndex].id;

          // Act (Execution)
          final bool result =
              TransactionManager.removeTransactionFromData(id, data);

          // Assert (Observation)
          expect(result, true);
          expect(data.transactions.length, expectedLength);
        }
      });
    });

    group("updateTransactionInData", () {
      test("id not found", () {
        // Arrange (Initialization)

        final data =
            generateRandomData();

        const String id = "Impossible id";


        // Act (Execution)
        final bool result = TransactionManager
            .updateTransactionInData(id, data, amount: 5);

        // Assert (Observation)
        expect(result, false);
      });

      test("id = ''", () {
        // Arrange (Initialization)
        final data =
            generateRandomData();



        // Act (Execution)
        final bool result = TransactionManager
            .updateTransactionInData("", data, amount: 5);

        // Assert (Observation)
        expect(result, false);
      });
      test("category == ''", () {
        // Arrange (Initialization)

        final data =
            generateRandomData();

        final math.Random rand = math.Random();
        final int idIndex = rand.nextInt(data.transactions.length);
        final String id = data.transactions[idIndex].id;



        // Act (Execution)
        final bool result = TransactionManager
            .updateTransactionInData(id, data, category: "");

        // Assert (Observation)
        expect(result, false);
      });
      test("currency == ''", () {
        // Arrange (Initialization)

        final data =
            generateRandomData();

        final math.Random rand = math.Random();
        final int idIndex = rand.nextInt(data.transactions.length);
        final String id = data.transactions[idIndex].id;



        // Act (Execution)
        final bool result = TransactionManager
            .updateTransactionInData(id, data, currency: "");

        // Assert (Observation)
        expect(result, false);
      });

      test("random data test", () {
        final math.Random rand = math.Random();


        final int max = rand.nextInt(200) + 1;
        for (int i = 0; i < max; i++) {
          // Arrange (Initialization)

          final data = generateRandomData();
          final int expectedLength = data.transactions.length;
          final int idIndex = rand.nextInt(data.transactions.length);
          final String id = data.transactions[idIndex].id;

          // Act (Execution)
          final bool result =
              TransactionManager.updateTransactionInData(
            id,
            data,
            amount: 5,
            category: "allowance",
            currency: "EUR",
            name: "New Name",
            time: firestore.Timestamp.fromMillisecondsSinceEpoch(1648000000000),
          );

          // Assert (Observation)
          expect(result, true);
          expect(data.transactions.length, expectedLength);
          expect(data.transactions[idIndex].amount, 5);
          expect(data.transactions[idIndex].category, "allowance");
          expect(data.transactions[idIndex].currency, "EUR");
          expect(data.transactions[idIndex].name, "New Name");
          expect(
            data.transactions[idIndex].time,
            firestore.Timestamp.fromMillisecondsSinceEpoch(1648000000000),
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
    final firestore.Timestamp time = firestore.Timestamp.fromDate(
      DateTime.now().subtract(const Duration(days: 365 * 4)).add(
            Duration(
              days: rand.nextInt(365 * 4 * 2),
            ),
          ),
    );

    data.transactions.add(
      Transaction(
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
