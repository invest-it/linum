import 'package:flutter_test/flutter_test.dart';
import 'package:linum/backend_functions/statistic_calculations.dart';

void main() {
  group("basic statistic calculation", () {
    List<dynamic> exampleData1 = [
      {"amount": 15},
      {"amount": 35.5},
      {"amount": 5},
      {"amount": 25.5},
    ];
    List<dynamic> exampleData2 = [
      {"amount": -0.5},
      {"amount": -2.5},
      {"amount": -2.5},
      {"amount": -0},
    ];
    List<dynamic> exampleData3 = [
      {"amount": -0.5},
      {"amount": -2.5},
      {"amount": -2.5},
      {"amount": -0},
      {"amount": 15},
      {"amount": 5},
      {"amount": 25.5},
      {"amount": 4},
    ];
    List<dynamic> exampleData4 = [
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
    List<dynamic> exampleData5 = [
      {"amount": -0},
      {"amount": -0},
      {"amount": -0},
      {"amount": -0},
    ];
    group("balance", () {
      group("sum", () {
        test("empty data", () {
          // Arrange (Initialization)
          StatisticsCalculations statisticsCalculations =
              StatisticsCalculations([]);
          num expectedSum = 0;

          // Act (Execution)
          num sum = statisticsCalculations.sumBalance;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 1 (only incomes)", () {
          // Arrange (Initialization)
          StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData1);
          num expectedSum = 81;

          // Act (Execution)
          num sum = statisticsCalculations.sumBalance;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 2 (only expenses)", () {
          // Arrange (Initialization)
          StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData2);
          num expectedSum = -5.5;

          // Act (Execution)
          num sum = statisticsCalculations.sumBalance;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 3", () {
          // Arrange (Initialization)
          StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData3);
          num expectedSum = 44;

          // Act (Execution)
          num sum = statisticsCalculations.sumBalance;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 4 (adds up to 0)", () {
          // Arrange (Initialization)
          StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData4);
          num expectedSum = 0;

          // Act (Execution)
          num sum = statisticsCalculations.sumBalance;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 5 (only 0 expenses)", () {
          // Arrange (Initialization)
          StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData5);
          num expectedSum = 0;

          // Act (Execution)
          num sum = statisticsCalculations.sumBalance;

          // Assert (Observation)
          expect(sum, expectedSum);
        });
      });

      group("average", () {
        test("empty data", () {
          // Arrange (Initialization)
          StatisticsCalculations statisticsCalculations =
              StatisticsCalculations([]);
          num expectedAverage = 0;

          // Act (Execution)
          num average = statisticsCalculations.averageBalance;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 1 (only incomes)", () {
          // Arrange (Initialization)
          StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData1);
          num expectedAverage = 20.25;

          // Act (Execution)
          num average = statisticsCalculations.averageBalance;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 2 (only expenses)", () {
          // Arrange (Initialization)
          StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData2);
          num expectedAverage = -1.375;

          // Act (Execution)
          num average = statisticsCalculations.averageBalance;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 3", () {
          // Arrange (Initialization)
          StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData3);
          num expectedAverage = 5.5;

          // Act (Execution)
          num average = statisticsCalculations.averageBalance;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 4 (adds up to 0)", () {
          // Arrange (Initialization)
          StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData4);
          num expectedAverage = 0;

          // Act (Execution)
          num average = statisticsCalculations.averageBalance;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 5 (only 0 expenses)", () {
          // Arrange (Initialization)
          StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData5);
          num expectedAverage = 0;

          // Act (Execution)
          num average = statisticsCalculations.averageBalance;

          // Assert (Observation)
          expect(average, expectedAverage);
        });
      });
    });
    group("income", () {
      group("sum", () {
        test("empty data", () {
          // Arrange (Initialization)
          StatisticsCalculations statisticsCalculations =
              StatisticsCalculations([]);
          num expectedSum = 0;

          // Act (Execution)
          num sum = statisticsCalculations.sumIncomes;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 1 (only incomes)", () {
          // Arrange (Initialization)
          StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData1);
          num expectedSum = 81;

          // Act (Execution)
          num sum = statisticsCalculations.sumIncomes;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 2 (only expenses)", () {
          // Arrange (Initialization)
          StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData2);
          num expectedSum = 0;

          // Act (Execution)
          num sum = statisticsCalculations.sumIncomes;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 3", () {
          // Arrange (Initialization)
          StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData3);
          num expectedSum = 49.5;

          // Act (Execution)
          num sum = statisticsCalculations.sumIncomes;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 4 (adds up to 0)", () {
          // Arrange (Initialization)
          StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData4);
          num expectedSum = 49.5;

          // Act (Execution)
          num sum = statisticsCalculations.sumIncomes;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 5 (only 0 expenses)", () {
          // Arrange (Initialization)
          StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData5);
          num expectedSum = 0;

          // Act (Execution)
          num sum = statisticsCalculations.sumIncomes;

          // Assert (Observation)
          expect(sum, expectedSum);
        });
      });
      group("average", () {
        test("empty data", () {
          // Arrange (Initialization)
          StatisticsCalculations statisticsCalculations =
              StatisticsCalculations([]);
          num expectedAverage = 0;

          // Act (Execution)
          num average = statisticsCalculations.averageIncomes;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 1 (only incomes)", () {
          // Arrange (Initialization)
          StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData1);
          num expectedAverage = 20.25;

          // Act (Execution)
          num average = statisticsCalculations.averageIncomes;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 2 (only expenses)", () {
          // Arrange (Initialization)
          StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData2);
          num expectedAverage = 0;

          // Act (Execution)
          num average = statisticsCalculations.averageIncomes;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 3", () {
          // Arrange (Initialization)
          StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData3);
          num expectedAverage = 12.375;

          // Act (Execution)
          num average = statisticsCalculations.averageIncomes;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 4 (adds up to 0)", () {
          // Arrange (Initialization)
          StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData4);
          num expectedAverage = 12.375;

          // Act (Execution)
          num average = statisticsCalculations.averageIncomes;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 5 (only 0 expenses)", () {
          // Arrange (Initialization)
          StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData5);
          num expectedAverage = 0;

          // Act (Execution)
          num average = statisticsCalculations.averageIncomes;

          // Assert (Observation)
          expect(average, expectedAverage);
        });
      });
    });

    group("costs", () {
      group("sum", () {
        test("empty data", () {
          // Arrange (Initialization)
          StatisticsCalculations statisticsCalculations =
              StatisticsCalculations([]);
          num expectedSum = 0;

          // Act (Execution)
          num sum = statisticsCalculations.sumCosts;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 1 (only incomes)", () {
          // Arrange (Initialization)
          StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData1);
          num expectedSum = 0;

          // Act (Execution)
          num sum = statisticsCalculations.sumCosts;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 2 (only expenses)", () {
          // Arrange (Initialization)
          StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData2);
          num expectedSum = -5.5;

          // Act (Execution)
          num sum = statisticsCalculations.sumCosts;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 3", () {
          // Arrange (Initialization)
          StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData3);
          num expectedSum = -5.5;

          // Act (Execution)
          num sum = statisticsCalculations.sumCosts;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 4 (adds up to 0)", () {
          // Arrange (Initialization)
          StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData4);
          num expectedSum = -49.5;

          // Act (Execution)
          num sum = statisticsCalculations.sumCosts;

          // Assert (Observation)
          expect(sum, expectedSum);
        });

        test("example data 5 (only 0 expenses)", () {
          // Arrange (Initialization)
          StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData5);
          num expectedSum = 0;

          // Act (Execution)
          num sum = statisticsCalculations.sumCosts;

          // Assert (Observation)
          expect(sum, expectedSum);
        });
      });

      group("average", () {
        test("empty data", () {
          // Arrange (Initialization)
          StatisticsCalculations statisticsCalculations =
              StatisticsCalculations([]);
          num expectedAverage = 0;

          // Act (Execution)
          num average = statisticsCalculations.averageCosts;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 1 (only incomes)", () {
          // Arrange (Initialization)
          StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData1);
          num expectedAverage = 0;

          // Act (Execution)
          num average = statisticsCalculations.averageCosts;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 2 (only expenses)", () {
          // Arrange (Initialization)
          StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData2);
          num expectedAverage = -1.375;

          // Act (Execution)
          num average = statisticsCalculations.averageCosts;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 3", () {
          // Arrange (Initialization)
          StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData3);
          num expectedAverage = -1.375;

          // Act (Execution)
          num average = statisticsCalculations.averageCosts;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 4 (adds up to 0)", () {
          // Arrange (Initialization)
          StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData4);
          num expectedAverage = -8.25;

          // Act (Execution)
          num average = statisticsCalculations.averageCosts;

          // Assert (Observation)
          expect(average, expectedAverage);
        });

        test("example data 5 (only 0 expenses)", () {
          // Arrange (Initialization)
          StatisticsCalculations statisticsCalculations =
              StatisticsCalculations(exampleData5);
          num expectedAverage = 0;

          // Act (Execution)
          num average = statisticsCalculations.averageCosts;

          // Assert (Observation)
          expect(average, expectedAverage);
        });
      });
    });
  });
}
