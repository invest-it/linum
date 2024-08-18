import 'package:linum/core/budget/domain/models/main_budget.dart';
import 'package:linum/core/budget/domain/repositories/budget_repository.dart';
import 'package:linum/core/budget/domain/use_cases/delete_time_span_use_case.dart';
import 'package:linum/core/budget/enums/budget_change_mode.dart';

abstract class DeleteMainBudgetUseCase {
  Future<void> execute(MainBudget budget, DateTime selectedDate, BudgetChangeMode changeMode);
}

class DeleteMainBudgetUseCaseImpl implements DeleteMainBudgetUseCase {
  final IBudgetRepository _repository;
  final DeleteTimeSpanUseCase<MainBudget> _deleteTimeSpanUseCase;

  DeleteMainBudgetUseCaseImpl({
    required IBudgetRepository repository,
  }): _repository = repository, _deleteTimeSpanUseCase = DeleteTimeSpanUseCase();

  @override
  Future<void> execute(MainBudget budget, DateTime selectedDate, BudgetChangeMode changeMode) async {
    final changes = await _deleteTimeSpanUseCase.execute(budget, selectedDate, changeMode);
    return _repository.executeMainBudgetChanges(changes);
  }
}
