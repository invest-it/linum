import 'dart:collection';
import 'package:linum/core/budget/domain/models/budget.dart';
import 'package:linum/core/budget/domain/models/changes.dart';
import 'package:linum/core/budget/domain/models/main_budget.dart';
import 'package:linum/core/budget/domain/models/time_span.dart';
import 'package:linum/core/budget/domain/repositories/budget_repository.dart';



class BudgetRepositoryDummy implements IBudgetRepository {
  final Map<String, List<Budget>> _budgets = {};
  final List<MainBudget> _mainBudgets = [];

  BudgetRepositoryDummy({List<Budget>? initialBudgets}) {
    initialBudgets?.forEach((budget) {
      createBudget(budget);
    });
  }

  @override
  Future<Budget> createBudget(Budget budget) async {
    _budgets.putIfAbsent(budget.seriesId, () => []);
    final list = _budgets[budget.seriesId]!;

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
    if (_mainBudgets.isNotEmpty && _mainBudgets.last.end == null && budget.end == null) {
      throw Exception("There can only be one open ended main budget");
    }

    _mainBudgets.add(budget);
    _mainBudgets.sort(timeSpanComparer);
    return budget;
  }

  @override
  Future<void> removeBudget(Budget budget) async {
    final list = _budgets[budget.seriesId];
    if (list == null) {
      return;
    }

    list.removeWhere((b) => b.id == budget.id);
    if (list.isEmpty) {
      _budgets.remove(budget.seriesId);
    }
  }

  @override
  Future<void> removeMainBudget(MainBudget budget) async {
    _mainBudgets.removeWhere((b) => b.id == budget.id);
  }

  @override
  Future<void> updateBudget(Budget budget) async {
    final index = _budgets[budget.seriesId]?.indexWhere((b) => b.id == budget.id);
    if (index == null || index == -1) {
      throw Exception("budget not in list");
    }
    _budgets[budget.seriesId]![index] = budget;
  }

  @override
  Future<void> updateMainBudget(MainBudget budget) async {
    final index = _mainBudgets.indexWhere((b) => b.id == budget.id);
    if (index == -1) {
      throw Exception("main budget not in list");
    }
    _mainBudgets[index] = budget;
  }

  @override
  UnmodifiableListView<Budget> testingGetBudgetForSeriesId(String seriesId) {
    return UnmodifiableListView(_budgets[seriesId] ?? <Budget>[]);
  }

  @override
  Future<void> executeBudgetChanges(List<ModelChange<Budget>> changes) async {
    for (final change in changes) {
      switch (change.type) {
        case ChangeType.create:
          await createBudget(change.model);
        case ChangeType.update:
          await updateBudget(change.model);
        case ChangeType.delete:
          await removeBudget(change.model);
      }
    }
  }

  @override
  Future<void> executeMainBudgetChanges(List<ModelChange<MainBudget>> changes) async {
    for (final change in changes) {
      switch (change.type) {
        case ChangeType.create:
          await createMainBudget(change.model);
        case ChangeType.update:
          await updateMainBudget(change.model);
        case ChangeType.delete:
          await removeMainBudget(change.model);
      }
    }
  }

  @override
  Future<List<Budget>> getBudgetsForDate(DateTime date) async {
    final filtered = <Budget>[];
    _budgets.forEach((key, value) {
      for (final b in value) {
        if (b.containsDate(date)) {
          filtered.add(b);
        }
      }
    });
    return filtered;
  }

  @override
  Future<MainBudget?> getMainBudgetForDate(DateTime date) async {
    for (final b in _mainBudgets) {
      if (b.containsDate(date)) {
        return b;
      }
    }
    return null;
  }
}
