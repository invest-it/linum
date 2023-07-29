import 'package:linum/core/categories/models/category.dart';
import 'package:linum/core/repeating/models/repeat_configuration.dart';
import 'package:linum/features/currencies/models/currency.dart';
import 'package:linum/screens/enter_screen/enums/input_type.dart';
import 'package:linum/screens/enter_screen/models/parsed_input.dart';
import 'package:linum/screens/enter_screen/models/structured_parsed_data.dart';

class StructuredParsedDataBuilder {
  final String input;
  ParsedInput<double>? _amount;
  ParsedInput<Currency>? _currency;
  ParsedInput<String>? _name;
  ParsedInput<Category>? _category;
  ParsedInput<String>? _date;
  ParsedInput<RepeatConfiguration>? _repeatConfiguration;

  StructuredParsedDataBuilder(this.input);


  void setAmount(String raw, double value) {
    _amount = ParsedInput.fromSubstring(
        type: InputType.amount,
        value: value,
        text: input,
        substr: raw,
    );
  }
  void setCurrency(String raw, Currency value) {
    _currency = ParsedInput.fromSubstring(
        type: InputType.currency,
        value: value,
        text: input,
        substr: raw,
    );
  }
  void setName(String raw, {String? value}) {
    _name = ParsedInput.fromSubstring(
        type: InputType.name,
        value: value ?? raw,
        text: input,
        substr: raw,
    );
  }
  void setCategory(String raw, Category value) {
    _category = ParsedInput.fromSubstring(
        type: InputType.category,
        value: value,
        text: input,
        substr: raw,
    );
  }
  void setDate(String raw, String value) {
    _date = ParsedInput.fromSubstring(
        type: InputType.date,
        value: value,
        text: input,
        substr: raw,
    );
  }
  void setRepeatConfiguration(String raw, RepeatConfiguration value) {
    _repeatConfiguration = ParsedInput.fromSubstring(
        type: InputType.repeatInfo,
        value: value,
        text: input,
        substr: raw,
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
