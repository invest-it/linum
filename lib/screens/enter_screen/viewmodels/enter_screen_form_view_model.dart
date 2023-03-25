import 'package:flutter/material.dart';
import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/core/account/services/account_settings_service.dart';
import 'package:linum/core/categories/constants/standard_categories.dart';
import 'package:linum/core/repeating/constants/standard_repeat_configs.dart';
import 'package:linum/core/repeating/enums/repeat_interval.dart';
import 'package:linum/features/currencies/constants/standard_currencies.dart';
import 'package:linum/screens/enter_screen/models/default_values.dart';
import 'package:linum/screens/enter_screen/models/enter_screen_data.dart';
import 'package:linum/screens/enter_screen/utils/get_repeat_interval.dart';
import 'package:linum/screens/enter_screen/viewmodels/enter_screen_view_model.dart';
import 'package:provider/provider.dart';

class EnterScreenFormViewModel extends ChangeNotifier {
  late final bool withExistingData;
  late final EntryType entryType;
  late EnterScreenData _data;
  EnterScreenData get data => _data;
  set data(EnterScreenData data) {
    _data = data;
    print(data);
    notifyListeners();
  }

  late final DefaultValues defaultValues;

  OverlayEntry? _currentOverlay;
  OverlayEntry? get currentOverlay => _currentOverlay;
  void setOverlayEntry(OverlayEntry? overlayEntry) {
    _currentOverlay?.remove();
    _currentOverlay = overlayEntry;
  }

  EnterScreenFormViewModel(BuildContext context) {
    final screenViewModel = Provider.of<EnterScreenViewModel>(
      context,
      listen: false,
    );

    final trx = screenViewModel.initialTransaction;
    screenViewModel.getParentSerialTransaction(context)
      ?.then((value) {
        if (value != null) {
          final repeatInterval = getRepeatInterval(
            value.repeatDuration, value.repeatDurationType,
          );
          data = _data.copyWith(
            repeatConfiguration: repeatConfigurations[repeatInterval],
          );
        }
      });


    _data = EnterScreenData(
      name: trx?.name,
      amount: trx?.amount,
      currency: standardCurrencies[trx?.currency],
      date: trx?.date.toDate().toIso8601String(),
      category: standardCategories[trx?.category],
    );

    if (trx == null
        && trx == null) {
      withExistingData = false;
    } else {
      withExistingData = true;
    }

    final accountSettingsService
      = context.read<AccountSettingsService>();
    defaultValues = DefaultValues(
      name: "",
      amount: 0,
      currency: accountSettingsService.getStandardCurrency(),
      date: DateTime.now().toIso8601String(),
      expenseCategory: accountSettingsService.getExpenseEntryCategory(),
      incomeCategory: accountSettingsService.getIncomeEntryCategory(),
      repeatConfiguration: repeatConfigurations[RepeatInterval.none]!,
    );
    entryType = screenViewModel.entryType;

  }




  @override
  void dispose() {
    super.dispose();
    _currentOverlay?.remove();
  }
}