//  Statistic Calculation Tests
//
//  Author: SoTBurst
//  Co-Author: n/a
//

import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:flutter_test/flutter_test.dart';
import 'package:linum/models/transaction.dart';
import 'package:linum/providers/algorithm_provider.dart';
import 'package:linum/utilities/backend/statistic_calculations.dart';
import 'package:linum/utilities/frontend/filters.dart';
import 'package:uuid/uuid.dart';

final Transaction baseSingleBalanceData = Transaction(
  amount: 0,
  category: "None",
  currency: "EUR",
  name: "Test Single Balance Data",
  time: firestore.Timestamp.fromMillisecondsSinceEpoch(
    firestore.Timestamp.now().millisecondsSinceEpoch - (3600 * 1000),
  ),
  id: const Uuid().v4(),
);

void main() {
  group("basic_statistic_calculation", () {
    final List<Transaction> emptyData = [];

    final List<Transaction> exampleData1 = [
      baseSingleBalanceData.copyWith(id: const Uuid().v4(), amount: 15),
      baseSingleBalanceData.copyWith(id: const Uuid().v4(), amount: 35.5),
      baseSingleBalanceData.copyWith(id: const Uuid().v4(), amount: 5),
      baseSingleBalanceData.copyWith(id: const Uuid().v4(), amount: 25.5),
    ];
    final List<Transaction> exampleData2 = [
      baseSingleBalanceData.copyWith(id: const Uuid().v4(), amount: -0.5),
      baseSingleBalanceData.copyWith(id: const Uuid().v4(), amount: -2.5),
      baseSingleBalanceData.copyWith(id: const Uuid().v4(), amount: -2.5),
      baseSingleBalanceData.copyWith(id: const Uuid().v4(), amount: -0),
    ];
    final List<Transaction> exampleData3 = [
      baseSingleBalanceData.copyWith(id: const Uuid().v4(), amount: -0.5),
      baseSingleBalanceData.copyWith(id: const Uuid().v4(), amount: -2.5),
      baseSingleBalanceData.copyWith(id: const Uuid().v4(), amount: -2.5),
      baseSingleBalanceData.copyWith(id: const Uuid().v4(), amount: -0),
      baseSingleBalanceData.copyWith(id: const Uuid().v4(), amount: 15),
      baseSingleBalanceData.copyWith(id: const Uuid().v4(), amount: 5),
      baseSingleBalanceData.copyWith(id: const Uuid().v4(), amount: 25.5),
      baseSingleBalanceData.copyWith(id: const Uuid().v4(), amount: 4),
    ];
    final List<Transaction> exampleData4 = [
      baseSingleBalanceData.copyWith(id: const Uuid().v4(), amount: -0.5),
      baseSingleBalanceData.copyWith(id: const Uuid().v4(), amount: -2.5),
      baseSingleBalanceData.copyWith(id: const Uuid().v4(), amount: -2.5),
      baseSingleBalanceData.copyWith(id: const Uuid().v4(), amount: -0),
      baseSingleBalanceData.copyWith(id: const Uuid().v4(), amount: 15),
      baseSingleBalanceData.copyWith(id: const Uuid().v4(), amount: 5),
      baseSingleBalanceData.copyWith(id: const Uuid().v4(), amount: 25.5),
      baseSingleBalanceData.copyWith(id: const Uuid().v4(), amount: 4),
      baseSingleBalanceData.copyWith(id: const Uuid().v4(), amount: -20.5),
      baseSingleBalanceData.copyWith(id: const Uuid().v4(), amount: -23.5),
    ];
    final List<Transaction> exampleData5 = [
      baseSingleBalanceData.copyWith(id: const Uuid().v4(), amount: -0),
      baseSingleBalanceData.copyWith(id: const Uuid().v4(), amount: -0),
      baseSingleBalanceData.copyWith(id: const Uuid().v4(), amount: -0),
      baseSingleBalanceData.copyWith(id: const Uuid().v4(), amount: -0),
    ];

    group("balance", () {
      group("sum", () {
        test("empty data", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(
            emptyData,
            AlgorithmProvider()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              ),
          );
          const num expectedSum = 0;

          // Act (Execution)
          final num sum = statisticsCalculations.sumBalance;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 1 (only incomes)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(
            exampleData1,
            AlgorithmProvider()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              ),
          );
          const num expectedSum = 81;

          // Act (Execution)
          final num sum = statisticsCalculations.sumBalance;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 2 (only expenses)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(
            exampleData2,
            AlgorithmProvider()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              ),
          );
          const num expectedSum = -5.5;

          // Act (Execution)
          final num sum = statisticsCalculations.sumBalance;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 3", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(
            exampleData3,
            AlgorithmProvider()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              ),
          );
          const num expectedSum = 44;

          // Act (Execution)
          final num sum = statisticsCalculations.sumBalance;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 4 (adds up to 0)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(
            exampleData4,
            AlgorithmProvider()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              ),
          );
          const num expectedSum = 0;

          // Act (Execution)
          final num sum = statisticsCalculations.sumBalance;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 5 (only 0 expenses)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(
            exampleData5,
            AlgorithmProvider()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              ),
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
            final StatisticsCalculations statisticsCalculations =
                StatisticsCalculations(
              randomData,
              AlgorithmProvider()
                ..setCurrentFilterAlgorithm(
                  Filters.noFilter,
                ),
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
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(
            emptyData,
            AlgorithmProvider()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              ),
          );
          const num expectedAverage = 0;

          // Act (Execution)
          final num average = statisticsCalculations.averageBalance;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 1 (only incomes)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(
            exampleData1,
            AlgorithmProvider()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              ),
          );
          const num expectedAverage = 20.25;

          // Act (Execution)
          final num average = statisticsCalculations.averageBalance;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 2 (only expenses)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(
            exampleData2,
            AlgorithmProvider()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              ),
          );
          const num expectedAverage = -1.375;

          // Act (Execution)
          final num average = statisticsCalculations.averageBalance;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 3", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(
            exampleData3,
            AlgorithmProvider()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              ),
          );
          const num expectedAverage = 5.5;

          // Act (Execution)
          final num average = statisticsCalculations.averageBalance;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 4 (adds up to 0)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(
            exampleData4,
            AlgorithmProvider()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              ),
          );
          const num expectedAverage = 0;

          // Act (Execution)
          final num average = statisticsCalculations.averageBalance;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 5 (only 0 expenses)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(
            exampleData5,
            AlgorithmProvider()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              ),
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
            final StatisticsCalculations statisticsCalculations =
                StatisticsCalculations(
              randomData,
              AlgorithmProvider()
                ..setCurrentFilterAlgorithm(
                  Filters.noFilter,
                ),
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
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(
            emptyData,
            AlgorithmProvider()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              ),
          );
          const num expectedSum = 0;

          // Act (Execution)
          final num sum = statisticsCalculations.sumIncomes;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 1 (only incomes)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(
            exampleData1,
            AlgorithmProvider()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              ),
          );
          const num expectedSum = 81;

          // Act (Execution)
          final num sum = statisticsCalculations.sumIncomes;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 2 (only expenses)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(
            exampleData2,
            AlgorithmProvider()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              ),
          );
          const num expectedSum = 0;

          // Act (Execution)
          final num sum = statisticsCalculations.sumIncomes;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 3", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(
            exampleData3,
            AlgorithmProvider()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              ),
          );
          const num expectedSum = 49.5;

          // Act (Execution)
          final num sum = statisticsCalculations.sumIncomes;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 4 (adds up to 0)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(
            exampleData4,
            AlgorithmProvider()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              ),
          );
          const num expectedSum = 49.5;

          // Act (Execution)
          final num sum = statisticsCalculations.sumIncomes;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 5 (only 0 expenses)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(
            exampleData5,
            AlgorithmProvider()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              ),
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
            final StatisticsCalculations statisticsCalculations =
                StatisticsCalculations(
              randomData,
              AlgorithmProvider()
                ..setCurrentFilterAlgorithm(
                  Filters.noFilter,
                ),
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
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(
            emptyData,
            AlgorithmProvider()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              ),
          );
          const num expectedAverage = 0;

          // Act (Execution)
          final num average = statisticsCalculations.averageIncomes;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 1 (only incomes)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(
            exampleData1,
            AlgorithmProvider()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              ),
          );
          const num expectedAverage = 20.25;

          // Act (Execution)
          final num average = statisticsCalculations.averageIncomes;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 2 (only expenses)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(
            exampleData2,
            AlgorithmProvider()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              ),
          );
          const num expectedAverage = 0;

          // Act (Execution)
          final num average = statisticsCalculations.averageIncomes;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 3", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(
            exampleData3,
            AlgorithmProvider()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              ),
          );
          const num expectedAverage = 12.375;

          // Act (Execution)
          final num average = statisticsCalculations.averageIncomes;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 4 (adds up to 0)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(
            exampleData4,
            AlgorithmProvider()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              ),
          );
          const num expectedAverage = 12.375;

          // Act (Execution)
          final num average = statisticsCalculations.averageIncomes;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 5 (only 0 expenses)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(
            exampleData5,
            AlgorithmProvider()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              ),
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
            final StatisticsCalculations statisticsCalculations =
                StatisticsCalculations(
              randomData,
              AlgorithmProvider()
                ..setCurrentFilterAlgorithm(
                  Filters.noFilter,
                ),
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
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(
            emptyData,
            AlgorithmProvider()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              ),
          );
          const num expectedSum = 0;

          // Act (Execution)
          final num sum = statisticsCalculations.sumCosts;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 1 (only incomes)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(
            exampleData1,
            AlgorithmProvider()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              ),
          );
          const num expectedSum = 0;

          // Act (Execution)
          final num sum = statisticsCalculations.sumCosts;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 2 (only expenses)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(
            exampleData2,
            AlgorithmProvider()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              ),
          );
          const num expectedSum = -5.5;

          // Act (Execution)
          final num sum = statisticsCalculations.sumCosts;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 3", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(
            exampleData3,
            AlgorithmProvider()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              ),
          );
          const num expectedSum = -5.5;

          // Act (Execution)
          final num sum = statisticsCalculations.sumCosts;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 4 (adds up to 0)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(
            exampleData4,
            AlgorithmProvider()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              ),
          );
          const num expectedSum = -49.5;

          // Act (Execution)
          final num sum = statisticsCalculations.sumCosts;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 5 (only 0 expenses)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(
            exampleData5,
            AlgorithmProvider()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              ),
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
            final StatisticsCalculations statisticsCalculations =
                StatisticsCalculations(
              randomData,
              AlgorithmProvider()
                ..setCurrentFilterAlgorithm(
                  Filters.noFilter,
                ),
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
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(
            emptyData,
            AlgorithmProvider()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              ),
          );
          const num expectedAverage = 0;

          // Act (Execution)
          final num average = statisticsCalculations.averageCosts;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 1 (only incomes)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(
            exampleData1,
            AlgorithmProvider()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              ),
          );
          const num expectedAverage = 0;

          // Act (Execution)
          final num average = statisticsCalculations.averageCosts;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 2 (only expenses)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(
            exampleData2,
            AlgorithmProvider()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              ),
          );
          const num expectedAverage = -1.375;

          // Act (Execution)
          final num average = statisticsCalculations.averageCosts;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 3", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(
            exampleData3,
            AlgorithmProvider()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              ),
          );
          const num expectedAverage = -1.375;

          // Act (Execution)
          final num average = statisticsCalculations.averageCosts;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 4 (adds up to 0)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(
            exampleData4,
            AlgorithmProvider()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              ),
          );
          const num expectedAverage = -8.25;

          // Act (Execution)
          final num average = statisticsCalculations.averageCosts;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 5 (only 0 expenses)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(
            exampleData5,
            AlgorithmProvider()
              ..setCurrentFilterAlgorithm(
                Filters.noFilter,
              ),
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
            final StatisticsCalculations statisticsCalculations =
                StatisticsCalculations(
              randomData,
              AlgorithmProvider()
                ..setCurrentFilterAlgorithm(
                  Filters.noFilter,
                ),
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
      baseSingleBalanceData.copyWith(
        amount:
            ((((0.5 - rand.nextDouble()) * 2 * 256) * 100).roundToDouble()) /
                100.0,
        id: const Uuid().v4(),
      ),
    ); // create a random Number from -256 to 256
  }
  return returnList;
}
