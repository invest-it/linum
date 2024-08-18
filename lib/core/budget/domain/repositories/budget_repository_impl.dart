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
    await adapter.createBudget(budget);
    return Future.value(budget);
  }

  @override
  Future<MainBudget> createMainBudget(MainBudget budget) async {
    await adapter.createMainBudget(budget);
    return Future.value(budget);
  }

  @override
  Future<void> executeBudgetChanges(List<ModelChange<Budget>> changes) async {
    for(final change in changes){
      switch(change.type){
        case ChangeType.create:
          await adapter.createBudget(change.model);
        case ChangeType.update:
          await adapter.updateBudget(change.model);
        case ChangeType.delete:
          await adapter.deleteBudget(change.model.id);
      }
    }
  }

  @override
  Future<void> executeMainBudgetChanges(List<ModelChange<MainBudget>> changes) async {
    for(final change in changes){
      switch(change.type){
        case ChangeType.create:
          await adapter.createMainBudget(change.model);
        case ChangeType.update:
          await adapter.updateMainBudget(change.model);
        case ChangeType.delete:
          await adapter.deleteMainBudget(change.model.id);
      }
    }
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
    return adapter.deleteBudget(budget.id);
  }

  @override
  Future<void> removeMainBudget(MainBudget budget) async {
    return adapter.deleteMainBudget(budget.id);
  }

  @override
  UnmodifiableListView<Budget> testingGetBudgetForSeriesId(String serialId) {
    // TODO: implement testingGetBudgetForSeriesId
    throw UnimplementedError();
  }

  @override
  Future<void> updateBudget(Budget budget) async {
    return adapter.updateBudget(budget);
  }

  @override
  Future<void> updateMainBudget(MainBudget budget) async {
    return adapter.updateMainBudget(budget);
  }
}
