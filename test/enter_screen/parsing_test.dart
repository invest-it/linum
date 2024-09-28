import 'package:flutter_test/flutter_test.dart';
import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/core/categories/core/domain/service_impl/category_service_standard_impl.dart';
import 'package:linum/screens/enter_screen/domain/parsing/category_parser.dart';
import 'package:linum/screens/enter_screen/domain/parsing/input_parser.dart';

import '../test_utils/test_translator.dart';
import 'test_inputs.dart';

void main() {
  group("enter_screen_parsing_test", () {
    final translator = TestTranslator();
    final categoryService = CategoryServiceStandardImpl();


    test("parse text input correctly", () async {
      await translator.initializationFinished;
      final testInputs = generateInputParserData();

      for (final input in testInputs) {
        final result = InputParser(
          translator: translator,
          categoryParser: CategoryParser(
            translator: translator,
            categories: categoryService.getAllCategories(),
            filter: null,
          ),
        ).parse(input.raw);

        final expected = input;
        expect(result, expected);
      }
    });


    test("parse categories correctly", () async {
      await translator.initializationFinished;
      final testInputs = getCategoryParserTestData(null);

      for (final input in testInputs.entries) {
        final result = CategoryParser(
            translator: translator,
            categories: categoryService.getAllCategories(),
            filter: null,
        ).parse(input.key);
        expect(result, input.value);
      }
    });

    test("parse expense categories correctly", () async {
      await translator.initializationFinished;
      final testInputs = getCategoryParserTestData("expense");

      for (final input in testInputs.entries) {
        final result = CategoryParser(
          translator: translator,
          filter: (category) => category.entryType == EntryType.expense,
          categories: categoryService.getAllCategories(),
        ).parse(input.key);
        expect(result, input.value);
      }
    });

    test("parse income categories correctly", () async {
      await translator.initializationFinished;
      final testInputs = getCategoryParserTestData("income");

      for (final input in testInputs.entries) {
        final result = CategoryParser(
          translator: translator,
          categories: categoryService.getAllCategories(),
          filter: (category) => category.entryType == EntryType.income,
        ).parse(input.key);
        expect(result, input.value);
      }
    });
  });
}
