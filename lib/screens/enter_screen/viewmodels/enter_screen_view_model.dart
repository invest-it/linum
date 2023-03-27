import 'package:flutter/material.dart';
import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/core/balance/enums/serial_transaction_change_type_enum.dart';
import 'package:linum/core/balance/models/serial_transaction.dart';
import 'package:linum/core/balance/models/transaction.dart';
import 'package:linum/core/balance/services/balance_data_service.dart';
import 'package:linum/screens/enter_screen/actions/enter_screen_actions.dart';
import 'package:linum/screens/enter_screen/enums/enter_screen_view_state.dart';
import 'package:linum/screens/enter_screen/models/default_values.dart';
import 'package:linum/screens/enter_screen/models/enter_screen_data.dart';
import 'package:linum/screens/enter_screen/utils/get_entry_type.dart';
import 'package:provider/provider.dart';


class EnterScreenViewModel extends ChangeNotifier {
  final Transaction? initialTransaction;
  final SerialTransaction? initialSerialTransaction;

  final EnterScreenActions _actions;

  EntryType _entryType = EntryType.unknown;
  EntryType get entryType => _entryType;
  set entryType(EntryType value) {
    _entryType = value;
    notifyListeners();
  }

  late EnterScreenViewState _viewState;
  EnterScreenViewState get viewState => _viewState;
  set viewState(EnterScreenViewState value) {
    _viewState = value;
    notifyListeners();
  }

  bool _isBottomSheetOpened = false;
  bool get isBottomSheetOpened => _isBottomSheetOpened;
  set isBottomSheetOpened(bool value) {
    _isBottomSheetOpened = value;
    notifyListeners();
  }

  Future<SerialTransaction?>? _parentSerialTransaction;

  Future<SerialTransaction?>? getParentSerialTransaction(BuildContext context) {
    if (_parentSerialTransaction != null) {
      return _parentSerialTransaction;
    }
    if (initialTransaction != null && initialTransaction?.repeatId != null) {
      final balanceDataService = context.read<BalanceDataService>();
      _parentSerialTransaction = balanceDataService
          .findSerialTransactionWithId(initialTransaction!.repeatId!);
    }
    return _parentSerialTransaction;
  }

  EnterScreenData? _formResult;
  DefaultValues? _defaultValues;

  EnterScreenViewModel._(
    BuildContext context, {
      required EnterScreenActions actions,
      this.initialTransaction,
      this.initialSerialTransaction,
  }) : _actions = actions {

    _entryType = getEntryType(
      transaction: initialTransaction,
      serialTransaction: initialSerialTransaction,
    );

    if (_entryType == EntryType.unknown) {
      _viewState = EnterScreenViewState.selectEntryType;
    } else {
      _viewState = EnterScreenViewState.enter;
    }
    // No _selectedRepeatInfo for transactions
  }

  factory EnterScreenViewModel.empty(
      BuildContext context, {
        required EnterScreenActions actions,
  }) {
    return EnterScreenViewModel._(
      context,
      actions: actions,
    );
  }

  factory EnterScreenViewModel.fromTransaction(
      BuildContext context, {
        required Transaction transaction,
        required EnterScreenActions actions,
  }) {
    return EnterScreenViewModel._(
      context,
      initialTransaction: transaction,
      actions: actions,
    );
  }

  factory EnterScreenViewModel.fromSerialTransaction(
      BuildContext context, {
        required SerialTransaction serialTransaction,
        required EnterScreenActions actions,
  }) {
    return EnterScreenViewModel._(
      context,
      initialSerialTransaction: serialTransaction,
      actions: actions,
    );
  }

  void next(
      EnterScreenData data,
      DefaultValues defaultValues,
      SerialTransaction? serialTransaction,
  ) {
    _formResult = data;


    if (serialTransaction == null) {
      save();
      return;
    }
    viewState = EnterScreenViewState.selectChangeMode;
    return;
  }

  void save() {
    _actions.save(
      data: _formResult,
      defaultData: _defaultValues,
      entryType: _entryType,
      existingId: initialTransaction?.id,
      existingSerialId: initialSerialTransaction?.id,
    );
  }

  void selectEntryType(EntryType entryType) {
    _entryType = entryType;
    viewState = EnterScreenViewState.enter;
  }

  void selectChangeModeType(SerialTransactionChangeMode changeMode) {
    _actions.save(
      data: _formResult,
      defaultData: _defaultValues,
      entryType: _entryType,
      changeMode: changeMode,
      existingId: initialTransaction?.id,
      existingSerialId: initialSerialTransaction?.id,
    );
  }

  void delete() {
    _actions.delete(
      transaction: initialTransaction,
      serialTransaction: initialSerialTransaction,
    );
  }
}


