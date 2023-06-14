import 'package:linum/core/categories/constants/standard_categories.dart';
import 'package:linum/core/categories/models/category.dart';
import 'package:linum/core/repeating/constants/standard_repeat_configs.dart';
import 'package:linum/core/repeating/enums/repeat_interval.dart';
import 'package:linum/core/repeating/models/repeat_configuration.dart';
import 'package:linum/features/currencies/constants/standard_currencies.dart';
import 'package:linum/features/currencies/models/currency.dart';
import 'package:linum/screens/enter_screen/enums/input_flag.dart';
import 'package:linum/screens/enter_screen/models/enter_screen_input.dart';

class EnterScreenData {
  final num? amount;
  final String? name;
  final Currency? currency;
  final Category? category;
  final String? date;
  final RepeatConfiguration? repeatConfiguration;
  final bool isParsed;

  const EnterScreenData({
    this.amount,
    this.name,
    this.currency,
    this.category,
    this.date,
    this.repeatConfiguration,
    this.isParsed = false,
  });

  EnterScreenData copyWith({
    num? amount,
    String? name,
    Currency? currency,
    Category? category,
    String? date,
    RepeatConfiguration? repeatConfiguration,
    bool isParsed = false,
  }) {
    return EnterScreenData(
      amount: amount ?? this.amount,
      name: name ?? this.name,
      currency: currency ?? this.currency,
      category: category ?? this.category,
      date: date ?? this.date,
      repeatConfiguration: repeatConfiguration ?? this.repeatConfiguration,
      isParsed: isParsed,
    );
  }

  factory EnterScreenData.fromInput(EnterScreenInput input) {
    final amount = input.amount;
    final name = input.name;
    final currency = standardCurrencies[input.currency];

    Category? category;
    String? date;
    RepeatConfiguration? repeatConfiguration;

    for (final element in input.parsedInputs) {
      switch (element.flag) {
        case InputFlag.category:
          category = standardCategories[element.text];
          break;
        case InputFlag.date:
          date = element.text;
          break;
        case InputFlag.repeatInfo:
          RepeatInterval interval;
          try {
            interval = RepeatInterval.values.byName(element.text);
          } catch (e) {
            interval = RepeatInterval.none;
          }
          repeatConfiguration = repeatConfigurations[interval];
          break;
      }
    }

    return EnterScreenData(
      amount: amount,
      name: name,
      currency: currency,
      category: category,
      date: date,
      repeatConfiguration: repeatConfiguration,
      isParsed: true,
    );
  }
}
