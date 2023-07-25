import 'package:flutter/cupertino.dart';
import 'package:linum/core/account/services/account_settings_service.dart';
import 'package:linum/core/repeating/constants/standard_repeat_configs.dart';
import 'package:linum/core/repeating/enums/repeat_interval.dart';
import 'package:linum/screens/enter_screen/models/default_values.dart';
import 'package:provider/provider.dart';

DefaultValues getDefaultValues(BuildContext context) {
  final accountSettingsService = context.read<AccountSettingsService>();
  return DefaultValues(
    name: "",
    amount: 0,
    currency: accountSettingsService.getStandardCurrency(),
    date: DateTime.now().toIso8601String(),
    expenseCategory: accountSettingsService.getExpenseEntryCategory(),
    incomeCategory: accountSettingsService.getIncomeEntryCategory(),
    repeatConfiguration: repeatConfigurations[RepeatInterval.none]!,
  );
}