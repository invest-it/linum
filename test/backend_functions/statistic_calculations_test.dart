//  Statistic Calculation Tests
//
//  Author: SoTBurst
//  Co-Author: n/a
//

import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:flutter_test/flutter_test.dart';
import 'package:linum/common/utils/filters.dart';
import 'package:linum/core/balance/models/transaction.dart';
import 'package:linum/core/balance/services/algorithm_service.dart';
import 'package:linum/core/balance/utils/statistical_calculations.dart';
import 'package:uuid/uuid.dart';

final Transaction baseTransaction = Transaction(
  amount: 0,
  category: "None",
  currency: "EUR",
  name: "Test Single Balance Data",
  date: Timestamp.fromMillisecondsSinceEpoch(
    Timestamp.now().millisecondsSinceEpoch - (3600 * 1000),
  ),
  id: const Uuid().v4(),
);

void main() {
  group("basic_statistic_calculation", () {
    final List<Transaction> emptyData = [];

    final List<Transaction> exampleData1 = [
      baseTransaction.copyWith(id: const Uuid().v4(), amount: 15),
      baseTransaction.copyWith(id: const Uuid().v4(), amount: 35.5),
      baseTransaction.copyWith(id: const Uuid().v4(), amount: 5),
      baseTransaction.copyWith(id: const Uuid().v4(), amount: 25.5),
    ];
    final List<Transaction> exampleData2 = [
      baseTransaction.copyWith(id: const Uuid().v4(), amount: -0.5),
      baseTransaction.copyWith(id: const Uuid().v4(), amount: -2.5),
      baseTransaction.copyWith(id: const Uuid().v4(), amount: -2.5),
      baseTransaction.copyWith(id: const Uuid().v4(), amount: -0),
    ];
    final List<Transaction> exampleData3 = [
      baseTransaction.copyWith(id: const Uuid().v4(), amount: -0.5),
      baseTransaction.copyWith(id: const Uuid().v4(), amount: -2.5),
      baseTransaction.copyWith(id: const Uuid().v4(), amount: -2.5),
      baseTransaction.copyWith(id: const Uuid().v4(), amount: -0),
      baseTransaction.copyWith(id: const Uuid().v4(), amount: 15),
      baseTransaction.copyWith(id: const Uuid().v4(), amount: 5),
      baseTransaction.copyWith(id: const Uuid().v4(), amount: 25.5),
      baseTransaction.copyWith(id: const Uuid().v4(), amount: 4),
    ];
    final List<Transaction> exampleData4 = [
      baseTransaction.copyWith(id: const Uuid().v4(), amount: -0.5),
      baseTransaction.copyWith(id: const Uuid().v4(), amount: -2.5),
      baseTransaction.copyWith(id: const Uuid().v4(), amount: -2.5),
      baseTransaction.copyWith(id: const Uuid().v4(), amount: -0),
      baseTransaction.copyWith(id: const Uuid().v4(), amount: 15),
      baseTransaction.copyWith(id: const Uuid().v4(), amount: 5),
      baseTransaction.copyWith(id: const Uuid().v4(), amount: 25.5),
      baseTransaction.copyWith(id: const Uuid().v4(), amount: 4),
      baseTransaction.copyWith(id: const Uuid().v4(), amount: -20.5),
      baseTransaction.copyWith(id: const Uuid().v4(), amount: -23.5),
    ];
    final List<Transaction> exampleData5 = [
      baseTransaction.copyWith(id: const Uuid().v4(), amount: -0),
      baseTransaction.copyWith(id: const Uuid().v4(), amount: -0),
      baseTransaction.copyWith(id: const Uuid().v4(), amount: -0),
      baseTransaction.copyWith(id: const Uuid().v4(), amount: -0),
    ];

    group("balance", () {
      group("sum", () {
        test("empty data", () {
          // Arrange (Initialization)
          final StatisticalCalculations statisticsCalculations =
              StatisticalCalculations(
            data: emptyData,
            serialData: [],
            standardCurrencyName: "EUR",
            algorithms: (AlgorithmService()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              )).state,
          );
          const num expectedSum = 0;

          // Act (Execution)
          final num sum = statisticsCalculations.sumBalance;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 1 (only incomes)", () {
          // Arrange (Initialization)
          final StatisticalCalculations statisticsCalculations =
              StatisticalCalculations(
            data: exampleData1,
            serialData: [],
            standardCurrencyName: "EUR",
            algorithms: (AlgorithmService()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              )).state,
          );
          const num expectedSum = 81;

          // Act (Execution)
          final num sum = statisticsCalculations.sumBalance;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 2 (only expenses)", () {
          // Arrange (Initialization)
          final StatisticalCalculations statisticsCalculations =
              StatisticalCalculations(
            data: exampleData2,
            serialData: [],
            standardCurrencyName: "EUR",
            algorithms: (AlgorithmService()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              )).state,
          );
          const num expectedSum = -5.5;

          // Act (Execution)
          final num sum = statisticsCalculations.sumBalance;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 3", () {
          // Arrange (Initialization)
          final StatisticalCalculations statisticsCalculations =
              StatisticalCalculations(
            data: exampleData3,
            serialData: [],
            standardCurrencyName: "EUR",
            algorithms: (AlgorithmService()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              )).state,
          );
          const num expectedSum = 44;

          // Act (Execution)
          final num sum = statisticsCalculations.sumBalance;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 4 (adds up to 0)", () {
          // Arrange (Initialization)
          final StatisticalCalculations statisticsCalculations =
              StatisticalCalculations(
            data: exampleData4,
            serialData: [],
            standardCurrencyName: "EUR",
            algorithms: (AlgorithmService()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              )).state,
          );
          const num expectedSum = 0;

          // Act (Execution)
          final num sum = statisticsCalculations.sumBalance;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 5 (only 0 expenses)", () {
          // Arrange (Initialization)
          final StatisticalCalculations statisticsCalculations =
              StatisticalCalculations(
            data: exampleData5,
            serialData: [],
            standardCurrencyName: "EUR",
            algorithms: (AlgorithmService()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              )).state,
          );
          const num expectedSum = 0;

          // Act (Execution)
          final num sum = statisticsCalculations.sumBalance;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("random data", () {
          final math.Random rand = math.Random();
          for (int i = 0; i < 10000; i++) {
            // Arrange (Initialization)
            final List<Transaction> randomData =
                _createRandomStatisticDataWithFixedTime(rand);
            final StatisticalCalculations statisticsCalculations =
                StatisticalCalculations(
              data: randomData,
              serialData: [],
              standardCurrencyName: "EUR",
              algorithms: (AlgorithmService()
                ..setCurrentFilterAlgorithm(
                  Filters.noFilter,
                )).state,
            );
            num expectedSum = 0;
            for (int i = 0; i < randomData.length; i++) {
              expectedSum += randomData[i].amount;
            }

            // Act (Execution)
            final num sum = statisticsCalculations.sumBalance;

            // Assert (Observation)
            expect(sum, expectedSum);
          }
        });
      });

      group("average", () {
        test("empty data", () {
          // Arrange (Initialization)
          final StatisticalCalculations statisticsCalculations =
              StatisticalCalculations(
            data: emptyData,
            serialData: [],
            standardCurrencyName: "EUR",
            algorithms: (AlgorithmService()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              )).state,
          );
          const num expectedAverage = 0;

          // Act (Execution)
          final num average = statisticsCalculations.averageBalance;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 1 (only incomes)", () {
          // Arrange (Initialization)
          final StatisticalCalculations statisticsCalculations =
              StatisticalCalculations(
            data: exampleData1,
            serialData: [],
            standardCurrencyName: "EUR",
            algorithms: (AlgorithmService()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              )).state,
          );
          const num expectedAverage = 20.25;

          // Act (Execution)
          final num average = statisticsCalculations.averageBalance;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 2 (only expenses)", () {
          // Arrange (Initialization)
          final StatisticalCalculations statisticsCalculations =
              StatisticalCalculations(
            data: exampleData2,
            serialData: [],
            standardCurrencyName: "EUR",
            algorithms: (AlgorithmService()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              )).state,
          );
          const num expectedAverage = -1.375;

          // Act (Execution)
          final num average = statisticsCalculations.averageBalance;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 3", () {
          // Arrange (Initialization)
          final StatisticalCalculations statisticsCalculations =
              StatisticalCalculations(
            data: exampleData3,
            serialData: [],
            standardCurrencyName: "EUR",
            algorithms: (AlgorithmService()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              )).state,
          );
          const num expectedAverage = 5.5;

          // Act (Execution)
          final num average = statisticsCalculations.averageBalance;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 4 (adds up to 0)", () {
          // Arrange (Initialization)
          final StatisticalCalculations statisticsCalculations =
              StatisticalCalculations(
            data: exampleData4,
            serialData: [],
            standardCurrencyName: "EUR",
            algorithms: (AlgorithmService()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              )).state,
          );
          const num expectedAverage = 0;

          // Act (Execution)
          final num average = statisticsCalculations.averageBalance;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 5 (only 0 expenses)", () {
          // Arrange (Initialization)
          final StatisticalCalculations statisticsCalculations =
              StatisticalCalculations(
            data: exampleData5,
            serialData: [],
            standardCurrencyName: "EUR",
            algorithms: (AlgorithmService()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              )).state,
          );
          const num expectedAverage = 0;

          // Act (Execution)
          final num average = statisticsCalculations.averageBalance;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("random data", () {
          final math.Random rand = math.Random();
          for (int i = 0; i < 10000; i++) {
            // Arrange (Initialization)
            final List<Transaction> randomData =
                _createRandomStatisticDataWithFixedTime(rand);
            final StatisticalCalculations statisticsCalculations =
                StatisticalCalculations(
              data: randomData,
              serialData: [],
              standardCurrencyName: "EUR",
              algorithms: (AlgorithmService()
                ..setCurrentFilterAlgorithm(
                  Filters.noFilter,
                )).state,
            );
            num expectedAverage = 0;
            for (int i = 0; i < randomData.length; i++) {
              expectedAverage += randomData[i].amount;
            }
            expectedAverage /= randomData.length;

            // Act (Execution)
            final num average = statisticsCalculations.averageBalance;

            // Assert (Observation)
            expect(average, expectedAverage);
          }
        });
      });
    });

    group("income", () {
      group("sum", () {
        test("empty data", () {
          // Arrange (Initialization)
          final StatisticalCalculations statisticsCalculations =
              StatisticalCalculations(
            data: emptyData,
            serialData: [],
            standardCurrencyName: "EUR",
            algorithms: (AlgorithmService()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              )).state,
          );
          const num expectedSum = 0;

          // Act (Execution)
          final num sum = statisticsCalculations.sumIncomes;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 1 (only incomes)", () {
          // Arrange (Initialization)
          final StatisticalCalculations statisticsCalculations =
              StatisticalCalculations(
            data: exampleData1,
            serialData: [],
            standardCurrencyName: "EUR",
            algorithms: (AlgorithmService()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              )).state,
          );
          const num expectedSum = 81;

          // Act (Execution)
          final num sum = statisticsCalculations.sumIncomes;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 2 (only expenses)", () {
          // Arrange (Initialization)
          final StatisticalCalculations statisticsCalculations =
              StatisticalCalculations(
            data: exampleData2,
            serialData: [],
            standardCurrencyName: "EUR",
            algorithms: (AlgorithmService()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              )).state,
          );
          const num expectedSum = 0;

          // Act (Execution)
          final num sum = statisticsCalculations.sumIncomes;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 3", () {
          // Arrange (Initialization)
          final StatisticalCalculations statisticsCalculations =
              StatisticalCalculations(
            data: exampleData3,
            serialData: [],
            standardCurrencyName: "EUR",
            algorithms: (AlgorithmService()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              )).state,
          );
          const num expectedSum = 49.5;

          // Act (Execution)
          final num sum = statisticsCalculations.sumIncomes;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 4 (adds up to 0)", () {
          // Arrange (Initialization)
          final StatisticalCalculations statisticsCalculations =
              StatisticalCalculations(
            data: exampleData4,
            serialData: [],
            standardCurrencyName: "EUR",
            algorithms: (AlgorithmService()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              )).state,
          );
          const num expectedSum = 49.5;

          // Act (Execution)
          final num sum = statisticsCalculations.sumIncomes;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 5 (only 0 expenses)", () {
          // Arrange (Initialization)
          final StatisticalCalculations statisticsCalculations =
              StatisticalCalculations(
            data: exampleData5,
            serialData: [],
            standardCurrencyName: "EUR",
            algorithms: (AlgorithmService()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              )).state,
          );
          const num expectedSum = 0;

          // Act (Execution)
          final num sum = statisticsCalculations.sumIncomes;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("random data", () {
          final math.Random rand = math.Random();
          for (int i = 0; i < 10000; i++) {
            // Arrange (Initialization)
            final List<Transaction> randomData =
                _createRandomStatisticDataWithFixedTime(rand);
            final StatisticalCalculations statisticsCalculations =
                StatisticalCalculations(
              data: randomData,
              serialData: [],
              standardCurrencyName: "EUR",
              algorithms: (AlgorithmService()
                ..setCurrentFilterAlgorithm(
                  Filters.noFilter,
                )).state,
            );
            num expectedSum = 0;
            for (int i = 0; i < randomData.length; i++) {
              if (randomData[i].amount > 0) {
                expectedSum += randomData[i].amount;
              }
            }

            // Act (Execution)
            final num sum = statisticsCalculations.sumIncomes;

            // Assert (Observation)
            expect(sum, expectedSum);
          }
        });
      });
      group("average", () {
        test("empty data", () {
          // Arrange (Initialization)
          final StatisticalCalculations statisticsCalculations =
              StatisticalCalculations(
            data: emptyData,
            serialData: [],
            standardCurrencyName: "EUR",
            algorithms: (AlgorithmService()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              )).state,
          );
          const num expectedAverage = 0;

          // Act (Execution)
          final num average = statisticsCalculations.averageIncomes;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 1 (only incomes)", () {
          // Arrange (Initialization)
          final StatisticalCalculations statisticsCalculations =
              StatisticalCalculations(
            data: exampleData1,
            serialData: [],
            standardCurrencyName: "EUR",
            algorithms: (AlgorithmService()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              )).state,
          );
          const num expectedAverage = 20.25;

          // Act (Execution)
          final num average = statisticsCalculations.averageIncomes;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 2 (only expenses)", () {
          // Arrange (Initialization)
          final StatisticalCalculations statisticsCalculations =
              StatisticalCalculations(
            data: exampleData2,
            serialData: [],
            standardCurrencyName: "EUR",
            algorithms: (AlgorithmService()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              )).state,
          );
          const num expectedAverage = 0;

          // Act (Execution)
          final num average = statisticsCalculations.averageIncomes;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 3", () {
          // Arrange (Initialization)
          final StatisticalCalculations statisticsCalculations =
              StatisticalCalculations(
            data: exampleData3,
            serialData: [],
            standardCurrencyName: "EUR",
            algorithms: (AlgorithmService()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              )).state,
          );
          const num expectedAverage = 12.375;

          // Act (Execution)
          final num average = statisticsCalculations.averageIncomes;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 4 (adds up to 0)", () {
          // Arrange (Initialization)
          final StatisticalCalculations statisticsCalculations =
              StatisticalCalculations(
            data: exampleData4,
            serialData: [],
            standardCurrencyName: "EUR",
            algorithms: (AlgorithmService()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              )).state,
          );
          const num expectedAverage = 12.375;

          // Act (Execution)
          final num average = statisticsCalculations.averageIncomes;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 5 (only 0 expenses)", () {
          // Arrange (Initialization)
          final StatisticalCalculations statisticsCalculations =
              StatisticalCalculations(
            data: exampleData5,
            serialData: [],
            standardCurrencyName: "EUR",
            algorithms: (AlgorithmService()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              )).state,
          );
          const num expectedAverage = 0;

          // Act (Execution)
          final num average = statisticsCalculations.averageIncomes;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("random data", () {
          final math.Random rand = math.Random();
          for (int i = 0; i < 10000; i++) {
            // Arrange (Initialization)
            final List<Transaction> randomData =
                _createRandomStatisticDataWithFixedTime(rand);
            final StatisticalCalculations statisticsCalculations =
                StatisticalCalculations(
              data: randomData,
              serialData: [],
              standardCurrencyName: "EUR",
              algorithms: (AlgorithmService()
                ..setCurrentFilterAlgorithm(
                  Filters.noFilter,
                )).state,
            );
            num expectedAverage = 0;
            int incomes = 0;
            for (int i = 0; i < randomData.length; i++) {
              if (randomData[i].amount > 0) {
                expectedAverage += randomData[i].amount;

                incomes++;
              }
            }
            if (incomes > 0) {
              expectedAverage /= incomes;
            }
            // Act (Execution)
            final num average = statisticsCalculations.averageIncomes;

            // Assert (Observation)
            expect(average, expectedAverage);
          }
        });
      });
    });

    group("costs", () {
      group("sum", () {
        test("empty data", () {
          // Arrange (Initialization)
          final StatisticalCalculations statisticsCalculations =
              StatisticalCalculations(
            data: emptyData,
            serialData: [],
            standardCurrencyName: "EUR",
            algorithms: (AlgorithmService()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              )).state,
          );
          const num expectedSum = 0;

          // Act (Execution)
          final num sum = statisticsCalculations.sumCosts;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 1 (only incomes)", () {
          // Arrange (Initialization)
          final StatisticalCalculations statisticsCalculations =
              StatisticalCalculations(
            data: exampleData1,
            serialData: [],
            standardCurrencyName: "EUR",
            algorithms: (AlgorithmService()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              )).state,
          );
          const num expectedSum = 0;

          // Act (Execution)
          final num sum = statisticsCalculations.sumCosts;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 2 (only expenses)", () {
          // Arrange (Initialization)
          final StatisticalCalculations statisticsCalculations =
              StatisticalCalculations(
            data: exampleData2,
            serialData: [],
            standardCurrencyName: "EUR",
            algorithms: (AlgorithmService()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              )).state,
          );
          const num expectedSum = -5.5;

          // Act (Execution)
          final num sum = statisticsCalculations.sumCosts;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 3", () {
          // Arrange (Initialization)
          final StatisticalCalculations statisticsCalculations =
              StatisticalCalculations(
            data: exampleData3,
            serialData: [],
            standardCurrencyName: "EUR",
            algorithms: (AlgorithmService()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              )).state,
          );
          const num expectedSum = -5.5;

          // Act (Execution)
          final num sum = statisticsCalculations.sumCosts;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 4 (adds up to 0)", () {
          // Arrange (Initialization)
          final StatisticalCalculations statisticsCalculations =
              StatisticalCalculations(
            data: exampleData4,
            serialData: [],
            standardCurrencyName: "EUR",
            algorithms: (AlgorithmService()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              )).state,
          );
          const num expectedSum = -49.5;

          // Act (Execution)
          final num sum = statisticsCalculations.sumCosts;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 5 (only 0 expenses)", () {
          // Arrange (Initialization)
          final StatisticalCalculations statisticsCalculations =
              StatisticalCalculations(
            data: exampleData5,
            serialData: [],
            standardCurrencyName: "EUR",
            algorithms: (AlgorithmService()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              )).state,
          );
          const num expectedSum = 0;

          // Act (Execution)
          final num sum = statisticsCalculations.sumCosts;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("random data", () {
          final math.Random rand = math.Random();
          for (int i = 0; i < 10000; i++) {
            // Arrange (Initialization)
            final List<Transaction> randomData =
                _createRandomStatisticDataWithFixedTime(rand);
            final StatisticalCalculations statisticsCalculations =
                StatisticalCalculations(
              data: randomData,
              serialData: [],
              standardCurrencyName: "EUR",
              algorithms: (AlgorithmService()
                ..setCurrentFilterAlgorithm(
                  Filters.noFilter,
                )).state,
            );
            num expectedSum = 0;
            for (int i = 0; i < randomData.length; i++) {
              if (randomData[i].amount <= 0) {
                expectedSum += randomData[i].amount;
              }
            }

            // Act (Execution)
            final num sum = statisticsCalculations.sumCosts;

            // Assert (Observation)
            expect(sum, expectedSum);
          }
        });
      });

      group("average", () {
        test("empty data", () {
          // Arrange (Initialization)
          final StatisticalCalculations statisticsCalculations =
              StatisticalCalculations(
            data: emptyData,
            serialData: [],
            standardCurrencyName: "EUR",
            algorithms: (AlgorithmService()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              )).state,
          );
          const num expectedAverage = 0;

          // Act (Execution)
          final num average = statisticsCalculations.averageCosts;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 1 (only incomes)", () {
          // Arrange (Initialization)
          final StatisticalCalculations statisticsCalculations =
              StatisticalCalculations(
            data: exampleData1,
            serialData: [],
            standardCurrencyName: "EUR",
            algorithms: (AlgorithmService()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              )).state,
          );
          const num expectedAverage = 0;

          // Act (Execution)
          final num average = statisticsCalculations.averageCosts;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 2 (only expenses)", () {
          // Arrange (Initialization)
          final StatisticalCalculations statisticsCalculations =
              StatisticalCalculations(
            data: exampleData2,
            serialData: [],
            standardCurrencyName: "EUR",
            algorithms: (AlgorithmService()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              )).state,
          );
          const num expectedAverage = -1.375;

          // Act (Execution)
          final num average = statisticsCalculations.averageCosts;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 3", () {
          // Arrange (Initialization)
          final StatisticalCalculations statisticsCalculations =
              StatisticalCalculations(
            data: exampleData3,
            serialData: [],
            standardCurrencyName: "EUR",
            algorithms: (AlgorithmService()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              )).state,
          );
          const num expectedAverage = -1.375;

          // Act (Execution)
          final num average = statisticsCalculations.averageCosts;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 4 (adds up to 0)", () {
          // Arrange (Initialization)
          final StatisticalCalculations statisticsCalculations =
              StatisticalCalculations(
            data: exampleData4,
            serialData: [],
            standardCurrencyName: "EUR",
            algorithms: (AlgorithmService()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              )).state,
          );
          const num expectedAverage = -8.25;

          // Act (Execution)
          final num average = statisticsCalculations.averageCosts;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 5 (only 0 expenses)", () {
          // Arrange (Initialization)
          final StatisticalCalculations statisticsCalculations =
              StatisticalCalculations(
            data: exampleData5,
            serialData: [],
            standardCurrencyName: "EUR",
            algorithms: (AlgorithmService()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              )).state,
          );
          const num expectedAverage = 0;

          // Act (Execution)
          final num average = statisticsCalculations.averageCosts;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("random data", () {
          final math.Random rand = math.Random();
          for (int i = 0; i < 10000; i++) {
            // Arrange (Initialization)
            final List<Transaction> randomData =
                _createRandomStatisticDataWithFixedTime(rand);
            final StatisticalCalculations statisticsCalculations =
                StatisticalCalculations(
              data: randomData,
              serialData: [],
              standardCurrencyName: "EUR",
              algorithms: (AlgorithmService()
                ..setCurrentFilterAlgorithm(
                  Filters.noFilter,
                )).state,
            );
            num expectedAverage = 0;
            int costs = 0;
            for (int i = 0; i < randomData.length; i++) {
              if (randomData[i].amount <= 0) {
                expectedAverage += randomData[i].amount;

                costs++;
              }
            }
            if (costs > 0) {
              expectedAverage /= costs;
            }
            // Act (Execution)
            final num average = statisticsCalculations.averageCosts;

            // Assert (Observation)
            expect(average, expectedAverage);
          }
        });
      });
    });
  });
}

List<Transaction> _createRandomStatisticDataWithFixedTime(
  math.Random rand,
) {
  final List<Transaction> returnList = <Transaction>[];
  final int max = rand.nextInt(256) + 1;
  for (int i = 0; i < max; i++) {
    returnList.add(
      baseTransaction.copyWith(
        amount:
            ((((0.5 - rand.nextDouble()) * 2 * 256) * 100).roundToDouble()) /
                100.0,
        id: const Uuid().v4(),
      ),
    ); // create a random Number from -256 to 256
  }
  return returnList;
}
