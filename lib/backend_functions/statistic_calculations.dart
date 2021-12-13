class StatisticsCalculations {
  late List<Map<String, dynamic>> _data;
  StatisticsCalculations(List<Map<String, dynamic>> data) {
    _data = data;
  }

  num get sum {
    num sum = 0;
    _data.forEach((value) {
      sum += value["amount"];
    });
    return sum;
  }

  num get averageCost => _data.length == 0 ? sum / _data.length : 0;
}
