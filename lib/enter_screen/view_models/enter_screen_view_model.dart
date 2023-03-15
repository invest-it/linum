import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:flutter/material.dart';
import 'package:linum/constants/standard_categories.dart';
import 'package:linum/constants/standard_currencies.dart';
import 'package:linum/constants/standard_repeat_configs.dart';
import 'package:linum/enter_screen/enums/repeat_interval.dart';
import 'package:linum/enter_screen/view_models/enter_screen_view_model_data.dart';
import 'package:linum/models/category.dart';
import 'package:linum/models/currency.dart';
import 'package:linum/models/repeat_configuration.dart';
import 'package:linum/models/transaction.dart';

typedef OnSaveCallback = void Function({Transaction? transaction});
// TODO: Add SerialTransaction
void _onSaveDefault({Transaction? transaction}) {}

class EnterScreenViewModel extends ChangeNotifier {
  late String? _transactionId;
  late OnSaveCallback _onSave;

  late final EnterScreenViewModelData data;

  late num _defaultAmount;
  late String _defaultName;
  late Currency _defaultCurrency;
  late Category? _defaultCategory;
  late String _defaultDate;
  late RepeatConfiguration _defaultRepeatInfo;

  EnterScreenViewModel._(
    BuildContext context, {
    OnSaveCallback onSave = _onSaveDefault,
    Transaction? transaction,
  }) {
    _transactionId = transaction?.id;
    _onSave = onSave;

    _defaultName = "";
    _defaultAmount = 0;
    _defaultCurrency = standardCurrencies["EUR"]!;
    _defaultDate = DateTime.now().toIso8601String();
    _defaultCategory = null;
    _defaultRepeatInfo = repeatConfigurations[RepeatInterval.none]!;

    data = EnterScreenViewModelData(
      notifyListeners,
      name: transaction?.name,
      amount: transaction?.amount,
      currency: standardCurrencies[transaction?.currency],
      date: transaction?.time.toDate().toIso8601String(),
      category: standardCategories[transaction?.category],
    );
    // No _selectedRepeatInfo for transactions
  }

  factory EnterScreenViewModel.empty(BuildContext context) {
    return EnterScreenViewModel._(context);
  }

  factory EnterScreenViewModel.fromTransaction(
    BuildContext context,
    Transaction transaction,
  ) {
    return EnterScreenViewModel._(
      context,
      transaction: transaction,
    );
  }

  num get amount => data.amount ?? _defaultAmount;
  String get name => data.name ?? _defaultName;
  Currency get currency => data.currency ?? _defaultCurrency;
  Category? get category => data.category ?? _defaultCategory;
  String get date => data.date ?? _defaultDate;
  RepeatConfiguration get repeatInfo =>
      data.repeatConfiguration ?? _defaultRepeatInfo;

  void save() {
    if (repeatInfo.interval != RepeatInterval.none) {
      return;
    }

    final transaction = Transaction(
      id: _transactionId,
      amount: amount,
      currency: currency.name,
      name: name,
      time: firestore.Timestamp.fromDate(DateTime.parse(date)),
      category: category?.id,
    );

    _onSave(transaction: transaction);
  }
}
