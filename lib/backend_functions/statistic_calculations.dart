import 'dart:developer';

import 'package:linum/providers/algorithm_provider.dart';

class StatisticsCalculations {
  /// the data that should be processed
  late List<Map<String, dynamic>> _data;

  /// create a new instance and set the data
  StatisticsCalculations(List<dynamic> data) {
    _data = [];
    for (int i = 0; i < data.length; i++) {
      _data.add(new Map<String, dynamic>.from(data[i]));
    }
  }

  /// filter the data further down to only include the data with cost information (including 0 cost products)
  List<Map<String, dynamic>> get _costData =>
      List<Map<String, dynamic>>.from(_data)
        ..removeWhere(AlgorithmProvider.amountAtLeast(0));

  /// filter the data further down to only include the data with income information (excluding 0 cost products)
  List<Map<String, dynamic>> get _incomeData =>
      List<Map<String, dynamic>>.from(_data)
        ..removeWhere(AlgorithmProvider.amountAtMost(0));

  /// sum up the total data if data is empty = 0
  num get sumBalance {
    num sum = 0;
    _data.forEach((value) {
      sum += value["amount"];
    });
    return sum;
  }

  /// average of the sum. if data is empty = 0
  num get averageBalance => _data.length == 0 ? sumBalance / _data.length : 0;

  /// sum up the cost data
  num get sumCosts {
    num sum = 0;
    _costData.forEach((value) {
      sum += value["amount"];
    });
    return sum;
  }

  /// average of the sum. if data is empty = 0
  num get averageCosts =>
      _costData.length == 0 ? sumCosts / _costData.length : 0;

  /// sum up the income data. if data is empty = 0
  num get sumIncomes {
    num sum = 0;
    _incomeData.forEach((value) {
      sum += value["amount"];
    });
    return sum;
  }

  /// average of the income data. if data is empty = 0
  num get averageIncomes =>
      _incomeData.length == 0 ? sumIncomes / _incomeData.length : 0;

  static Duration parseDuration(String s) {
    int hours = 0;
    int minutes = 0;
    int micros;
    List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
    return Duration(hours: hours, minutes: minutes, microseconds: micros);
  }
}
