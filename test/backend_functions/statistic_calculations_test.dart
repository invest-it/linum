// ignore_for_file: avoid_dynamic_calls

import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:linum/backend_functions/statistic_calculations.dart';

void main() {
  group("basic_statistic_calculation", () {
    final List<dynamic> exampleData1 = [
      {"amount": 15},
      {"amount": 35.5},
      {"amount": 5},
      {"amount": 25.5},
    ];
    final List<dynamic> exampleData2 = [
      {"amount": -0.5},
      {"amount": -2.5},
      {"amount": -2.5},
      {"amount": -0},
    ];
    final List<dynamic> exampleData3 = [
      {"amount": -0.5},
      {"amount": -2.5},
      {"amount": -2.5},
      {"amount": -0},
      {"amount": 15},
      {"amount": 5},
      {"amount": 25.5},
      {"amount": 4},
    ];
    final List<dynamic> exampleData4 = [
      {"amount": -0.5},
      {"amount": -2.5},
      {"amount": -2.5},
      {"amount": -0},
      {"amount": 15},
      {"amount": 5},
      {"amount": 25.5},
      {"amount": 4},
      {"amount": -20.5},
      {"amount": -23.5},
    ];
    final List<dynamic> exampleData5 = [
      {"amount": -0},
      {"amount": -0},
      {"amount": -0},
      {"amount": -0},
    ];
    final List<dynamic> randomData = _createRandomStatisticData();

    group("balance", () {
      group("sum", () {
        test("empty data", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations([]);
          const num expectedSum = 0;

          // Act (Execution)
          final num sum = statisticsCalculations.sumBalance;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 1 (only incomes)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData1);
          const num expectedSum = 81;

          // Act (Execution)
          final num sum = statisticsCalculations.sumBalance;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 2 (only expenses)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData2);
          const num expectedSum = -5.5;

          // Act (Execution)
          final num sum = statisticsCalculations.sumBalance;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 3", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData3);
          const num expectedSum = 44;

          // Act (Execution)
          final num sum = statisticsCalculations.sumBalance;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 4 (adds up to 0)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData4);
          const num expectedSum = 0;

          // Act (Execution)
          final num sum = statisticsCalculations.sumBalance;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 5 (only 0 expenses)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData5);
          const num expectedSum = 0;

          // Act (Execution)
          final num sum = statisticsCalculations.sumBalance;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("random data", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(randomData);
          num expectedSum = 0;
          for (int i = 0; i < randomData.length; i++) {
            expectedSum += randomData[i]["amount"] as num;
          }

          // Act (Execution)
          final num sum = statisticsCalculations.sumBalance;

          // Assert (Observation)
          expect(sum, expectedSum);
        });
      });

      group("average", () {
        test("empty data", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations([]);
          const num expectedAverage = 0;

          // Act (Execution)
          final num average = statisticsCalculations.averageBalance;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 1 (only incomes)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData1);
          const num expectedAverage = 20.25;

          // Act (Execution)
          final num average = statisticsCalculations.averageBalance;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 2 (only expenses)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData2);
          const num expectedAverage = -1.375;

          // Act (Execution)
          final num average = statisticsCalculations.averageBalance;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 3", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData3);
          const num expectedAverage = 5.5;

          // Act (Execution)
          final num average = statisticsCalculations.averageBalance;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 4 (adds up to 0)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData4);
          const num expectedAverage = 0;

          // Act (Execution)
          final num average = statisticsCalculations.averageBalance;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 5 (only 0 expenses)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData5);
          const num expectedAverage = 0;

          // Act (Execution)
          final num average = statisticsCalculations.averageBalance;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("random data", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(randomData);
          num expectedAverage = 0;
          for (int i = 0; i < randomData.length; i++) {
            expectedAverage += randomData[i]["amount"] as num;
          }
          expectedAverage /= randomData.length;

          // Act (Execution)
          final num average = statisticsCalculations.averageBalance;

          // Assert (Observation)
          expect(average, expectedAverage);
        });
      });
    });

    group("income", () {
      group("sum", () {
        test("empty data", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations([]);
          const num expectedSum = 0;

          // Act (Execution)
          final num sum = statisticsCalculations.sumIncomes;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 1 (only incomes)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData1);
          const num expectedSum = 81;

          // Act (Execution)
          final num sum = statisticsCalculations.sumIncomes;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 2 (only expenses)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData2);
          const num expectedSum = 0;

          // Act (Execution)
          final num sum = statisticsCalculations.sumIncomes;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 3", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData3);
          const num expectedSum = 49.5;

          // Act (Execution)
          final num sum = statisticsCalculations.sumIncomes;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 4 (adds up to 0)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData4);
          const num expectedSum = 49.5;

          // Act (Execution)
          final num sum = statisticsCalculations.sumIncomes;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 5 (only 0 expenses)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData5);
          const num expectedSum = 0;

          // Act (Execution)
          final num sum = statisticsCalculations.sumIncomes;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("random data", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(randomData);
          num expectedSum = 0;
          for (int i = 0; i < randomData.length; i++) {
            if (randomData[i]["amount"] as num > 0) {
              expectedSum += randomData[i]["amount"] as num;
            }
          }

          // Act (Execution)
          final num sum = statisticsCalculations.sumIncomes;

          // Assert (Observation)
          expect(sum, expectedSum);
        });
      });
      group("average", () {
        test("empty data", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations([]);
          const num expectedAverage = 0;

          // Act (Execution)
          final num average = statisticsCalculations.averageIncomes;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 1 (only incomes)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData1);
          const num expectedAverage = 20.25;

          // Act (Execution)
          final num average = statisticsCalculations.averageIncomes;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 2 (only expenses)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData2);
          const num expectedAverage = 0;

          // Act (Execution)
          final num average = statisticsCalculations.averageIncomes;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 3", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData3);
          const num expectedAverage = 12.375;

          // Act (Execution)
          final num average = statisticsCalculations.averageIncomes;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 4 (adds up to 0)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData4);
          const num expectedAverage = 12.375;

          // Act (Execution)
          final num average = statisticsCalculations.averageIncomes;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 5 (only 0 expenses)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData5);
          const num expectedAverage = 0;

          // Act (Execution)
          final num average = statisticsCalculations.averageIncomes;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("random data", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(randomData);
          num expectedAverage = 0;
          int incomes = 0;
          for (int i = 0; i < randomData.length; i++) {
            if (randomData[i]["amount"] as num > 0) {
              expectedAverage += randomData[i]["amount"] as num;

              incomes++;
            }
          }
          expectedAverage /= incomes;
          // Act (Execution)
          final num average = statisticsCalculations.averageIncomes;

          // Assert (Observation)
          expect(average, expectedAverage);
        });
      });
    });

    group("costs", () {
      group("sum", () {
        test("empty data", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations([]);
          const num expectedSum = 0;

          // Act (Execution)
          final num sum = statisticsCalculations.sumCosts;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 1 (only incomes)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData1);
          const num expectedSum = 0;

          // Act (Execution)
          final num sum = statisticsCalculations.sumCosts;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 2 (only expenses)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData2);
          const num expectedSum = -5.5;

          // Act (Execution)
          final num sum = statisticsCalculations.sumCosts;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 3", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData3);
          const num expectedSum = -5.5;

          // Act (Execution)
          final num sum = statisticsCalculations.sumCosts;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 4 (adds up to 0)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData4);
          const num expectedSum = -49.5;

          // Act (Execution)
          final num sum = statisticsCalculations.sumCosts;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 5 (only 0 expenses)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData5);
          const num expectedSum = 0;

          // Act (Execution)
          final num sum = statisticsCalculations.sumCosts;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("random data", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(randomData);
          num expectedSum = 0;
          for (int i = 0; i < randomData.length; i++) {
            if (randomData[i]["amount"] as num <= 0) {
              expectedSum += randomData[i]["amount"] as num;
            }
          }

          // Act (Execution)
          final num sum = statisticsCalculations.sumCosts;

          // Assert (Observation)
          expect(sum, expectedSum);
        });
      });

      group("average", () {
        test("empty data", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations([]);
          const num expectedAverage = 0;

          // Act (Execution)
          final num average = statisticsCalculations.averageCosts;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 1 (only incomes)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData1);
          const num expectedAverage = 0;

          // Act (Execution)
          final num average = statisticsCalculations.averageCosts;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 2 (only expenses)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData2);
          const num expectedAverage = -1.375;

          // Act (Execution)
          final num average = statisticsCalculations.averageCosts;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 3", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData3);
          const num expectedAverage = -1.375;

          // Act (Execution)
          final num average = statisticsCalculations.averageCosts;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 4 (adds up to 0)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData4);
          const num expectedAverage = -8.25;

          // Act (Execution)
          final num average = statisticsCalculations.averageCosts;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 5 (only 0 expenses)", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData5);
          const num expectedAverage = 0;

          // Act (Execution)
          final num average = statisticsCalculations.averageCosts;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("random data", () {
          // Arrange (Initialization)
          final StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(randomData);
          num expectedAverage = 0;
          int costs = 0;
          for (int i = 0; i < randomData.length; i++) {
            if (randomData[i]["amount"] as num <= 0) {
              expectedAverage += randomData[i]["amount"] as num;

              costs++;
            }
          }
          expectedAverage /= costs;
          // Act (Execution)
          final num average = statisticsCalculations.averageCosts;

          // Assert (Observation)
          expect(average, expectedAverage);
        });
      });
    });
  });
}

List<dynamic> _createRandomStatisticData() {
  final List<dynamic> returnList = [];
  final math.Random rand = math.Random();
  final int max = rand.nextInt(256);
  for (int i = 0; i < max; i++) {
    returnList.add({
      "amount":
          ((((0.5 - rand.nextDouble()) * 2 * 256) * 100).roundToDouble()) /
              100.0
    }); // create a random Number from -256 to 256
  }
  return returnList;
}