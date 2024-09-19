//  Single Balance Data Manager Test
//
//  Author: SoTBurst
//  Co-Author: n/a
//

import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:linum/core/balance/domain/models/transaction.dart';
import 'package:linum/core/balance/ports/firebase/balance_document.dart';
import 'package:uuid/uuid.dart';

import 'balance_test_utils.dart';

void main() {
  group("TransactionDataManager", () {
    group("addTransactionToData", () {
      test("transaction.category == ''", () async {
        // Arrange (Initialization)
        final Transaction transaction = Transaction(
          amount: 5.55,
          category: "",
          currency: "EUR",
          name: "",
          date: DateTime.now(),
        );

        final data = BalanceDocument();
        final service = await createService(data);

        // Act (Execution)

        expectLater(() => service.addTransaction(transaction), throwsArgumentError);

        // Assert (Observation)
        expect(data.transactions.length, 0);
      });

      test("transaction.currency == ''", () async {
        // Arrange (Initialization)
        final Transaction transaction = Transaction(
          amount: 5.55,
          category: "none",
          currency: "",
          name: "",
          date: DateTime.now(),
        );

        final data = BalanceDocument();
        final service = await createService(data);

        // Act (Execution)
        expectLater(() => service.addTransaction(transaction), throwsArgumentError);

        // Assert (Observation)
        expect(data.transactions.length, 0);
      });

      test("random data test", () async {
        final math.Random rand = math.Random();


        final data = BalanceDocument();
        final service = await createService(data);

        final int max = rand.nextInt(2000) + 1;
        for (int i = 0; i < max; i++) {
          // Arrange (Initialization)
          final num amount = rand.nextInt(100000) / 100.0;
          final time = DateTime.now().subtract(const Duration(days: 365 * 4)).add(
            Duration(
              days: rand.nextInt(365 * 4 * 2),
            ),
          );

          final Transaction transaction = Transaction(
            amount: amount,
            category: "none",
            currency: "EUR",
            name: "Item Nr $i",
            date: time,
          );

          // Act (Execution)
          await service.addTransaction(
            transaction,
          );

          // Assert (Observation)
          expect(
            data.transactions.last.amount,
            amount,
          );
          expect(
            data.transactions.last.name,
            "Item Nr $i",
          );
          expect(
            data.transactions.last.date,
            time,
          );
        }
        expect(data.transactions.length, max);
      });
    });
    group("removeTransactionFromData", () {
      test("id not found", () async {
        // Arrange (Initialization)

        final data = generateRandomData();
        final service = await createService(data);

        const String id = "Impossible id";


        final int expectedLength = data.transactions.length;

        // Act (Execution)
        await service.removeTransaction(createTransactionWithId(id));
        

        // Assert (Observation)
        expect(data.transactions.length, expectedLength);
      });

      test("random data test", () async {
        final math.Random rand = math.Random();


        final int max = rand.nextInt(200) + 1;
        for (int i = 0; i < max; i++) {
          // Arrange (Initialization)

          final data = generateRandomData();
          final service = await createService(data);

          final int expectedLength = data.transactions.length - 1;

          int idIndex = rand.nextInt(expectedLength + 1) - 1;
          idIndex = idIndex == -1 ? 0 : idIndex;
          final transaction = data.transactions[idIndex];

          // Act (Execution)
          await service.removeTransaction(transaction);

          // Assert (Observation)
          expect(data.transactions.length, expectedLength);
        }
      });
    });

    group("updateTransactionInData", () {
      // TODO: Handle test cases
      /* test("id not found", () {
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

       */
      test("category == ''", () async {
        // Arrange (Initialization)

        final data =
            generateRandomData();
        final service = await createService(data);

        final math.Random rand = math.Random();
        final int idIndex = rand.nextInt(data.transactions.length);
        final transaction = data.transactions[idIndex];



        // Act (Execution) && Assert (Observation)
        expectLater(service.updateTransaction(transaction.copyWith(category: "")), throwsArgumentError);


      });
      test("currency == ''", () async {
        // Arrange (Initialization)

        final data =
            generateRandomData();
        final service = await createService(data);

        final math.Random rand = math.Random();
        final int idIndex = rand.nextInt(data.transactions.length);
        final transaction = data.transactions[idIndex];



        // Act (Execution) && Assert (Observation)
        expectLater(service.updateTransaction(transaction.copyWith(currency: "")), throwsArgumentError);

      });

      test("random data test", () async {
        final math.Random rand = math.Random();

        final int max = rand.nextInt(200) + 1;
        for (int i = 0; i < max; i++) {
          // Arrange (Initialization)

          final data = generateRandomData();
          final service = await createService(data);

          final int expectedLength = data.transactions.length;
          final int idIndex = rand.nextInt(data.transactions.length);
          final transaction = data.transactions[idIndex];

          final update = transaction.copyWith(
            amount: 5,
            category: "allowance",
            currency: "EUR",
            name: "New Name",
            date: DateTime.fromMillisecondsSinceEpoch(1648000000000),
          );

          // Act (Execution)
          await service.updateTransaction(
            update,
          );

          // Assert (Observation)
          expect(data.transactions.length, expectedLength);
          expect(data.transactions[idIndex].amount, 5);
          expect(data.transactions[idIndex].category, "allowance");
          expect(data.transactions[idIndex].currency, "EUR");
          expect(data.transactions[idIndex].name, "New Name");
          expect(
            data.transactions[idIndex].date,
            DateTime.fromMillisecondsSinceEpoch(1648000000000),
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
    final time = DateTime.now().subtract(const Duration(days: 365 * 4)).add(
      Duration(
        days: rand.nextInt(365 * 4 * 2),
      ),
    );

    data.transactions.add(
      Transaction(
          amount: amount,
          category: "none",
          currency: "EUR",
          name: "Item Nr $i",
          date: time,
          id: const Uuid().v4(),
      ),
    );
  }

  return data;
}
