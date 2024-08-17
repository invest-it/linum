import 'package:flutter/cupertino.dart';
import 'package:linum/core/balance/utils/statistical_calculations.dart';
import 'package:linum/core/budget/presentation/budget_service.dart';

class BudgetScreenViewModel extends ChangeNotifier {
  // final StatisticalCalculations calculations;
  final IBudgetService _service;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  BudgetScreenViewModel({required IBudgetService service}) : _service = service;
}
