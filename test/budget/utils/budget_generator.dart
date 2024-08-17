import 'dart:math';

import 'package:jiffy/jiffy.dart';
import 'package:linum/core/budget/domain/models/budget.dart';
import 'package:linum/core/budget/domain/models/budget_cap.dart';
import 'package:uuid/uuid.dart';

class BudgetDummyGenerator {
  final seriesCount = Random().nextInt(10);
  final perSeriesCount = Random().nextInt(10);
  final List<String> availableCategories = ["food", "drink", "rent", "sports", "entertainment"];

  Budget generateBudget({bool openEnded = false}) {
    final start = Jiffy.now().subtract(months: Random().nextInt(100));
    return Budget(
      name: const Uuid().v4(),
      cap: randomCap(),
      categories: availableCategories..shuffle()..getRange(0, Random().nextInt(availableCategories.length)),
      start: start.dateTime,
      end: openEnded ? start.add(months: Random().nextInt(100)).dateTime : null,
    );
  }

  BudgetCap randomCap() {
    final r = Random().nextInt(20);
    if (r < 15) {
      return BudgetCap(
        value: Random().nextInt(4000).toDouble(), // TODO: Adjust to use the total budget as cap
        type: CapType.amount,
      );
    }

    return BudgetCap(
      value: Random().nextDouble(),
      type: CapType.percentage,
    );

  }
}
