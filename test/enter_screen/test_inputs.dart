import 'package:linum/core/categories/constants/standard_categories.dart';
import 'package:linum/core/categories/models/category.dart';
import 'package:linum/core/repeating/models/repeat_configuration.dart';
import 'package:linum/features/currencies/constants/standard_currencies.dart';
import 'package:linum/features/currencies/models/currency.dart';
import 'package:linum/screens/enter_screen/enums/input_type.dart';
import 'package:linum/screens/enter_screen/models/parsed_input.dart';
import 'package:linum/screens/enter_screen/models/structured_parsed_data.dart';


class TestDataBuilder {
  final String input;
  ParsedInput<double>? _amount;
  ParsedInput<Currency>? _currency;
  ParsedInput<String>? _name;
  ParsedInput<Category>? _category;
  ParsedInput<String>? _date;
  ParsedInput<RepeatConfiguration>? _repeatConfiguration;

  TestDataBuilder(this.input);


  void setAmount(String raw, double value) {
    _amount = ParsedInput.testing(
        type: InputType.amount,
        value: value,
        text: input,
        substr: raw
    );
  }
  void setCurrency(String raw, Currency value) {
    _currency = ParsedInput.testing(
        type: InputType.currency,
        value: value,
        text: input,
        substr: raw
    );
  }
  void setName(String raw, {String? value}) {
    _name = ParsedInput.testing(
        type: InputType.name,
        value: value ?? raw,
        text: input,
        substr: raw
    );
  }
  void setCategory(String raw, Category value) {
    _category = ParsedInput.testing(
        type: InputType.category,
        value: value,
        text: input,
        substr: raw
    );
  }
  void setDate(String raw, String value) {
    _date = ParsedInput.testing(
        type: InputType.date,
        value: value,
        text: input,
        substr: raw
    );
  }
  void setRepeatConfiguration(String raw, RepeatConfiguration value) {
    _repeatConfiguration = ParsedInput.testing(
        type: InputType.repeatInfo,
        value: value,
        text: input,
        substr: raw
    );
  }


  StructuredParsedData build() {
    return StructuredParsedData(
      input,
      amount: _amount,
      currency: _currency,
      name: _name,
      category: _category,
      date: _date,
      repeatInfo: _repeatConfiguration,
    );
  }
}

List<StructuredParsedData> generateTestData() {
  final List<StructuredParsedData> testInputs = [];

  var builder = TestDataBuilder("9 EUR Döner #Food & Drinks")
    ..setAmount("9", 9)
    ..setCurrency("EUR", standardCurrencies["EUR"]!)
    ..setName("Döner")
    ..setCategory("#Food & Drinks", getCategory("food")!);

  testInputs.add(builder.build());

  builder = TestDataBuilder("USD 12.00 Test #Date:28.07.")
    ..setAmount("12.00", 12.00)
    ..setCurrency("USD", standardCurrencies["USD"]!)
    ..setName("Test");

  // TODO: Function to generate correct date values for testing
  // testInputs.add(builder.build());

  return testInputs;
}

