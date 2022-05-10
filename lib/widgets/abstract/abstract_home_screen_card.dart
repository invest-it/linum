import 'package:flutter/material.dart';
import 'package:linum/utilities/backend/statistic_calculations.dart';

abstract class AbstractHomeScreenCard {
  /// [statData] will calculate all needed Data. It also already has the filter implemented
  /// It is possible that statData is null. In that case place some kind of loading screen or
  /// everywhere a 0
  void addStatisticData(StatisticsCalculations? statData);

  /// return the widget to display the data
  Widget get returnWidget;
}
