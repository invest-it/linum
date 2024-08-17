import 'package:linum/core/budget/domain/models/budget.dart';
import 'package:linum/core/budget/domain/repositories/budget_repository.dart';
import 'package:linum/core/budget/domain/use_cases/delete_time_span_use_case.dart';
import 'package:linum/core/budget/enums/budget_change_mode.dart';

abstract class DeleteBudgetUseCase {
  Future<void> execute(Budget budget, DateTime? selectedDate, BudgetChangeMode changeMode);
}

class DeleteBudgetUseCaseImpl implements DeleteBudgetUseCase {
  final IBudgetRepository _repository;
  final DeleteTimeSpanUseCase<Budget> _deleteTimeSpanUseCase;

  DeleteBudgetUseCaseImpl({
    required IBudgetRepository repository,
  }): _repository = repository, _deleteTimeSpanUseCase = DeleteTimeSpanUseCase();

  @override
  Future<void> execute(Budget budget, DateTime? selectedDate, BudgetChangeMode changeMode) async {
      final changes = await _deleteTimeSpanUseCase.execute(budget, selectedDate, changeMode);
      return _repository.executeBudgetChanges(changes);
  }
}
