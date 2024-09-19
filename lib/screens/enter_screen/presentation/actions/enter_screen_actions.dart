import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/core/balance/domain/enums/serial_transaction_change_type_enum.dart';
import 'package:linum/core/balance/domain/models/serial_transaction.dart';
import 'package:linum/core/balance/domain/models/transaction.dart';
import 'package:linum/core/repeating/enums/repeat_interval.dart';
import 'package:linum/screens/enter_screen/presentation/actions/action_callbacks.dart';
import 'package:linum/screens/enter_screen/presentation/models/default_values.dart';
import 'package:linum/screens/enter_screen/presentation/models/enter_screen_data.dart';

class EnterScreenActions {
  final OnSaveCallback _onSave;
  final OnDeleteCallback? _onDelete;

  EnterScreenActions({
    required OnSaveCallback onSave,
    OnDeleteCallback? onDelete,
  }) : _onSave = onSave, _onDelete = onDelete;

  void save({
    required EnterScreenData? data,
    required DefaultValues? defaultData,
    required EntryType entryType,
    SerialTransactionChangeMode? changeMode,
    String? existingId,
    String? existingSerialId,
  }) {
    if (data == null || defaultData == null) {
      return;
    }

    final selectedAmount = data.amount ?? defaultData.amount;
    final amount = entryType == EntryType.expense
        && !selectedAmount.isNegative
        ? -selectedAmount
        : selectedAmount;

    final category = entryType == EntryType.expense
        ? data.category ?? defaultData.expenseCategory
        : data.category ?? defaultData.incomeCategory;

    if (data.repeatConfiguration != null
        && data.repeatConfiguration?.interval != RepeatInterval.none) {
      final serialTransaction = SerialTransaction(
        id: existingSerialId,
        amount: amount,
        category: category.id,
        currency: data.currency?.name ?? defaultData.currency.name,
        name: data.name ?? defaultData.name,
        note: data.notes,
        startDate: DateTime.parse(data.date ?? defaultData.date),
        repeatDuration: data.repeatConfiguration!.duration!,
        repeatDurationType: data.repeatConfiguration!.durationType!,
        // This is not null because only RepeatInterval.none holds a null duration value
      );
      _onSave(serialTransaction: serialTransaction, changeMode: changeMode);
      return;
    }

    final transaction = Transaction(
      id: existingId,
      amount: amount,
      currency: data.currency?.name ?? defaultData.currency.name,
      name: data.name ?? defaultData.name,
      date:  DateTime.parse(data.date ?? defaultData.date),
      category: category.id,
      note: data.notes,
    );
    _onSave(transaction: transaction);
  }


  void delete({
    Transaction? transaction,
    SerialTransaction? serialTransaction,
    SerialTransactionChangeMode? changeMode,
  }) {
    if (_onDelete == null) {
      return;
    }
    _onDelete!(
      transaction: transaction,
      serialTransaction: serialTransaction,
      changeMode: changeMode,
    );
  }

  void selectEntryType() {

  }

  void selectChangeType() {

  }
}
