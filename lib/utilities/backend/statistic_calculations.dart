//  Statistic Calculations - Retrieves sorted and/or filtered data from FirebaseFirestore
//
//  Author: SoTBurst
//  Co-Author: n/a
//

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linum/models/single_month_statistic.dart';
import 'package:linum/providers/algorithm_provider.dart';

class StatisticsCalculations {
  /// the data that should be processed
  late List<Map<String, dynamic>> _allData;

  /// the data that should be processed for monthly calculations
  List<Map<String, dynamic>> get _currentData =>
      getDataUsingFilter(_algorithmProvider.currentFilter);

  List<Map<String, dynamic>> get _allTimeData =>
      getDataUsingFilter(AlgorithmProvider.newerThan(Timestamp.now()));

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
      getDataUsingFilter(AlgorithmProvider.amountAtMost(0), data: _currentData);

  List<Map<String, dynamic>> get _allTimeIncomeData =>
      getDataUsingFilter(AlgorithmProvider.amountAtMost(0), data: _allTimeData);

  /// filter the data further down to only include the data with cost information (including 0 cost products)
  List<Map<String, dynamic>> get _currentCostData => getDataUsingFilter(
        AlgorithmProvider.amountMoreThan(0),
        data: _currentData,
      );

  List<Map<String, dynamic>> get _allTimeCostData => getDataUsingFilter(
        AlgorithmProvider.amountMoreThan(0),
        data: _allTimeData,
      );

  List<SingleMonthStatistic> getBundledDataPerMonth({
    bool Function(dynamic)? additionalFilter,
  }) {
    final List<SingleMonthStatistic> result = [];
    final DateTime now = DateTime.now();
    for (int i = 0; i < 12; i++) {
      final DateTime startDate = DateTime(now.year, now.month - i, now.day);
      final DateTime endDate = DateTime(now.year, now.month - i + 1, now.day);

      final List<bool Function(dynamic)> filterList = [
        AlgorithmProvider.inBetween(
          Timestamp.fromDate(startDate),
          Timestamp.fromDate(endDate),
        )
      ];

      final List<Map<String, dynamic>> allThisMonthData =
          getDataUsingFilter(AlgorithmProvider.combineFilterStrict(filterList));

      final List<Map<String, dynamic>> costsThisMonthData = getDataUsingFilter(
        AlgorithmProvider.amountMoreThan(0),
        data: allThisMonthData,
      );
      final List<Map<String, dynamic>> incomesThisMonthData =
          getDataUsingFilter(
        AlgorithmProvider.amountAtMost(0),
        data: allThisMonthData,
      );

      result.add(
        SingleMonthStatistic(
          sumBalance: _getSumFrom(allThisMonthData),
          averageBalance: _getAverageFrom(allThisMonthData),
          sumIncomes: _getSumFrom(incomesThisMonthData),
          averageIncomes: _getAverageFrom(incomesThisMonthData),
          sumCosts: _getSumFrom(costsThisMonthData),
          averageCosts: _getAverageFrom(costsThisMonthData),
          costsSubcategories: _getSubcategoriesFrom(costsThisMonthData),
          incomeSubcategories: _getSubcategoriesFrom(incomesThisMonthData),
        ),
      );
    }
    return result;
  }

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
    return _getSumFrom(_allTimeCostData);
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

  num _getAverageFrom(List<Map<String, dynamic>> data) {
    return data.isNotEmpty ? _getSumFrom(data) / data.length : 0;
  }

  List<Map<String, dynamic>> getDataUsingFilter(
    bool Function(dynamic) filter, {
    List<Map<String, dynamic>>? data,
  }) {
    if (data != null) {
      return List<Map<String, dynamic>>.from(data)..removeWhere(filter);
    }
    return List<Map<String, dynamic>>.from(_allData)..removeWhere(filter);
  }

  List<String> _getSubcategoriesFrom(
    List<Map<String, dynamic>> data,
  ) {
    final Set<String> result = {};

    for (final singleBalance in data) {
      if (singleBalance["category"] != null) {
        result.add(singleBalance["category"] as String);
      }
    }

    return result.toList();
  }
}
