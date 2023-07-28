import 'package:flutter_test/flutter_test.dart';
import 'package:linum/core/categories/constants/standard_categories.dart';
import 'package:linum/core/categories/models/category.dart';
import 'package:linum/features/currencies/constants/standard_currencies.dart';
import 'package:linum/features/currencies/models/currency.dart';
import 'package:linum/screens/enter_screen/enums/input_type.dart';
import 'package:linum/screens/enter_screen/models/parsed_input.dart';
import 'package:linum/screens/enter_screen/models/structured_parsed_data.dart';
import 'package:linum/screens/enter_screen/utils/parsing/input_parser.dart';

import '../test_utils/load_localization.dart';
import 'test_inputs.dart';

void main() {
  group("enter_screen_parsing_test", () {
    test("parse text input correctly", () async {
      await loadLocalization();

      final testInputs = generateTestData();

      for (final input in testInputs) {
        final result = InputParser().parse(input.raw);
        final expected = input;
        expect(result, expected);
      }

    });
  });
}
