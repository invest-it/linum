import 'package:linum/core/budget/domain/adapter/budget_adapter.dart';




class BudgetRepository /*implements IBudgetRepository*/ {
  final IBudgetAdapter adapter;

  BudgetRepository({required this.adapter});
}
