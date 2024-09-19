import 'package:flutter/cupertino.dart';
import 'package:linum/core/budget/domain/models/budget.dart';
import 'package:linum/core/budget/domain/models/main_budget.dart';
import 'package:linum/core/budget/domain/repositories/budget_repository.dart';
import 'package:linum/core/budget/domain/use_cases/delete_budget_use_case.dart';
import 'package:linum/core/budget/domain/use_cases/delete_main_budget_use_case.dart';
import 'package:linum/core/budget/domain/use_cases/update_budget_use_case.dart';
import 'package:linum/core/budget/domain/use_cases/update_main_budget_use_case.dart';
import 'package:linum/core/budget/enums/budget_change_mode.dart';
import 'package:linum/core/budget/presentation/budget_service.dart';

class BudgetServiceImpl with ChangeNotifier implements IBudgetService {
  final IBudgetRepository _repository;
  final UpdateBudgetUseCaseImpl _updateBudgetUseCase;
  final UpdateMainBudgetUseCaseImpl _updateMainBudgetUseCase;
  final DeleteBudgetUseCase _deleteBudgetUseCase;
  final DeleteMainBudgetUseCase _deleteMainBudgetUseCase;

  BudgetServiceImpl({required IBudgetRepository repository}):
    _repository = repository,
    _updateBudgetUseCase = UpdateBudgetUseCaseImpl(repository: repository),
    _updateMainBudgetUseCase = UpdateMainBudgetUseCaseImpl(repository: repository),
    _deleteBudgetUseCase = DeleteBudgetUseCaseImpl(repository: repository),
    _deleteMainBudgetUseCase = DeleteMainBudgetUseCaseImpl(repository: repository)
  ;

  @override
  Future<Budget> createBudget(Budget budget) {
    return _repository.createBudget(budget);
  }

  @override
  Future<void> deleteBudget(Budget budget, DateTime selectedDate, BudgetChangeMode changeMode) {
    return _deleteBudgetUseCase.execute(budget, selectedDate, changeMode);
  }

  @override
  Future<List<Budget>> getBudgetsForDate(DateTime date) async {
    return _repository.getBudgetsForDate(date);
  }

  @override
  Future<void> updateBudget(Budget old, Budget update, DateTime selectedDate, BudgetChangeMode changeMode) {
    return _updateBudgetUseCase.execute(old, update, selectedDate, changeMode);
  }

  @override
  Future<MainBudget?> getMainBudgetForDate(DateTime date) async {
    return _repository.getMainBudgetForDate(date);
  }

  @override
  Future<MainBudget> createMainBudget(MainBudget budget) {
    return _repository.createMainBudget(budget);
  }

  @override
  Future<void> deleteMainBudget(MainBudget budget, DateTime selectedDate, BudgetChangeMode changeMode) {
    return _deleteMainBudgetUseCase.execute(budget, selectedDate, changeMode);
  }

  @override
  Future<void> updateMainBudget(MainBudget old, MainBudget update, DateTime selectedDate, BudgetChangeMode changeMode) {
    return _updateMainBudgetUseCase.execute(old, update, selectedDate, changeMode);
  }
}
