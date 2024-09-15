import 'package:flutter_test/flutter_test.dart';
import 'package:jiffy/jiffy.dart';
import 'package:linum/common/interfaces/time_span.dart';
import 'package:linum/core/budget/domain/repositories/budget_repository_dummy.dart';
import 'package:linum/core/budget/domain/use_cases/delete_budget_use_case.dart';
import 'package:linum/core/budget/enums/budget_change_mode.dart';

import '../utils/budget_generator.dart';
import '../utils/expect_same_month.dart';

void main() {
  group("delete_budget_use_case_test", ()
  {
    group("test_delete_budget: onlyOne", () {
      final repository = BudgetRepositoryDummy();
      final deleteUseCase = DeleteBudgetUseCaseImpl(repository: repository);

      test("single_change", () async {
        final budget = BudgetDummyGenerator().generateBudget(openEnded: true);
        await repository.createBudget(
          budget,
        );

        final selectedDate = Jiffy.parseFromDateTime(budget.start).add(months: 4).dateTime;

        if (!budget.containsDate(selectedDate)) {
          expect(() async {
            await deleteUseCase.execute(
                budget, selectedDate, BudgetChangeMode.onlyOne,);
          }, throwsException,);
          return;
        }

        await deleteUseCase.execute(budget, selectedDate, BudgetChangeMode.onlyOne);

        final list = repository.testingGetBudgetForSeriesId(budget.seriesId);
        expect(list.length, 2);

        expectSameMonth(list[0].start, budget.start);
        expectSameMonth(list[0].end, Jiffy.parseFromDateTime(selectedDate).subtract(months: 1).dateTime);
        expectSameMonth(list[1].start, Jiffy.parseFromDateTime(selectedDate).add(months: 1).dateTime);
        expectSameMonth(list[1].end, budget.end);
      });
    });
  });

  group("test_delete_budget: all", (){
    final repository = BudgetRepositoryDummy();
    final deleteUseCase = DeleteBudgetUseCaseImpl(repository: repository);

    test("single_change", () async {
      final budget = BudgetDummyGenerator().generateBudget(openEnded: true);
      await repository.createBudget(
        budget,
        );

      final selectedDate = Jiffy.parseFromDateTime(budget.start).dateTime;
      
      await deleteUseCase.execute(budget, selectedDate, BudgetChangeMode.all);

      final list = repository.testingGetBudgetForSeriesId(budget.seriesId);
      expect(list.length, 0);
    });
  });

  group("test_delete_budget: thisAndAllAfter", (){
    final repository = BudgetRepositoryDummy();
    final deleteUseCase = DeleteBudgetUseCaseImpl(repository: repository);

    test("single_change", () async {
      final budget = BudgetDummyGenerator().generateBudget(openEnded: true);
      await repository.createBudget(
        budget,
        );

      final selectedDate = Jiffy.parseFromDateTime(budget.start).dateTime;
      
      if (!budget.containsDate(selectedDate)){
        expect(() async {
          await deleteUseCase.execute(budget, selectedDate, BudgetChangeMode.thisAndAllAfter);
        }, throwsException, );
        return;
      }

      await deleteUseCase.execute(budget, selectedDate, BudgetChangeMode.thisAndAllAfter);

      final list = repository.testingGetBudgetForSeriesId(budget.seriesId);
      expect(list.length, 1);

      expectSameMonth(list[0].start, budget.start);
      expectSameMonth(list[0].end, Jiffy.parseFromDateTime(selectedDate).subtract(months: 1).dateTime);
    });
  });

  group("test_delete_budget: thisAndAllBefore", (){
    final repository = BudgetRepositoryDummy();
    final deleteUseCase = DeleteBudgetUseCaseImpl(repository: repository);

    test("single_change", () async {
      final budget = BudgetDummyGenerator().generateBudget(openEnded: true);
      await repository.createBudget(
        budget,
      );

      final selectedDate = Jiffy.parseFromDateTime(budget.start).dateTime;
      
      if (!budget.containsDate(selectedDate)){
        expect(() async {
          await deleteUseCase.execute(budget, selectedDate, BudgetChangeMode.thisAndAllAfter);
        }, throwsException, );
        return;
      }

      deleteUseCase.execute(budget, selectedDate, BudgetChangeMode.thisAndAllBefore);

      final list = repository.testingGetBudgetForSeriesId(budget.seriesId);
      expect(list.length, 1);

      expectSameMonth(list[1].start, Jiffy.parseFromDateTime(selectedDate).add(months: 1).dateTime);
      expectSameMonth(list[1].end, budget.end);
    });
  });
}
