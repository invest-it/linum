import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linum/backend_functions/statistic_calculations.dart';
import 'package:linum/providers/algorithm_provider.dart';

void main() {
  group("basic_statistic_calculation", () {
    final List<Map<String, dynamic>> exampleData1 = [
      {"amount": 15, "time": Timestamp.fromDate(DateTime(2022, 4, 5))},
      {"amount": 35.5, "time": Timestamp.fromDate(DateTime(2022, 4))},
      {"amount": 5, "time": Timestamp.fromDate(DateTime(2022, 4, 20))},
      {"amount": 25.5, "time": Timestamp.fromDate(DateTime(2022, 2, 5))},
    ];
    final List<Map<String, dynamic>> exampleData2 = [
      {"amount": -0.5, "time": Timestamp.fromDate(DateTime(2022, 6, 20))},
      {"amount": -2.5, "time": Timestamp.fromDate(DateTime(2022, 7, 20))},
      {"amount": -2.5, "time": Timestamp.fromDate(DateTime(2022, 6, 12))},
      {"amount": -0, "time": Timestamp.fromDate(DateTime(2022, 6, 20))},
    ];
    final List<Map<String, dynamic>> exampleData3 = [
      {"amount": -0.5, "time": Timestamp.fromDate(DateTime(2022, 6, 14))},
      {"amount": -2.5, "time": Timestamp.fromDate(DateTime(2022, 6, 8))},
      {"amount": -2.5, "time": Timestamp.fromDate(DateTime(2022, 6, 4))},
      {"amount": -0, "time": Timestamp.fromDate(DateTime(2022, 6, 20))},
      {"amount": 15, "time": Timestamp.fromDate(DateTime(2022, 6, 20))},
      {"amount": 5, "time": Timestamp.fromDate(DateTime(2022, 6, 28))},
      {"amount": 25.5, "time": Timestamp.fromDate(DateTime(2022, 6, 10))},
      {"amount": 4, "time": Timestamp.fromDate(DateTime(2022, 6, 21))},
    ];
    final List<Map<String, dynamic>> exampleData4 = [
      {"amount": -0.5, "time": Timestamp.fromDate(DateTime(2022, 4, 5))},
      {"amount": -2.5, "time": Timestamp.fromDate(DateTime(2022, 3, 15))},
      {"amount": -2.5, "time": Timestamp.fromDate(DateTime(2022, 4, 2))},
      {"amount": -0, "time": Timestamp.fromDate(DateTime(2022, 4, 15))},
      {"amount": 15, "time": Timestamp.fromDate(DateTime(2022, 4, 13))},
      {"amount": 5, "time": Timestamp.fromDate(DateTime(2022, 4, 17))},
      {"amount": 25.5, "time": Timestamp.fromDate(DateTime(2022, 4, 25))},
      {"amount": 4, "time": Timestamp.fromDate(DateTime(2022, 4, 27))},
      {"amount": -20.5, "time": Timestamp.fromDate(DateTime(2022, 4, 29))},
      {"amount": -23.5, "time": Timestamp.fromDate(DateTime(2022, 4, 3))},
    ];
    final List<Map<String, dynamic>> exampleData5 = [
      {"amount": -0, "time": Timestamp.fromDate(DateTime(2022, 3))},
      {"amount": -0, "time": Timestamp.fromDate(DateTime(2022, 3))},
      {"amount": -0, "time": Timestamp.fromDate(DateTime(2022, 3))},
      {"amount": -0, "time": Timestamp.fromDate(DateTime(2022, 3))},
    ];

    group("all time", () {
      group("balance", () {
        group("sum", () {
          test("empty data", () {
            // Arrange (Initialization)
            final StatisticsCalculations statisticsCalculations =
                StatisticsCalculations(
              [],
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
                ),
            );
            const num expectedSum = 0;

            // Act (Execution)
            final num sum = statisticsCalculations.allTimeSumBalance;

            // Assert (Observation)
            expect(sum, expectedSum);
          });

          test("example data 1 (only incomes)", () {
            // Arrange (Initialization)
            final StatisticsCalculations statisticsCalculations =
                StatisticsCalculations(
              exampleData1,
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
                ),
            );
            const num expectedSum = 81;

            // Act (Execution)
            final num sum = statisticsCalculations.allTimeSumBalance;

            // Assert (Observation)
            expect(sum, expectedSum);
          });

          test("example data 2 (only expenses)", () {
            // Arrange (Initialization)
            final StatisticsCalculations statisticsCalculations =
                StatisticsCalculations(
              exampleData2,
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
                ),
            );
            const num expectedSum = -5.5;

            // Act (Execution)
            final num sum = statisticsCalculations.allTimeSumBalance;

            // Assert (Observation)
            expect(sum, expectedSum);
          });

          test("example data 3", () {
            // Arrange (Initialization)
            final StatisticsCalculations statisticsCalculations =
                StatisticsCalculations(
              exampleData3,
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
                ),
            );
            const num expectedSum = 44;

            // Act (Execution)
            final num sum = statisticsCalculations.allTimeSumBalance;

            // Assert (Observation)
            expect(sum, expectedSum);
          });

          test("example data 4 (adds up to 0)", () {
            // Arrange (Initialization)
            final StatisticsCalculations statisticsCalculations =
                StatisticsCalculations(
              exampleData4,
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
                ),
            );
            const num expectedSum = 0;

            // Act (Execution)
            final num sum = statisticsCalculations.allTimeSumBalance;

            // Assert (Observation)
            expect(sum, expectedSum);
          });

          test("example data 5 (only 0 expenses)", () {
            // Arrange (Initialization)
            final StatisticsCalculations statisticsCalculations =
                StatisticsCalculations(
              exampleData5,
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
                ),
            );
            const num expectedSum = 0;

            // Act (Execution)
            final num sum = statisticsCalculations.allTimeSumBalance;

            // Assert (Observation)
            expect(sum, expectedSum);
          });

          test("random data", () {
            final math.Random rand = math.Random();
            for (int i = 0; i < 10000; i++) {
              // Arrange (Initialization)
              final List<Map<String, dynamic>> randomData =
                  _createRandomStatisticData(rand);
              final StatisticsCalculations statisticsCalculations =
                  StatisticsCalculations(
                randomData,
                AlgorithmProvider()
                  ..setCurrentFilterAlgorithmSilently(
                    AlgorithmProvider.noFilter,
                  ),
              );
              num expectedSum = 0;
              for (int i = 0; i < randomData.length; i++) {
                expectedSum += randomData[i]["amount"] as num;
              }

              // Act (Execution)
              final num sum = statisticsCalculations.allTimeSumBalance;

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
              [],
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
                ),
            );
            const num expectedAverage = 0;

            // Act (Execution)
            final num average = statisticsCalculations.allTimeAverageBalance;

            // Assert (Observation)
            expect(average, expectedAverage);
          });

          test("example data 1 (only incomes)", () {
            // Arrange (Initialization)
            final StatisticsCalculations statisticsCalculations =
                StatisticsCalculations(
              exampleData1,
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
                ),
            );
            const num expectedAverage = 20.25;

            // Act (Execution)
            final num average = statisticsCalculations.allTimeAverageBalance;

            // Assert (Observation)
            expect(average, expectedAverage);
          });

          test("example data 2 (only expenses)", () {
            // Arrange (Initialization)
            final StatisticsCalculations statisticsCalculations =
                StatisticsCalculations(
              exampleData2,
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
                ),
            );
            const num expectedAverage = -1.375;

            // Act (Execution)
            final num average = statisticsCalculations.allTimeAverageBalance;

            // Assert (Observation)
            expect(average, expectedAverage);
          });

          test("example data 3", () {
            // Arrange (Initialization)
            final StatisticsCalculations statisticsCalculations =
                StatisticsCalculations(
              exampleData3,
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
                ),
            );
            const num expectedAverage = 5.5;

            // Act (Execution)
            final num average = statisticsCalculations.allTimeAverageBalance;

            // Assert (Observation)
            expect(average, expectedAverage);
          });

          test("example data 4 (adds up to 0)", () {
            // Arrange (Initialization)
            final StatisticsCalculations statisticsCalculations =
                StatisticsCalculations(
              exampleData4,
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
                ),
            );
            const num expectedAverage = 0;

            // Act (Execution)
            final num average = statisticsCalculations.allTimeAverageBalance;

            // Assert (Observation)
            expect(average, expectedAverage);
          });

          test("example data 5 (only 0 expenses)", () {
            // Arrange (Initialization)
            final StatisticsCalculations statisticsCalculations =
                StatisticsCalculations(
              exampleData5,
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
                ),
            );
            const num expectedAverage = 0;

            // Act (Execution)
            final num average = statisticsCalculations.allTimeAverageBalance;

            // Assert (Observation)
            expect(average, expectedAverage);
          });

          test("random data", () {
            final math.Random rand = math.Random();
            for (int i = 0; i < 10000; i++) {
              // Arrange (Initialization)
              final List<Map<String, dynamic>> randomData =
                  _createRandomStatisticData(rand);
              final StatisticsCalculations statisticsCalculations =
                  StatisticsCalculations(
                randomData,
                AlgorithmProvider()
                  ..setCurrentFilterAlgorithmSilently(
                    AlgorithmProvider.noFilter,
                  ),
              );
              num expectedAverage = 0;
              for (int i = 0; i < randomData.length; i++) {
                expectedAverage += randomData[i]["amount"] as num;
              }
              expectedAverage /= randomData.length;

              // Act (Execution)
              final num average = statisticsCalculations.allTimeAverageBalance;

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
              [],
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
                ),
            );
            const num expectedSum = 0;

            // Act (Execution)
            final num sum = statisticsCalculations.allTimeSumIncomes;

            // Assert (Observation)
            expect(sum, expectedSum);
          });

          test("example data 1 (only incomes)", () {
            // Arrange (Initialization)
            final StatisticsCalculations statisticsCalculations =
                StatisticsCalculations(
              exampleData1,
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
                ),
            );
            const num expectedSum = 81;

            // Act (Execution)
            final num sum = statisticsCalculations.allTimeSumIncomes;

            // Assert (Observation)
            expect(sum, expectedSum);
          });

          test("example data 2 (only expenses)", () {
            // Arrange (Initialization)
            final StatisticsCalculations statisticsCalculations =
                StatisticsCalculations(
              exampleData2,
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
                ),
            );
            const num expectedSum = 0;

            // Act (Execution)
            final num sum = statisticsCalculations.allTimeSumIncomes;

            // Assert (Observation)
            expect(sum, expectedSum);
          });

          test("example data 3", () {
            // Arrange (Initialization)
            final StatisticsCalculations statisticsCalculations =
                StatisticsCalculations(
              exampleData3,
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
                ),
            );
            const num expectedSum = 49.5;

            // Act (Execution)
            final num sum = statisticsCalculations.allTimeSumIncomes;

            // Assert (Observation)
            expect(sum, expectedSum);
          });

          test("example data 4 (adds up to 0)", () {
            // Arrange (Initialization)
            final StatisticsCalculations statisticsCalculations =
                StatisticsCalculations(
              exampleData4,
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
                ),
            );
            const num expectedSum = 49.5;

            // Act (Execution)
            final num sum = statisticsCalculations.allTimeSumIncomes;

            // Assert (Observation)
            expect(sum, expectedSum);
          });

          test("example data 5 (only 0 expenses)", () {
            // Arrange (Initialization)
            final StatisticsCalculations statisticsCalculations =
                StatisticsCalculations(
              exampleData5,
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
                ),
            );
            const num expectedSum = 0;

            // Act (Execution)
            final num sum = statisticsCalculations.allTimeSumIncomes;

            // Assert (Observation)
            expect(sum, expectedSum);
          });

          test("random data", () {
            final math.Random rand = math.Random();
            for (int i = 0; i < 10000; i++) {
              // Arrange (Initialization)
              final List<Map<String, dynamic>> randomData =
                  _createRandomStatisticData(rand);
              final StatisticsCalculations statisticsCalculations =
                  StatisticsCalculations(
                randomData,
                AlgorithmProvider()
                  ..setCurrentFilterAlgorithmSilently(
                    AlgorithmProvider.noFilter,
                  ),
              );
              num expectedSum = 0;
              for (int i = 0; i < randomData.length; i++) {
                if (randomData[i]["amount"] as num > 0) {
                  expectedSum += randomData[i]["amount"] as num;
                }
              }

              // Act (Execution)
              final num sum = statisticsCalculations.allTimeSumIncomes;

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
              [],
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
                ),
            );
            const num expectedAverage = 0;

            // Act (Execution)
            final num average = statisticsCalculations.allTimeAverageIncomes;

            // Assert (Observation)
            expect(average, expectedAverage);
          });

          test("example data 1 (only incomes)", () {
            // Arrange (Initialization)
            final StatisticsCalculations statisticsCalculations =
                StatisticsCalculations(
              exampleData1,
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
                ),
            );
            const num expectedAverage = 20.25;

            // Act (Execution)
            final num average = statisticsCalculations.allTimeAverageIncomes;

            // Assert (Observation)
            expect(average, expectedAverage);
          });

          test("example data 2 (only expenses)", () {
            // Arrange (Initialization)
            final StatisticsCalculations statisticsCalculations =
                StatisticsCalculations(
              exampleData2,
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
                ),
            );
            const num expectedAverage = 0;

            // Act (Execution)
            final num average = statisticsCalculations.allTimeAverageIncomes;

            // Assert (Observation)
            expect(average, expectedAverage);
          });

          test("example data 3", () {
            // Arrange (Initialization)
            final StatisticsCalculations statisticsCalculations =
                StatisticsCalculations(
              exampleData3,
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
                ),
            );
            const num expectedAverage = 12.375;

            // Act (Execution)
            final num average = statisticsCalculations.allTimeAverageIncomes;

            // Assert (Observation)
            expect(average, expectedAverage);
          });

          test("example data 4 (adds up to 0)", () {
            // Arrange (Initialization)
            final StatisticsCalculations statisticsCalculations =
                StatisticsCalculations(
              exampleData4,
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
                ),
            );
            const num expectedAverage = 12.375;

            // Act (Execution)
            final num average = statisticsCalculations.allTimeAverageIncomes;

            // Assert (Observation)
            expect(average, expectedAverage);
          });

          test("example data 5 (only 0 expenses)", () {
            // Arrange (Initialization)
            final StatisticsCalculations statisticsCalculations =
                StatisticsCalculations(
              exampleData5,
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
                ),
            );
            const num expectedAverage = 0;

            // Act (Execution)
            final num average = statisticsCalculations.allTimeAverageIncomes;

            // Assert (Observation)
            expect(average, expectedAverage);
          });

          test("random data", () {
            final math.Random rand = math.Random();
            for (int i = 0; i < 10000; i++) {
              // Arrange (Initialization)
              final List<Map<String, dynamic>> randomData =
                  _createRandomStatisticData(rand);
              final StatisticsCalculations statisticsCalculations =
                  StatisticsCalculations(
                randomData,
                AlgorithmProvider()
                  ..setCurrentFilterAlgorithmSilently(
                    AlgorithmProvider.noFilter,
                  ),
              );
              num expectedAverage = 0;
              int incomes = 0;
              for (int i = 0; i < randomData.length; i++) {
                if (randomData[i]["amount"] as num > 0) {
                  expectedAverage += randomData[i]["amount"] as num;

                  incomes++;
                }
              }
              if (incomes > 0) {
                expectedAverage /= incomes;
              }
              // Act (Execution)
              final num average = statisticsCalculations.allTimeAverageIncomes;

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
              [],
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
                ),
            );
            const num expectedSum = 0;

            // Act (Execution)
            final num sum = statisticsCalculations.allTimeSumCosts;

            // Assert (Observation)
            expect(sum, expectedSum);
          });

          test("example data 1 (only incomes)", () {
            // Arrange (Initialization)
            final StatisticsCalculations statisticsCalculations =
                StatisticsCalculations(
              exampleData1,
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
                ),
            );
            const num expectedSum = 0;

            // Act (Execution)
            final num sum = statisticsCalculations.allTimeSumCosts;

            // Assert (Observation)
            expect(sum, expectedSum);
          });

          test("example data 2 (only expenses)", () {
            // Arrange (Initialization)
            final StatisticsCalculations statisticsCalculations =
                StatisticsCalculations(
              exampleData2,
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
                ),
            );
            const num expectedSum = -5.5;

            // Act (Execution)
            final num sum = statisticsCalculations.allTimeSumCosts;

            // Assert (Observation)
            expect(sum, expectedSum);
          });

          test("example data 3", () {
            // Arrange (Initialization)
            final StatisticsCalculations statisticsCalculations =
                StatisticsCalculations(
              exampleData3,
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
                ),
            );
            const num expectedSum = -5.5;

            // Act (Execution)
            final num sum = statisticsCalculations.allTimeSumCosts;

            // Assert (Observation)
            expect(sum, expectedSum);
          });

          test("example data 4 (adds up to 0)", () {
            // Arrange (Initialization)
            final StatisticsCalculations statisticsCalculations =
                StatisticsCalculations(
              exampleData4,
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
                ),
            );
            const num expectedSum = -49.5;

            // Act (Execution)
            final num sum = statisticsCalculations.allTimeSumCosts;

            // Assert (Observation)
            expect(sum, expectedSum);
          });

          test("example data 5 (only 0 expenses)", () {
            // Arrange (Initialization)
            final StatisticsCalculations statisticsCalculations =
                StatisticsCalculations(
              exampleData5,
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
                ),
            );
            const num expectedSum = 0;

            // Act (Execution)
            final num sum = statisticsCalculations.allTimeSumCosts;

            // Assert (Observation)
            expect(sum, expectedSum);
          });

          test("random data", () {
            final math.Random rand = math.Random();
            for (int i = 0; i < 10000; i++) {
              // Arrange (Initialization)
              final List<Map<String, dynamic>> randomData =
                  _createRandomStatisticData(rand);
              final StatisticsCalculations statisticsCalculations =
                  StatisticsCalculations(
                randomData,
                AlgorithmProvider()
                  ..setCurrentFilterAlgorithmSilently(
                    AlgorithmProvider.noFilter,
                  ),
              );
              num expectedSum = 0;
              for (int i = 0; i < randomData.length; i++) {
                if (randomData[i]["amount"] as num <= 0) {
                  expectedSum += randomData[i]["amount"] as num;
                }
              }

              // Act (Execution)
              final num sum = statisticsCalculations.allTimeSumCosts;

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
              [],
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
                ),
            );
            const num expectedAverage = 0;

            // Act (Execution)
            final num average = statisticsCalculations.allTimeAverageCosts;

            // Assert (Observation)
            expect(average, expectedAverage);
          });

          test("example data 1 (only incomes)", () {
            // Arrange (Initialization)
            final StatisticsCalculations statisticsCalculations =
                StatisticsCalculations(
              exampleData1,
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
                ),
            );
            const num expectedAverage = 0;

            // Act (Execution)
            final num average = statisticsCalculations.allTimeAverageCosts;

            // Assert (Observation)
            expect(average, expectedAverage);
          });

          test("example data 2 (only expenses)", () {
            // Arrange (Initialization)
            final StatisticsCalculations statisticsCalculations =
                StatisticsCalculations(
              exampleData2,
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
                ),
            );
            const num expectedAverage = -1.375;

            // Act (Execution)
            final num average = statisticsCalculations.allTimeAverageCosts;

            // Assert (Observation)
            expect(average, expectedAverage);
          });

          test("example data 3", () {
            // Arrange (Initialization)
            final StatisticsCalculations statisticsCalculations =
                StatisticsCalculations(
              exampleData3,
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
                ),
            );
            const num expectedAverage = -1.375;

            // Act (Execution)
            final num average = statisticsCalculations.allTimeAverageCosts;

            // Assert (Observation)
            expect(average, expectedAverage);
          });

          test("example data 4 (adds up to 0)", () {
            // Arrange (Initialization)
            final StatisticsCalculations statisticsCalculations =
                StatisticsCalculations(
              exampleData4,
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
                ),
            );
            const num expectedAverage = -8.25;

            // Act (Execution)
            final num average = statisticsCalculations.allTimeAverageCosts;

            // Assert (Observation)
            expect(average, expectedAverage);
          });

          test("example data 5 (only 0 expenses)", () {
            // Arrange (Initialization)
            final StatisticsCalculations statisticsCalculations =
                StatisticsCalculations(
              exampleData5,
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
                ),
            );
            const num expectedAverage = 0;

            // Act (Execution)
            final num average = statisticsCalculations.allTimeAverageCosts;

            // Assert (Observation)
            expect(average, expectedAverage);
          });

          test("random data", () {
            final math.Random rand = math.Random();
            for (int i = 0; i < 10000; i++) {
              // Arrange (Initialization)
              final List<Map<String, dynamic>> randomData =
                  _createRandomStatisticData(rand);
              final StatisticsCalculations statisticsCalculations =
                  StatisticsCalculations(
                randomData,
                AlgorithmProvider()
                  ..setCurrentFilterAlgorithmSilently(
                    AlgorithmProvider.noFilter,
                  ),
              );
              num expectedAverage = 0;
              int costs = 0;
              for (int i = 0; i < randomData.length; i++) {
                if (randomData[i]["amount"] as num <= 0) {
                  expectedAverage += randomData[i]["amount"] as num;

                  costs++;
                }
              }
              if (costs > 0) {
                expectedAverage /= costs;
              }
              // Act (Execution)
              final num average = statisticsCalculations.allTimeAverageCosts;

              // Assert (Observation)
              expect(average, expectedAverage);
            }
          });
        });
      });
    });

    group("current filter (specific month)", () {
      group("balance", () {
        group("sum", () {
          test("empty data", () {
            // Arrange (Initialization)
            final StatisticsCalculations statisticsCalculations =
                StatisticsCalculations(
              [],
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
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
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
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
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
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
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
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
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
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
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
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
              final List<Map<String, dynamic>> randomData =
                  _createRandomStatisticData(rand);
              final StatisticsCalculations statisticsCalculations =
                  StatisticsCalculations(
                randomData,
                AlgorithmProvider()
                  ..setCurrentFilterAlgorithmSilently(
                    AlgorithmProvider.noFilter,
                  ),
              );
              num expectedSum = 0;
              for (int i = 0; i < randomData.length; i++) {
                expectedSum += randomData[i]["amount"] as num;
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
              [],
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
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
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
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
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
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
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
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
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
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
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
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
              final List<Map<String, dynamic>> randomData =
                  _createRandomStatisticData(rand);
              final StatisticsCalculations statisticsCalculations =
                  StatisticsCalculations(
                randomData,
                AlgorithmProvider()
                  ..setCurrentFilterAlgorithmSilently(
                    AlgorithmProvider.noFilter,
                  ),
              );
              num expectedAverage = 0;
              for (int i = 0; i < randomData.length; i++) {
                expectedAverage += randomData[i]["amount"] as num;
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
              [],
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
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
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
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
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
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
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
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
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
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
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
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
              final List<Map<String, dynamic>> randomData =
                  _createRandomStatisticData(rand);
              final StatisticsCalculations statisticsCalculations =
                  StatisticsCalculations(
                randomData,
                AlgorithmProvider()
                  ..setCurrentFilterAlgorithmSilently(
                    AlgorithmProvider.noFilter,
                  ),
              );
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
            }
          });
        });
        group("average", () {
          test("empty data", () {
            // Arrange (Initialization)
            final StatisticsCalculations statisticsCalculations =
                StatisticsCalculations(
              [],
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
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
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
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
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
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
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
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
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
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
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
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
              final List<Map<String, dynamic>> randomData =
                  _createRandomStatisticData(rand);
              final StatisticsCalculations statisticsCalculations =
                  StatisticsCalculations(
                randomData,
                AlgorithmProvider()
                  ..setCurrentFilterAlgorithmSilently(
                    AlgorithmProvider.noFilter,
                  ),
              );
              num expectedAverage = 0;
              int incomes = 0;
              for (int i = 0; i < randomData.length; i++) {
                if (randomData[i]["amount"] as num > 0) {
                  expectedAverage += randomData[i]["amount"] as num;

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
              [],
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
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
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
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
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
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
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
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
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
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
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
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
              final List<Map<String, dynamic>> randomData =
                  _createRandomStatisticData(rand);
              final StatisticsCalculations statisticsCalculations =
                  StatisticsCalculations(
                randomData,
                AlgorithmProvider()
                  ..setCurrentFilterAlgorithmSilently(
                    AlgorithmProvider.noFilter,
                  ),
              );
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
            }
          });
        });

        group("average", () {
          test("empty data", () {
            // Arrange (Initialization)
            final StatisticsCalculations statisticsCalculations =
                StatisticsCalculations(
              [],
              AlgorithmProvider()
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
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
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
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
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
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
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
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
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
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
                ..setCurrentFilterAlgorithmSilently(
                  AlgorithmProvider.noFilter,
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
              final List<Map<String, dynamic>> randomData =
                  _createRandomStatisticData(rand);
              final StatisticsCalculations statisticsCalculations =
                  StatisticsCalculations(
                randomData,
                AlgorithmProvider()
                  ..setCurrentFilterAlgorithmSilently(
                    AlgorithmProvider.noFilter,
                  ),
              );
              num expectedAverage = 0;
              int costs = 0;
              for (int i = 0; i < randomData.length; i++) {
                if (randomData[i]["amount"] as num <= 0) {
                  expectedAverage += randomData[i]["amount"] as num;

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
  });
}

List<Map<String, dynamic>> _createRandomStatisticData(math.Random rand) {
  final List<Map<String, dynamic>> returnList = <Map<String, dynamic>>[];
  final int max = rand.nextInt(256) + 1;
  for (int i = 0; i < max; i++) {
    returnList.add({
      "amount":
          ((((0.5 - rand.nextDouble()) * 2 * 256) * 100).roundToDouble()) /
              100.0,
      "time": Timestamp.fromDate(
        DateTime.now().subtract(Duration(days: rand.nextInt(512) - 256)),
      ),
    }); // create a random Number from -256 to 256
  }
  return returnList;
}
