//  Statistic Calculations - Retrieves sorted and/or filtered data from FirebaseFirestore
//
//  Author: SoTBurst
//  Co-Author: n/a
//

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:linum/models/serial_transaction.dart';
import 'package:linum/models/single_month_statistic.dart';
import 'package:linum/models/transaction.dart';
import 'package:linum/providers/algorithm_provider.dart';
import 'package:linum/utilities/backend/exchange_rate_converter.dart';
import 'package:linum/utilities/frontend/filters.dart';
import 'package:logger/logger.dart';
import 'package:tuple/tuple.dart';

class StatisticalCalculations {
  /// the data that should be processed
  late List<Transaction> _allData;

  /// the data that should be processed
  late List<SerialTransaction> _allSerialData;

  final String standardCurrencyName;

  /// the data that should be processed for monthly calculations
  List<Transaction> get _currentData =>
      getDataUsingFilter(_algorithmProvider.currentFilter);

  List<Transaction> get _currentTillNowData => getDataUsingFilter(
        Filters.newerThan(firestore.Timestamp.now()),
        baseData: _currentData,
      );

  List<Transaction> get _allTimeData =>
      getDataUsingFilter(Filters.newerThan(firestore.Timestamp.now()));

  late AlgorithmProvider _algorithmProvider;

  late Logger log;

  /// create a new instance and set the data
  StatisticalCalculations({
    required List<Transaction> data,
    required List<SerialTransaction> serialData,
    required this.standardCurrencyName,
    required AlgorithmProvider algorithmProvider,
  }) {
    _allData = [];

    for (int i = 0; i < data.length; i++) {
      _allData
          .add(data[i].copyWith()); // copy data so there is no change in data
    }

    _allSerialData = [];
    for (int i = 0; i < serialData.length; i++) {
      _allSerialData.add(
        serialData[i].copyWith(),
      ); // copy data so there is no change in data
    }

    _algorithmProvider = algorithmProvider;

    log = Logger();
  }

  /// filter the data further down to only include the data with income information (excluding 0 cost products)
  List<Transaction> get _currentIncomeData => getDataUsingFilter(
        Filters.amountAtMost(0),
        baseData: _currentData,
      );

  List<Transaction> get _currentTillNowIncomeData => getDataUsingFilter(
        Filters.amountAtMost(0),
        baseData: _currentTillNowData,
      );

  List<Transaction> get _allTimeIncomeData => getDataUsingFilter(
        Filters.amountAtMost(0),
        baseData: _allTimeData,
      );

  /// filter the data further down to only include the data with cost information (including 0 cost products)
  List<Transaction> get _currentCostData => getDataUsingFilter(
        Filters.amountMoreThan(0),
        baseData: _currentData,
      );

  List<Transaction> get _currentTillNowCostData => getDataUsingFilter(
        Filters.amountMoreThan(0),
        baseData: _currentTillNowData,
      );

  List<Transaction> get _allTimeCostData => getDataUsingFilter(
        Filters.amountMoreThan(0),
        baseData: _allTimeData,
      );

  // All means all inside the filter. AllTime means ALL ALL
  List<Transaction> get _allSerialGeneratedData => getDataUsingFilter(
        (t) {
          if (t is Transaction) {
            return t.repeatId == null;
          }
          log.wtf(
            "Somehow in a list of Transaction an item wasn't a Transaction",
          );
          return true;
        },
      );

  List<Transaction> get _allSerialGeneratedIncomeData => getDataUsingFilter(
        Filters.amountAtMost(0),
        baseData: _allSerialGeneratedData,
      );

  List<Transaction> get _allSerialGeneratedCostData => getDataUsingFilter(
        Filters.amountMoreThan(0),
        baseData: _allSerialGeneratedData,
      );

  List<Transaction> get _futureSerialGeneratedIncomeData => getDataUsingFilter(
        Filters.amountAtMost(0),
        baseData: _futureSerialGeneratedData,
      );

  List<Transaction> get _futureSerialGeneratedCostData => getDataUsingFilter(
        Filters.amountMoreThan(0),
        baseData: _futureSerialGeneratedData,
      );

  List<Transaction> get _futureSerialGeneratedData => getDataUsingFilter(
        Filters.olderThan(firestore.Timestamp.now()),
        baseData: _allSerialGeneratedData,
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
        Filters.inBetween(
          Tuple2(
            firestore.Timestamp.fromDate(startDate),
            firestore.Timestamp.fromDate(endDate),
          ),
        )
      ];

      final List<Transaction> allThisMonthData =
          getDataUsingFilter(Filters.combineFilterStrict(filterList));

      final List<Transaction> costsThisMonthData = getDataUsingFilter(
        Filters.amountMoreThan(0),
        baseData: allThisMonthData,
      );
      final List<Transaction> incomesThisMonthData = getDataUsingFilter(
        Filters.amountAtMost(0),
        baseData: allThisMonthData,
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

  num get tillNowSumBalance {
    return _getSumFrom(_currentTillNowData);
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

  num get tillNowSumCosts {
    return _getSumFrom(_currentTillNowCostData);
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

  num get tillNowSumIncomes {
    return _getSumFrom(_currentTillNowIncomeData);
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

  num _getSumFrom(List<Transaction> data) {
    num sum = 0;
    for (final transaction in data) {
      if (transaction.currency == standardCurrencyName) {
        sum += transaction.amount;
      } else if (transaction.rateInfo != null) {
        // Normally this is always true
        sum += convertCurrencyAmountWithExchangeRate(
            transaction.amount, transaction.rateInfo!);
      }
    }
    return sum;
  }

  num _getAverageFrom(List<Transaction> data) {
    return data.isNotEmpty ? _getSumFrom(data) / data.length : 0;
  }

  num get serialTransactionCount => _allSerialData.length;

  num get sumFutureSerialCosts {
    return _getSumFrom(_futureSerialGeneratedCostData);
  }

  num get sumFutureSerialIncomes {
    return _getSumFrom(_futureSerialGeneratedIncomeData);
  }

  num get sumSerialIncomes {
    return _getSumFrom(_allSerialGeneratedIncomeData);
  }

  num get sumSerialCosts {
    return _getSumFrom(_allSerialGeneratedCostData);
  }

  int get countSerialIncomes {
    return _allSerialGeneratedIncomeData.length;
  }

  int get countSerialCosts {
    return _allSerialGeneratedCostData.length;
  }

  /// baseData is the data used as base. return will always be a subset of baseData
  /// baseData == null => baseData = _allData
  List<Transaction> getDataUsingFilter(
    bool Function(dynamic) filter, {
    List<Transaction>? baseData,
  }) {
    if (baseData != null) {
      return List<Transaction>.from(baseData)..removeWhere(filter);
    }
    return List<Transaction>.from(_allData)..removeWhere(filter);
  }

  List<String> _getSubcategoriesFrom(
    List<Transaction> data,
  ) {
    final Set<String> result = {};

    for (final transaction in data) {
      result.add(transaction.category);
    }

    return result.toList();
  }
}
