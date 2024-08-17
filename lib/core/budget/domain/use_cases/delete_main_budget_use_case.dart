import 'package:linum/core/budget/domain/models/main_budget.dart';
import 'package:linum/core/budget/domain/repositories/budget_repository.dart';
import 'package:linum/core/budget/domain/use_cases/delete_time_span_use_case.dart';
import 'package:linum/core/budget/enums/budget_change_mode.dart';

abstract class DeleteMainBudgetUseCase {
  Future<void> execute(MainBudget budget, DateTime selectedDate, BudgetChangeMode changeMode);
}

class DeleteMainBudgetUseCaseImpl implements DeleteMainBudgetUseCase {
  final IBudgetRepository repository;
  final DeleteTimeSpanUseCase<MainBudget> deleteTimeSpanUseCase;

  DeleteMainBudgetUseCaseImpl({
    required this.repository,
  }): deleteTimeSpanUseCase = DeleteTimeSpanUseCase(
    deleteSpan: repository.removeMainBudget, createSpan: repository.createMainBudget,
  );

  @override
  Future<void> execute(MainBudget budget, DateTime selectedDate, BudgetChangeMode changeMode) async {
    await deleteTimeSpanUseCase.execute(budget, selectedDate, changeMode);
  }
}
