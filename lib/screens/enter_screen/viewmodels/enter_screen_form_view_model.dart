import 'dart:async';
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
  late final DefaultValues defaultValues;
  late final bool withExistingData;

  late EnterScreenData _data;
  /// When using context.watch or Consumer / Selector
  /// you will get notified about changes to data;
  EnterScreenData get data => _data;
  set data(EnterScreenData data) {
    _data = data;
    _streamController.add(_data);
    notifyListeners();
  }

  final _streamController = StreamController<EnterScreenData>();
  /// In case you can't use context.watch or Consumer / Selector
  /// stream will provide you with the newest data.
  late Stream<EnterScreenData> stream = _streamController.stream;

  EntryType? _entryType;


  OverlayEntry? _currentOverlay;
  OverlayEntry? get currentOverlay => _currentOverlay;
  void setOverlayEntry(OverlayEntry? overlayEntry) {
    _currentOverlay?.remove();
    _currentOverlay = overlayEntry;
  }


  EnterScreenFormViewModel(BuildContext context) {
    final screenViewModel = context.read<EnterScreenViewModel>();
    _setupData(screenViewModel);

    final transaction = screenViewModel.initialTransaction;
    withExistingData = transaction != null;

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

  }


  void _setupData(EnterScreenViewModel screenViewModel) {
    final transaction = screenViewModel.initialTransaction;
    final parentalSerialTransaction = screenViewModel.parentalSerialTransaction;

    final repeatInterval = getRepeatInterval(
      parentalSerialTransaction?.repeatDuration,
      parentalSerialTransaction?.repeatDurationType,
    );

    _entryType = screenViewModel.entryType;

    _data = EnterScreenData(
      name: transaction?.name,
      amount: transaction?.amount,
      currency: standardCurrencies[transaction?.currency],
      date: transaction?.date.toDate().toIso8601String(),
      category: getCategory(transaction?.category, entryType: _entryType),
      repeatConfiguration: repeatConfigurations[repeatInterval],
      notes: transaction?.note,
    );
  }

  void handleUpdate(BuildContext context) {
    final screenViewModel = context.read<EnterScreenViewModel>();
    if (screenViewModel.entryType != _entryType) {
      _setupData(screenViewModel);
      notifyListeners();
    }
  }


  @override
  void dispose() {
    super.dispose();
    _streamController.close();
    _currentOverlay?.remove();
  }
}
