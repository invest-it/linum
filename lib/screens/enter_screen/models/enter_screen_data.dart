import 'package:linum/core/categories/constants/standard_categories.dart';
import 'package:linum/core/categories/models/category.dart';
import 'package:linum/core/repeating/constants/standard_repeat_configs.dart';
import 'package:linum/core/repeating/enums/repeat_interval.dart';
import 'package:linum/core/repeating/models/repeat_configuration.dart';
import 'package:linum/features/currencies/constants/standard_currencies.dart';
import 'package:linum/features/currencies/models/currency.dart';
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

  EnterScreenData removeCategory() {
    return EnterScreenData(
      amount: amount,
      name: name,
      currency: currency,
      date: date,
      repeatConfiguration: repeatConfiguration,
      isParsed: isParsed,
    );
  }

  factory EnterScreenData.fromInput(EnterScreenInput input) {
    final amount = input.amount?.value;
    final name = input.name?.value;
    final currency = standardCurrencies[input.currency?.value];

    Category? category;
    String? date;
    RepeatConfiguration? repeatConfiguration;

    if (input.hasCategory) {
      category = standardCategories[input.category!.value];
    }
    if (input.hasDate) {
      date = input.date!.value;
    }
    if (input.hasRepeatInfo) {
      RepeatInterval interval;
      try {
        interval = RepeatInterval.values.byName(input.repeatInfo!.value);
      } catch (e) {
        interval = RepeatInterval.none;
      }
      repeatConfiguration = repeatConfigurations[interval];
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
