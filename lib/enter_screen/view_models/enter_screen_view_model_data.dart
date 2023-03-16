import 'package:linum/constants/standard_categories.dart';
import 'package:linum/constants/standard_currencies.dart';
import 'package:linum/constants/standard_repeat_configs.dart';
import 'package:linum/enter_screen/enums/input_flag.dart';
import 'package:linum/enter_screen/enums/repeat_interval.dart';
import 'package:linum/enter_screen/models/enter_screen_input.dart';
import 'package:linum/models/category.dart';
import 'package:linum/models/currency.dart';
import 'package:linum/models/repeat_configuration.dart';

class EnterScreenViewModelData {
  final num? amount;
  final String? name;
  final Currency? currency;
  final Category? category;
  final String? date;
  final RepeatConfiguration? repeatConfiguration;
  final bool withExistingData;

  const EnterScreenViewModelData({
    this.amount,
    this.name,
    this.currency,
    this.category,
    this.date,
    this.repeatConfiguration,
    this.withExistingData = false,
  });

  factory EnterScreenViewModelData.fromInput(EnterScreenInput input) {
    final amount = input.amount;
    final name = input.name;
    final currency = standardCurrencies[input.currency];

    Category? category;
    String? date;
    RepeatConfiguration? repeatConfiguration;

    for (final element in input.parsedInputs) {
      switch (element.item1) {
        case InputFlag.category:
          category = standardCategories[element.item2];
          break;
        case InputFlag.date:
          date = element.item2;
          break;
        case InputFlag.repeatInfo:
          RepeatInterval interval;
          try {
            interval = RepeatInterval.values.byName(element.item2);
          } catch (e) {
            interval = RepeatInterval.none;
          }
          repeatConfiguration = repeatConfigurations[interval];
          break;
      }
    }

    return EnterScreenViewModelData(
        amount: amount,
        name: name,
        currency: currency,
        category: category,
        date: date,
        repeatConfiguration: repeatConfiguration,
    );
  }
}

