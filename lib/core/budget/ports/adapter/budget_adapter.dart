import 'package:linum/core/budget/domain/models/budget.dart';
import 'package:linum/core/budget/domain/models/changes.dart';
import 'package:linum/core/budget/domain/models/main_budget.dart';

abstract class IBudgetAdapter {
  Future<List<Budget>> getBudgetsForDate(DateTime date);
  Future<void> executeBudgetChanges(List<ModelChange<Budget>> changes);

  Future<MainBudget?> getMainBudgetForDate(DateTime date);
  Future<void> executeMainBudgetChanges(List<ModelChange<MainBudget>> changes);
}
