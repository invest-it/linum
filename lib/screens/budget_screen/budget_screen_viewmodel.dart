import 'package:flutter/cupertino.dart';
import 'package:linum/core/balance/utils/statistical_calculations.dart';

class BudgetScreenViewModel extends ChangeNotifier {
  final StatisticalCalculations calculations;

  BudgetScreenViewModel(this.calculations);
}
