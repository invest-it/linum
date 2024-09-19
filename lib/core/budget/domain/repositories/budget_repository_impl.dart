import 'dart:collection';

import 'package:linum/core/budget/domain/adapter/budget_adapter.dart';
import 'package:linum/core/budget/domain/models/budget.dart';
import 'package:linum/core/budget/domain/models/changes.dart';
import 'package:linum/core/budget/domain/models/main_budget.dart';
import 'package:linum/core/budget/domain/repositories/budget_repository.dart';


class BudgetRepository implements IBudgetRepository {
  final IBudgetAdapter adapter;

  BudgetRepository({required this.adapter});

  @override
  Future<Budget> createBudget(Budget budget) async {
    await adapter.executeBudgetChanges([ModelChange<Budget>(ChangeType.create, budget)]);
    return Future.value(budget);
  }

  @override
  Future<MainBudget> createMainBudget(MainBudget budget) async {
    await adapter.executeMainBudgetChanges([ModelChange<MainBudget>(ChangeType.create, budget)]);
    return Future.value(budget);
  }

  @override
  Future<void> executeBudgetChanges(List<ModelChange<Budget>> changes) async {
    await adapter.executeBudgetChanges(changes);
  }

  @override
  Future<void> executeMainBudgetChanges(List<ModelChange<MainBudget>> changes) async {
    await adapter.executeMainBudgetChanges(changes);
  }

  @override
  Future<List<Budget>> getBudgetsForDate(DateTime date) async {
    return await adapter.getBudgetsForDate(date);
  }

  @override
  Future<MainBudget?> getMainBudgetForDate(DateTime date) async {
    return await adapter.getMainBudgetForDate(date);
  }

  @override
  Future<void> removeBudget(Budget budget) async {
    await adapter.executeBudgetChanges([ModelChange<Budget>(ChangeType.delete, budget)]);
  }

  @override
  Future<void> removeMainBudget(MainBudget budget) async {
    await adapter.executeMainBudgetChanges([ModelChange<MainBudget>(ChangeType.delete, budget)]);
  }

  @override
  UnmodifiableListView<Budget> testingGetBudgetForSeriesId(String serialId) {
    // TODO: implement testingGetBudgetForSeriesId
    throw UnimplementedError();
  }

  @override
  Future<void> updateBudget(Budget budget) async {
    await adapter.executeBudgetChanges([ModelChange<Budget>(ChangeType.update, budget)]);
  }

  @override
  Future<void> updateMainBudget(MainBudget budget) async {
    await adapter.executeMainBudgetChanges([ModelChange<MainBudget>(ChangeType.update, budget)]);
  }
}
