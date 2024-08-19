import 'package:flutter/cupertino.dart';
import 'package:linum/core/budget/presentation/budget_service.dart';
import 'package:linum/screens/budget_screen/budget_routes.dart';

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
    // TODO: Implement
    return BudgetRoutes.splash;
  }
}
