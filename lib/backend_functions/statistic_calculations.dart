import 'package:linum/providers/algorithm_provider.dart';

class StatisticsCalculations {
  late List<Map<String, dynamic>> _data;
  StatisticsCalculations(List<Map<String, dynamic>> data) {
    _data = data;
  }

  List<Map<String, dynamic>> get _costData =>
      _data..removeWhere(AlgorithmProvider.amountAtMost(0));

  List<Map<String, dynamic>> get _incomeData =>
      _data..removeWhere(AlgorithmProvider.amountAtMost(0));

  num get sumBalance {
    num sum = 0;
    _data.forEach((value) {
      sum += value["amount"];
    });
    return sum;
  }

  num get averageBalance => _data.length == 0 ? sumBalance / _data.length : 0;

  num get sumCosts {
    num sum = 0;
    _costData.forEach((value) {
      sum += value["amount"];
    });
    return sum;
  }

  num get averageCosts =>
      _costData.length == 0 ? sumCosts / _costData.length : 0;

  num get sumIncomes {
    num sum = 0;
    _incomeData.forEach((value) {
      sum += value["amount"];
    });
    return sum;
  }

  num get averageIncomes =>
      _incomeData.length == 0 ? sumIncomes / _incomeData.length : 0;
}
