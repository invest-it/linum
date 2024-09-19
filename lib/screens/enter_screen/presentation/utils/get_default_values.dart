import 'package:flutter/cupertino.dart';
import 'package:linum/core/balance/presentation/algorithm_service.dart';
import 'package:linum/core/categories/settings/presentation/category_settings_service.dart';
import 'package:linum/core/repeating/constants/standard_repeat_configs.dart';
import 'package:linum/core/repeating/enums/repeat_interval.dart';
import 'package:linum/features/currencies/settings/presentation/currency_settings_service.dart';
import 'package:linum/screens/enter_screen/presentation/models/default_values.dart';
import 'package:provider/provider.dart';

DefaultValues getDefaultValues(BuildContext context) {
  final currencySettingsService = context.read<ICurrencySettingsService>();
  final categorySettingsService = context.read<ICategorySettingsService>();

  var date = DateTime.now().toIso8601String();

  final AlgorithmService algorithmService = context.read<AlgorithmService>();
  if(algorithmService.state.shownMonth.year != DateTime.now().year
      || algorithmService.state.shownMonth.month != DateTime.now().month){
    date = algorithmService.state.shownMonth.toIso8601String();
  }

  return DefaultValues(
    name: "",
    amount: 0,
    currency: currencySettingsService.getStandardCurrency(),
    date: date,
    expenseCategory: categorySettingsService.getExpenseEntryCategory(),
    incomeCategory: categorySettingsService.getIncomeEntryCategory(),
    repeatConfiguration: repeatConfigurations[RepeatInterval.none]!,
  );
}
