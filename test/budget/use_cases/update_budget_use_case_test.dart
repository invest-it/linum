import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:jiffy/jiffy.dart';
import 'package:linum/core/budget/domain/models/budget_cap.dart';
import 'package:linum/core/budget/domain/repositories/budget_repository_dummy.dart';
import 'package:linum/core/budget/domain/use_cases/update_budget_use_case.dart';
import 'package:linum/core/budget/enums/budget_change_mode.dart';

import '../utils/budget_generator.dart';

void main() {
  group("update_budget_use_case_test", () {
    group("test_update_budget: onlyOne", () {
      final repository = BudgetRepositoryDummy();
      final updateUseCase = UpdateBudgetUseCaseImpl(repository: repository);

      test("single_change", () {
        final budget = BudgetDummyGenerator().generateBudget(openEnded: true);
        repository.createBudget(
          budget,
        );

        final update = budget.copyWith(
          cap: BudgetCap(value: 500, type: CapType.amount),
        );

        final selectedDate = Jiffy.parseFromDateTime(budget.start).add(months: Random().nextInt(100)).dateTime;
        updateUseCase.execute(budget, update, selectedDate, BudgetChangeMode.onlyOne);

        final list = repository.testingGetBudgetForSeriesId(budget.seriesId);
        expect(list.length, 3);

        expect(list[1].start, selectedDate);
        expect(list.last.end, budget.end);
        expect(list[1].cap, update.cap);
      });
    });


    group("test_update_budget: all", () {
      final repository = BudgetRepositoryDummy();
      final updateUseCase = UpdateBudgetUseCaseImpl(repository: repository);

      test("single_change", () {
        final budget = BudgetDummyGenerator().generateBudget(openEnded: true);
        repository.createBudget(
          budget,
        );

        final update = budget.copyWith(
          cap: BudgetCap(value: 500, type: CapType.amount),
        );

        final selectedDate = Jiffy.parseFromDateTime(budget.start).add(months: 4).dateTime;
        updateUseCase.execute(budget, update, selectedDate, BudgetChangeMode.all);

        final list = repository.testingGetBudgetForSeriesId(budget.seriesId);
        expect(list.length, 1);

        expect(list[0].end, budget.end);
        expect(list[0].cap, update.cap);
      });
    });


    group("test_update_budget: thisAndAllAfter", () {
      final repository = BudgetRepositoryDummy();
      final updateUseCase = UpdateBudgetUseCaseImpl(repository: repository);


      test("single_change", () {
        final budget = BudgetDummyGenerator().generateBudget(openEnded: true);
        repository.createBudget(
          budget,
        );

        final update = budget.copyWith(
          cap: BudgetCap(value: 500, type: CapType.amount),
        );

        final selectedDate = Jiffy.parseFromDateTime(budget.start).add(months: 4).dateTime;
        updateUseCase.execute(budget, update, selectedDate, BudgetChangeMode.thisAndAllAfter);

        final list = repository.testingGetBudgetForSeriesId(budget.seriesId);
        expect(list.length, 2);

        expect(list[1].start, selectedDate);
        expect(list[1].end, budget.end);
        expect(list[1].cap, update.cap);
      });
    });

    group("test_update_budget: thisAndAllBefore", () {
      final repository = BudgetRepositoryDummy();
      final updateUseCase = UpdateBudgetUseCaseImpl(repository: repository);


      test("single_change", () {
        final budget = BudgetDummyGenerator().generateBudget(openEnded: true);
        repository.createBudget(
          budget,
        );

        final update = budget.copyWith(
          cap: BudgetCap(value: 500, type: CapType.amount),
        );

        final selectedDate = Jiffy.parseFromDateTime(budget.start).add(months: 4).dateTime;
        updateUseCase.execute(budget, update, selectedDate, BudgetChangeMode.thisAndAllBefore);

        final list = repository.testingGetBudgetForSeriesId(budget.seriesId);
        expect(list.length, 2);

        expect(list[0].start, budget.start);
        expect(list[0].cap, update.cap);
        expect(list[0].end, selectedDate);
        expect(list[1].end, budget.end);
      });
    });

  });
}
