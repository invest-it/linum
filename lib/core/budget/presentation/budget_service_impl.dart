import 'package:linum/core/budget/domain/models/budget.dart';
import 'package:linum/core/budget/domain/models/main_budget.dart';
import 'package:linum/core/budget/domain/repositories/budget_repository.dart';
import 'package:linum/core/budget/enums/budget_change_mode.dart';
import 'package:linum/core/budget/presentation/budget_service.dart';

class BudgetServiceImpl implements IBudgetService {
  final IBudgetRepository _repository;
  BudgetServiceImpl({required IBudgetRepository repository}): _repository = repository;

  @override
  Future<Budget> createBudget(Budget budget) {
    // TODO: implement createBudget
    throw UnimplementedError();
  }

  @override
  Future<void> deleteBudget(Budget budget, DateTime selectedDate, BudgetChangeMode changeMode) {
    // TODO: implement deleteBudget
    throw UnimplementedError();
  }

  @override
  Future<List<Budget>> getBudgetsForDate(DateTime date) {
    // TODO: implement getBudgetsForDate
    throw UnimplementedError();
  }

  @override
  Future<MainBudget> getMainBudgetForDate(DateTime date) {
    // TODO: implement getMainBudgetForDate
    throw UnimplementedError();
  }

  @override
  Future<void> updateBudget(Budget old, Budget update, DateTime selectedDate, BudgetChangeMode changeMode) {
    // TODO: implement updateBudget
    throw UnimplementedError();
  }

}