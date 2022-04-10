import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linum/providers/algorithm_provider.dart';

class StatisticsCalculations {
  /// the data that should be processed
  late List<Map<String, dynamic>> _allData;

  /// the data that should be processed for monthly calculations
  List<Map<String, dynamic>> get _currentData =>
      List<Map<String, dynamic>>.from(_allData)
        ..removeWhere(_algorithmProvider.currentFilter);

  List<Map<String, dynamic>> get _allTimeData =>
      List<Map<String, dynamic>>.from(_allData)
        ..removeWhere(
          AlgorithmProvider.olderThan(
            Timestamp.fromDate(
              DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 1,
              ).subtract(
                const Duration(microseconds: 1),
              ),
            ),
          ),
        );

  late AlgorithmProvider _algorithmProvider;

  /// create a new instance and set the data
  StatisticsCalculations(
    List<dynamic> data,
    AlgorithmProvider algorithmProvider,
  ) {
    _allData = [];
    for (int i = 0; i < data.length; i++) {
      _allData.add(Map<String, dynamic>.from(data[i] as Map<String, dynamic>));
    }
    _algorithmProvider = algorithmProvider;
  }

  /// filter the data further down to only include the data with income information (excluding 0 cost products)
  List<Map<String, dynamic>> get _currentIncomeData =>
      List<Map<String, dynamic>>.from(_currentData)
        ..removeWhere(AlgorithmProvider.amountAtMost(0));

  List<Map<String, dynamic>> get _allTimeIncomeData =>
      List<Map<String, dynamic>>.from(_allData)
        ..removeWhere(AlgorithmProvider.amountAtMost(0));

  /// filter the data further down to only include the data with cost information (including 0 cost products)
  List<Map<String, dynamic>> get _currentCostData =>
      List<Map<String, dynamic>>.from(_currentData)
        ..removeWhere(AlgorithmProvider.amountMoreThan(0));

  List<Map<String, dynamic>> get _allTimeCostData =>
      List<Map<String, dynamic>>.from(_allData)
        ..removeWhere(AlgorithmProvider.amountMoreThan(0));

  /// sum up the total data if data is empty = 0
  num get sumBalance {
    return _getSumFrom(_currentData);
  }

  num get allTimeSumBalance {
    return _getSumFrom(_allTimeData);
  }

  /// average of the sum. if data is empty = 0
  num get averageBalance =>
      _currentData.isNotEmpty ? sumBalance / _currentData.length : 0;

  num get allTimeAverageBalance =>
      _allTimeData.isNotEmpty ? allTimeSumBalance / _allTimeData.length : 0;

  /// sum up the cost data
  num get sumCosts {
    return _getSumFrom(_currentCostData);
  }

  num get allTimeSumCosts {
    return _getSumFrom(_allTimeData);
  }

  /// average of the sum. if data is empty = 0
  num get averageCosts =>
      _currentCostData.isNotEmpty ? sumCosts / _currentCostData.length : 0;

  num get allTimeAverageCosts => _allTimeCostData.isNotEmpty
      ? allTimeSumCosts / _allTimeCostData.length
      : 0;

  /// sum up the income data. if data is empty = 0
  num get sumIncomes {
    return _getSumFrom(_currentIncomeData);
  }

  num get allTimeSumIncomes {
    return _getSumFrom(_allTimeIncomeData);
  }

  /// average of the income data. if data is empty = 0
  num get averageIncomes => _currentIncomeData.isNotEmpty
      ? sumIncomes / _currentIncomeData.length
      : 0;

  num get allTimeAverageIncomes => _allTimeIncomeData.isNotEmpty
      ? allTimeSumIncomes / _allTimeIncomeData.length
      : 0;

  num _getSumFrom(List<Map<String, dynamic>> data) {
    num sum = 0;
    for (final value in data) {
      sum += value["amount"] as num;
    }
    return sum;
  }
}
