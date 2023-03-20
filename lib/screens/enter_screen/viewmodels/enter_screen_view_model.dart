import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:flutter/material.dart';
import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/core/account/services/account_settings_service.dart';
import 'package:linum/core/balance/models/serial_transaction.dart';
import 'package:linum/core/balance/models/transaction.dart';
import 'package:linum/core/balance/services/balance_data_service.dart';
import 'package:linum/core/categories/constants/standard_categories.dart';
import 'package:linum/core/design/layout/enums/screen_fraction_enum.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:linum/core/design/layout/utils/media_query_accessors.dart';
import 'package:linum/core/repeating/constants/standard_repeat_configs.dart';
import 'package:linum/core/repeating/enums/repeat_interval.dart';
import 'package:linum/features/currencies/constants/standard_currencies.dart';
import 'package:linum/screens/enter_screen/models/default_values.dart';
import 'package:linum/screens/enter_screen/utils/get_entry_type.dart';
import 'package:linum/screens/enter_screen/viewmodels/enter_screen_view_model_data.dart';
import 'package:provider/provider.dart';

typedef OnSaveCallback = void Function({
  Transaction? transaction,
  SerialTransaction? serialTransaction,
});
typedef OnDeleteCallback = void Function({
  Transaction? transaction,
  SerialTransaction? serialTransaction,
});
// TODO: Add SerialTransaction
void _onSaveDefault({
  Transaction? transaction,
  SerialTransaction? serialTransaction,
}) {}
void _onDeleteDefault({
  Transaction? transaction,
  SerialTransaction? serialTransaction,
}) {}

class EnterScreenViewModel extends ChangeNotifier {
  late Transaction? _initialTransaction;
  late SerialTransaction? _initialSerialTransaction;


  late OnSaveCallback _onSave;
  late OnDeleteCallback _onDelete;

  late DefaultValues defaultData;

  late EnterScreenViewModelData _data;
  EnterScreenViewModelData get data => _data;

  EntryType _entryType = EntryType.unknown;
  EntryType get entryType => _entryType;
  set entryType(EntryType value) {
    _entryType = value;
    notifyListeners();
  }

  bool _isBottomSheetOpened = false;
  bool get isBottomSheetOpened => _isBottomSheetOpened;
  set isBottomSheetOpened(bool value) {
    _isBottomSheetOpened = value;
    notifyListeners();
  }

  OverlayEntry? _currentOverlay;
  OverlayEntry? get currentOverlay => _currentOverlay;
  void setOverlayEntry(OverlayEntry? overlayEntry) {
    _currentOverlay?.remove();
    _currentOverlay = overlayEntry;
  }

  EnterScreenViewModel._(
    BuildContext context, {
    OnSaveCallback onSave = _onSaveDefault,
    OnDeleteCallback onDelete = _onDeleteDefault,
    Transaction? transaction,
    SerialTransaction? serialTransaction, // TODO: Implement those
  }) {
    final accountSettingsService
      = Provider.of<AccountSettingsService>(context, listen: false);
    final balanceDataService
      = Provider.of<BalanceDataService>(context, listen: false);

    _initialTransaction = transaction;
    _initialSerialTransaction = serialTransaction;

    _onSave = onSave;
    _onDelete = onDelete;

    _entryType = getEntryType(
        transaction: transaction,
        serialTransaction: serialTransaction,
    );

    defaultData = DefaultValues(
      name: "",
      amount: 0,
      currency: accountSettingsService.getStandardCurrency(),
      date: DateTime.now().toIso8601String(),
      category: null,
      repeatConfiguration: repeatConfigurations[RepeatInterval.none]!,
    );

    _data = EnterScreenViewModelData(
      withExistingData: transaction != null || serialTransaction != null,
      name: transaction?.name,
      amount: transaction?.amount,
      currency: standardCurrencies[transaction?.currency],
      date: transaction?.time.toDate().toIso8601String(),
      category: standardCategories[transaction?.category],
      // TODO: Implement RepeatInterval functionality
    );
    // No _selectedRepeatInfo for transactions
  }

  factory EnterScreenViewModel.empty(
      BuildContext context, {
      required OnSaveCallback onSave,
  }){
    return EnterScreenViewModel._(
      context,
      onSave: onSave,
    );
  }

  factory EnterScreenViewModel.fromTransaction(
      BuildContext context, {
      required Transaction transaction,
      required OnSaveCallback onSave,
      required OnDeleteCallback onDelete,
  }) {
    return EnterScreenViewModel._(
      context,
      transaction: transaction,
      onSave: onSave,
      onDelete: onDelete,
    );
  }

  factory EnterScreenViewModel.fromSerialTransaction(
      BuildContext context, {
      required SerialTransaction serialTransaction,
      required OnSaveCallback onSave,
      required OnDeleteCallback onDelete,
  }) {
    return EnterScreenViewModel._(
      context,
      serialTransaction: serialTransaction,
      onSave: onSave,
      onDelete: onDelete,
    );
  }



  double calculateMaxHeight(BuildContext context) {
    if (_isBottomSheetOpened) {
      return context.proportionateScreenHeightFraction(ScreenFraction.threefifths);
    }
    if (_entryType == EntryType.unknown) {
      return 160;
    }
    return 250 + useKeyBoardHeight(context);
  }

  void update(EnterScreenViewModelData data, {bool notify = false}) {
    _data = data;
    if (notify) {
      notifyListeners();
    }
  }

  void save() {
    final amount = _entryType == EntryType.expense
        ? -(data.amount ?? defaultData.amount)
        : (data.amount ?? defaultData.amount);

    if (data.repeatConfiguration != null
        && data.repeatConfiguration?.interval != RepeatInterval.none) {
      final serialTransaction = SerialTransaction(
          id: _initialSerialTransaction?.id,
          amount: amount,
          category: data.category?.id ?? defaultData.category?.id,
          currency: data.currency?.name ?? defaultData.currency.name,
          name: data.name ?? defaultData.name,
          initialTime: firestore.Timestamp.fromDate(
              DateTime.parse(data.date ?? defaultData.date),
          ),
          repeatDuration: data.repeatConfiguration!.duration!,
          repeatDurationType: data.repeatConfiguration!.durationType!,
          // This is not null because only RepeatInterval.none holds a null duration value
      );
      _onSave(serialTransaction: serialTransaction);
      return;
    }

    final transaction = Transaction(
      id: _initialTransaction?.id,
      amount: amount,
      currency: data.currency?.name ?? defaultData.currency.name,
      name: data.name ?? defaultData.name,
      time: firestore.Timestamp.fromDate(
          DateTime.parse(data.date ?? defaultData.date),
      ),
      category: data.category?.id ?? defaultData.category?.id,
    );

    _onSave(transaction: transaction);
  }

  void delete() {
    _onDelete(
      transaction: _initialTransaction,
      serialTransaction: _initialSerialTransaction,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _currentOverlay?.remove();
  }
}