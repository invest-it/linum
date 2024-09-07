import 'package:flutter/cupertino.dart';
import 'package:linum/core/budget/domain/models/budget.dart';
import 'package:linum/core/budget/domain/models/budget_cap.dart';
import 'package:linum/core/budget/presentation/budget_service.dart';
import 'package:linum/screens/budget_screen/budget_routes.dart';
import 'package:linum/screens/budget_screen/pages/budget_view_screen/widgets/sub_budget_tile.dart';

class BudgetScreenViewModel extends ChangeNotifier {
  // final StatisticalCalculations calculations;
  final IBudgetService _service;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  BudgetScreenViewModel({required IBudgetService service}) : _service = service;


  Future<T?> goTo<T>(String route, {bool replace = false}) async {
    if (replace) {
      return navigatorKey.currentState?.pushReplacementNamed(route);
    }
    return navigatorKey.currentState?.pushNamed(route);
  }

  String getInitialRoute() {
    return BudgetRoutes.view;
  }

  Future<List<BudgetViewData>> getBudgetViewData(DateTime date) async {
    final budgets = await _service.getBudgetsForDate(date);
    return _mapBudgetToViewData(budgets);
  }


  double _calculateBudgetCap(BudgetCap cap, double income) {
    if (cap.type == CapType.amount) {
      return cap.value;
    }
    return income * cap.value;
  }

  List<BudgetViewData> _mapBudgetToViewData(List<Budget> budgets) {
    const income = 700.00; // TODO: Must be calculated

    return budgets.map((budget) {
      return BudgetViewData(
        name: budget.name,
        expenses: 300, // TODO: Must be calculated
        cap: _calculateBudgetCap(budget.cap, income),
        categories: budget.categories,
      );
    }).toList();
  }
}
