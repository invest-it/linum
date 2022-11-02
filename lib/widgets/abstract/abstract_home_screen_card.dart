//  Home Screen Card (Abstract) - Comes with built-in functions to retrieve statistical data
//
//  Author: SoTBurst
//  Co-Author: n/a
//

import 'package:flutter/material.dart';
import 'package:linum/utilities/backend/statistical_calculations.dart';

abstract class AbstractHomeScreenCard {
  /// [statData] will calculate all needed Data. It also already has the filter implemented
  /// It is possible that statData is null. In that case place some kind of loading screen or
  /// everywhere a 0
  void addStatisticData(StatisticalCalculations? statData);

  /// return the widget to display the data
  Widget get returnWidget;
}
