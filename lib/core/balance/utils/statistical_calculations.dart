//  Statistic Calculations - Retrieves sorted and/or filtered data from FirebaseFirestore
//
//  Author: SoTBurst
//  Co-Author: n/a
//

import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:linum/common/utils/filters.dart';
import 'package:linum/core/balance/models/algorithm_state.dart';
import 'package:linum/core/balance/models/serial_transaction.dart';
import 'package:linum/core/balance/models/single_month_statistic.dart';
import 'package:linum/core/balance/models/transaction.dart';
import 'package:linum/features/currencies/core/data/exchange_rate_converter.dart';
import 'package:logger/logger.dart';
import 'package:tuple/tuple.dart';

class StatisticalCalculations {
  /// the data that should be processed
  late List<Transaction> _allData;

  /// the data that should be processed
  late List<SerialTransaction> _currentSerialData;

  final String standardCurrencyName;

  /// the data that should be processed for monthly calculations
  List<Transaction> get _currentData =>
      getDataUsingFilter(_algorithms.filter);

  List<Transaction> get _currentTillNowData => getDataUsingFilter(
        Filters.newerThan(Timestamp.now()),
        baseData: _currentData,
      );

  List<Transaction> get _allTimeData =>
      getDataUsingFilter(Filters.newerThan(Timestamp.now()));

  late AlgorithmState _algorithms;

  late Logger log;

  /// create a new instance and set the data
  StatisticalCalculations({
    required List<Transaction> data,
    required List<SerialTransaction> serialData,
    required this.standardCurrencyName,
    required AlgorithmState algorithms,
  }) {
    _allData = [];

    for (int i = 0; i < data.length; i++) {
      _allData
          .add(data[i].copyWith()); // copy data so there is no change in data
    }

    _currentSerialData = [];
    for (int i = 0; i < serialData.length; i++) {
      _currentSerialData.add(
        serialData[i].copyWith(),
      ); // copy data so there is no change in data
    }

    _algorithms = algorithms;

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

  // current means all inside the filter. AllTime means ALL
  List<Transaction> get _currentSerialGeneratedData => getDataUsingFilter(
        (t) {
          if (t is Transaction) {
            return t.repeatId == null;
          }
          log.f(
            "Somehow in a list of Transaction an item wasn't a Transaction",
          );
          return true;
        },
        baseData: _currentData,
      );

  List<Transaction> get _currentSerialGeneratedIncomeData => getDataUsingFilter(
        Filters.amountAtMost(0),
        baseData: _currentSerialGeneratedData,
      );

  List<Transaction> get _currentSerialGeneratedCostData => getDataUsingFilter(
        Filters.amountMoreThan(0),
        baseData: _currentSerialGeneratedData,
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
        Filters.olderThan(Timestamp.now()),
        baseData: _currentSerialGeneratedData,
      );

  List<Transaction> get _tillBeginningOfMonthData => getDataUsingFilter(
        Filters.newerThan(
           Timestamp.fromDate(_algorithms.shownMonth),
        ),
        baseData: _allData,
      );
  List<Transaction> get _tillEndOfMonthData => getDataUsingFilter(
        Filters.newerThan(
           Timestamp.fromDate(
            DateTime(
              _algorithms.shownMonth.year,
              _algorithms.shownMonth.month + 1,
              -1,
            ),
          ),
        ),
        baseData: _allData,
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
             Timestamp.fromDate(startDate),
             Timestamp.fromDate(endDate),
          ),
        ),
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
          transaction.amount,
          transaction.rateInfo!,
        );
      }
    }
    return sum;
  }

  num _getAverageFrom(List<Transaction> data) {
    return data.isNotEmpty ? _getSumFrom(data) / data.length : 0;
  }

  num get serialTransactionCount => _currentSerialData.length;

  num get sumFutureSerialCosts {
    return _getSumFrom(_futureSerialGeneratedCostData);
  }

  num get sumFutureSerialIncomes {
    return _getSumFrom(_futureSerialGeneratedIncomeData);
  }

  num get sumSerialIncomes {
    return _getSumFrom(_currentSerialGeneratedIncomeData);
  }

  num get sumSerialCosts {
    return _getSumFrom(_currentSerialGeneratedCostData);
  }

  num get tillBeginningOfMonthSumBalance {
    return _getSumFrom(_tillBeginningOfMonthData);
  }

  num get tillEndOfMonthSumBalance {
    return _getSumFrom(_tillEndOfMonthData);
  }

  int get countSerialIncomes {
    return _currentSerialGeneratedIncomeData.length;
  }

  int get countSerialCosts {
    return _currentSerialGeneratedCostData.length;
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
      // TODO: Do not hardcode these strings
      if (transaction.category == "none-expense" || transaction.category == "none-income") {
        continue;
      }
      result.add(transaction.category);
    }

    return result.toList();
  }
}
