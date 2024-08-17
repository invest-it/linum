import 'package:linum/core/budget/domain/models/budget.dart';
import 'package:linum/core/budget/domain/models/main_budget.dart';
import 'package:linum/core/budget/domain/models/time_span.dart';
import 'package:linum/core/budget/domain/repositories/budget_repository.dart';



class BudgetRepositoryDummy implements IBudgetRepository {
  final Map<String, List<Budget>> budgets = {};
  final List<MainBudget> mainBudgets = [];

  @override
  Future<Budget> createBudget(Budget budget) async {
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
  Future<MainBudget> createMainBudget(MainBudget budget) async {
    if (mainBudgets.isNotEmpty && mainBudgets.last.end == null && budget.end == null) {
      throw Exception("There can only be one open ended main budget");
    }

    mainBudgets.add(budget);
    mainBudgets.sort(timeSpanComparer);
    return budget;
  }

  @override
  Future<void> removeBudget(Budget budget) async {
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
  Future<void> removeMainBudget(MainBudget budget) async {
    mainBudgets.removeWhere((b) => b.id == budget.id);
  }

  @override
  Future<void> updateBudget(Budget budget) async {
    final index = budgets[budget.seriesId]?.indexWhere((b) => b.id == budget.id);
    if (index == null || index == -1) {
      throw Exception("budget not in list");
    }
    budgets[budget.seriesId]![index] = budget;
  }

  @override
  Future<void> updateMainBudget(MainBudget budget) async {
    final index = mainBudgets.indexWhere((b) => b.id == budget.id);
    if (index == -1) {
      throw Exception("main budget not in list");
    }
    mainBudgets[index] = budget;
  }

}