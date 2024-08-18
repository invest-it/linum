import 'package:flutter_test/flutter_test.dart';
import 'package:jiffy/jiffy.dart';
import 'package:linum/core/budget/domain/models/budget.dart';
import 'package:linum/core/budget/domain/models/budget_cap.dart';
import 'package:linum/core/budget/domain/models/time_span.dart';
import 'package:uuid/uuid.dart';

void main() {
  test("sort a list of budgets correctly", () {
    final template = Budget(
      name: const Uuid().v4(),
      cap: BudgetCap(
        value: 0.5,
        type: CapType.percentage,
      ),
      categories: [""],
      start: Jiffy.now().subtract(months: 7).dateTime,
    );

    // TODO: Decide if start should be relevant as well
    final List<Budget> budgets = [
      template.copySpanWith(
        end: Jiffy.now().subtract(months: 5).dateTime,
      ),
      template.copySpanWith(
        end: Jiffy.now().subtract(months: 3).dateTime,
      ),
      template.copySpanWith(
        end: Jiffy.now().subtract(months: 2).dateTime,
      ),
      template,
    ];

    final List<Budget> shuffled = [];
    shuffled.addAll(budgets);
    shuffled.shuffle();

    shuffled.sort(timeSpanComparer);
    expect(shuffled, budgets);
  });
}
