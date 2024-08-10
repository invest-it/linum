import 'package:collection/collection.dart';
import 'package:linum/core/budget/domain/models/budget.dart';
import 'package:linum/core/budget/domain/models/main_budget.dart';
import 'package:linum/core/budget/domain/models/time_span.dart';
import 'package:linum/core/budget/domain/repositories/budget_repository.dart';



class BudgetRepositoryDummy implements IBudgetRepository {
  final Map<String, List<Budget>> budgets = {};
  final List<MainBudget> mainBudgets = [];

  @override
  Budget createBudget(Budget budget) {
    budgets.putIfAbsent(budget.seriesId, () => []);
    final list = budgets[budget.seriesId]!;

    if (list.isNotEmpty && list.last.end == null && budget.end == null) {
      // TODO: Use Lukas' exceptions
      // TODO: Decide to handle this error in this layer or above in the use case
      throw Exception("There can only be one open ended budget");
    }

    if (list.any((b) => b.id == budget.id)) {
      throw Exception("There is already an instance with the exact same id");
    }
    list.add(budget);
    list.sort(timeSpanComparer);
    return budget;
  }

  @override
  MainBudget createMainBudget(MainBudget budget) {
    if (mainBudgets.isNotEmpty && mainBudgets.last.end == null && budget.end == null) {
      throw Exception("There can only be one open ended main budget");
    }

    mainBudgets.add(budget);
    mainBudgets.sort(timeSpanComparer);
    return budget;
  }

  @override
  void removeBudget(Budget budget) {
    final list = budgets[budget.seriesId];
    if (list == null) {
      return;
    }

    list.removeWhere((b) => b.id == budget.id);
    if (list.isEmpty) {
      budgets.remove(budget.seriesId);
    }
  }

  @override
  void removeMainBudget(MainBudget budget) {
    mainBudgets.removeWhere((b) => b.id == budget.id);
  }

  @override
  void updateBudget(Budget budget) {
    final index = budgets[budget.seriesId]?.indexWhere((b) => b.id == budget.id);
    if (index == null || index == -1) {
      throw Exception("budget not in list");
    }
    budgets[budget.seriesId]![index] = budget;
  }

  @override
  void updateMainBudget(MainBudget budget) {
    final index = mainBudgets.indexWhere((b) => b.id == budget.id);
    if (index == -1) {
      throw Exception("main budget not in list");
    }
    mainBudgets[index] = budget;
  }

}