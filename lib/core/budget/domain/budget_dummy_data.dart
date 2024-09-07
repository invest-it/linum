import 'package:jiffy/jiffy.dart';
import 'package:linum/core/budget/domain/models/budget.dart';
import 'package:linum/core/budget/domain/models/budget_cap.dart';

final budgetDummyData = [
  Budget(
    name: "Traveling",
    cap: BudgetCap(
      value: 2000,
      type: CapType.amount,
    ),
    categories: [
      "Category 1",
      "Category 2",
    ],
    start: Jiffy.now().subtract(months: 2).dateTime,
  ),
  Budget(
    name: "Lifestyle",
    cap: BudgetCap(
      value: .5,
      type: CapType.percentage,
    ),
    categories: [
      "Category 1",
      "Category 2",
    ],
    start: Jiffy.now().subtract(months: 2).dateTime,
  ),
];
