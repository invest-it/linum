import 'package:flutter_test/flutter_test.dart';
import 'package:linum/core/categories/constants/standard_categories.dart';
import 'package:linum/core/categories/models/category.dart';
import 'package:linum/features/currencies/constants/standard_currencies.dart';
import 'package:linum/features/currencies/models/currency.dart';
import 'package:linum/screens/enter_screen/enums/input_type.dart';
import 'package:linum/screens/enter_screen/models/enter_screen_form_data.dart';
import 'package:linum/screens/enter_screen/models/structured_parsed_data.dart';
import 'package:linum/screens/enter_screen/models/parsed_input.dart';
import 'package:linum/screens/enter_screen/utils/parsing/input_parser.dart';

import '../test_utils/load_localization.dart';

void main() {
  group("enter_screen_parsing_test", () {
    test("parse text input correctly", () async {
      await loadLocalization();

      const inputStr = "9 EUR Döner #today #Food & Drinks";
      final result = InputParser().parse(inputStr);


      final expected = StructuredParsedData(
        inputStr,
        amount: ParsedInput<double>(
          type: InputType.amount,
          value: 9,
          raw: "9",
          indices: (start: 0, end: 1),
        ),
        currency: ParsedInput<Currency>(
          type: InputType.currency,
          value: standardCurrencies["EUR"]!,
          raw: "EUR",
          indices: (start: 2, end: 5),
        ),
        name: ParsedInput<String>(
          type: InputType.name,
          value: "Döner",
          raw: "Döner",
          indices: (start: 6, end: 11),
        ),
        category: ParsedInput<Category>(
          type: InputType.category,
          value: getCategory("food")!,
          raw: "#Food & Drinks",
          indices: (start: 19, end: 33),
        ),
        date: ParsedInput<String>(
          type: InputType.date,
          value: result.date?.value ?? DateTime.now().toIso8601String(), // TODO Find a better way to test date-string
          raw: "#today",
          indices: (start: 12, end: 18),
        ),
      );

      expect(result, expected);
    });
  });
}
