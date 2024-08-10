import 'package:linum/core/budget/domain/models/budget.dart';

// TODO: might be deprecated already
class BudgetSection {
  final String name;
  final List<Budget> budgets = [];

  BudgetSection({required this.name});
}


