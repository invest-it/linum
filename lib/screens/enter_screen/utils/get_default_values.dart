import 'package:flutter/cupertino.dart';
import 'package:linum/core/account/presentation/services/category_settings_service.dart';
import 'package:linum/core/repeating/constants/standard_repeat_configs.dart';
import 'package:linum/core/repeating/enums/repeat_interval.dart';
import 'package:linum/features/currencies/settings/presentation/currency_settings_service.dart';
import 'package:linum/screens/enter_screen/models/default_values.dart';
import 'package:provider/provider.dart';

DefaultValues getDefaultValues(BuildContext context) {
  final currencySettingsService = context.read<ICurrencySettingsService>();
  final categorySettingsService = context.read<ICategorySettingsService>();

  return DefaultValues(
    name: "",
    amount: 0,
    currency: currencySettingsService.getStandardCurrency(),
    date: DateTime.now().toIso8601String(),
    expenseCategory: categorySettingsService.getExpenseEntryCategory(),
    incomeCategory: categorySettingsService.getIncomeEntryCategory(),
    repeatConfiguration: repeatConfigurations[RepeatInterval.none]!,
  );
}
