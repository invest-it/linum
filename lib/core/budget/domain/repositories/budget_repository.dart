import 'package:linum/core/budget/domain/adapter/budget_adapter.dart';

class BudgetRepository {
  final IBudgetAdapter adapter;

  BudgetRepository({required this.adapter});
}