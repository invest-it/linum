import 'package:flutter/material.dart';
import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/core/balance/enums/serial_transaction_change_type_enum.dart';
import 'package:linum/core/balance/models/serial_transaction.dart';
import 'package:linum/core/balance/models/transaction.dart';
import 'package:linum/screens/enter_screen/presentation/actions/enter_screen_actions.dart';
import 'package:linum/screens/enter_screen/presentation/enums/edit_intention.dart';
import 'package:linum/screens/enter_screen/presentation/enums/enter_screen_view_state.dart';
import 'package:linum/screens/enter_screen/presentation/models/default_values.dart';
import 'package:linum/screens/enter_screen/presentation/models/enter_screen_data.dart';
import 'package:linum/screens/enter_screen/presentation/models/enter_screen_form_data.dart';
import 'package:linum/screens/enter_screen/presentation/utils/get_entry_type.dart';


class EnterScreenViewModel extends ChangeNotifier {
  final Transaction? initialTransaction;
  final SerialTransaction? initialSerialTransaction;
  final SerialTransaction? parentalSerialTransaction;
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

  EditIntention _intention = EditIntention.save;
  EditIntention get intention => _intention;


  EnterScreenData? _data;
  DefaultValues? _defaultValues;

  EnterScreenViewModel._({
      required EnterScreenActions actions,
      this.initialTransaction,
      this.initialSerialTransaction,
      this.parentalSerialTransaction,
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
      {
        required EnterScreenActions actions,
  }) {
    return EnterScreenViewModel._(
      actions: actions,
    );
  }

  factory EnterScreenViewModel.fromTransaction(
      {
        required Transaction transaction,
        required SerialTransaction? parentalSerialTransaction,
        required EnterScreenActions actions,
  }) {
    return EnterScreenViewModel._(
      initialTransaction: transaction,
      parentalSerialTransaction: parentalSerialTransaction,
      actions: actions,
    );
  }

  factory EnterScreenViewModel.fromSerialTransaction(
      {
        required SerialTransaction serialTransaction,
        required EnterScreenActions actions,
  }) {
    return EnterScreenViewModel._(
      initialSerialTransaction: serialTransaction,
      actions: actions,
    );
  }

  void next({
    required EnterScreenFormData data,
    required DefaultValues defaultValues,
  }) {
    _data = EnterScreenData.fromFormData(data);
    _defaultValues = defaultValues;

    if (parentalSerialTransaction == null && initialSerialTransaction == null) {
      save();
      return;
    }
    viewState = EnterScreenViewState.selectChangeMode;
    return;
  }

  void save() {
    _actions.save(
      data: _data,
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
    switch(_intention) {
      case EditIntention.save:
        _actions.save(
          data: _data,
          defaultData: _defaultValues,
          entryType: _entryType,
          changeMode: changeMode,
          existingId: initialTransaction?.id,
          existingSerialId: initialSerialTransaction?.id ?? parentalSerialTransaction?.id,
        );
      case EditIntention.delete:
        _actions.delete(
          transaction: initialTransaction,
          serialTransaction: initialSerialTransaction ?? parentalSerialTransaction,
          changeMode: changeMode,
        );
    }
  }

  void delete() {
    if (parentalSerialTransaction == null) {
      _actions.delete(
        transaction: initialTransaction,
        serialTransaction: initialSerialTransaction,
      );
      return;
    }
    _intention = EditIntention.delete;
    viewState = EnterScreenViewState.selectChangeMode;

  }
}
