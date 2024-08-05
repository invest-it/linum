import 'package:linum/core/budget/domain/adapter/budget_adapter.dart';
import 'package:linum/core/budget/domain/repositories/budget_repository.dart';




class BudgetRepository implements IBudgetRepository {
  final IBudgetAdapter adapter;

  BudgetRepository({required this.adapter});
}