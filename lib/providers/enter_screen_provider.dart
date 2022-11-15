//  Enter Screen Provider - Handles information "grabbing" as well as operations regarding input in the Enter Screen
//
//  Author: SoTBurst
//  Co-Author: thebluebaronx
//

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:flutter/material.dart';
import 'package:linum/constants/repeat_duration_type_enum.dart';
import 'package:linum/constants/settings_enums.dart';
import 'package:linum/models/serial_transaction.dart';
import 'package:linum/models/transaction.dart';

class EnterScreenProvider with ChangeNotifier {
  late bool _isExpenses;
  late bool _isIncome;
  late bool _isTransaction;
  late num _amount;
  late DateTime _selectedDate;
  late RepeatDuration _repeatDurationEnum;
  late bool _editMode;

  String _name = "";
  String _expenseCategory = "";
  String _incomeCategory = "";
  String _currency = "";
  String? _note;
  String? _formerId;
  String? _repeatId;
  int? _repeatDuration;
  firestore.Timestamp? _formerTime;
  RepeatDurationType? _repeatDurationType;
  DateTime? _initialTime;
  DateTime? _endTime;
  bool _isSerialTransaction = false;

  EnterScreenProvider({
    num amount = 0.0,
    String category = "None",
    String name = "",
    String currency = "",
    String secondaryCategory = "None",
    DateTime? selectedDate,
    bool editMode = false,
    String? note,
    String? id,
    int? repeatDuration,
    RepeatDurationType? repeatDurationType,
    RepeatDuration initRepeatDurationEnum = RepeatDuration.none,
    String? repeatId,
    DateTime? initialTime,
    DateTime? endTime,
    bool isSerialTransaction = false,
    firestore.Timestamp? formerTime,
  }) {
    _amount = amount.abs();
    _expenseCategory = amount <= 0 ? category : secondaryCategory;
    _incomeCategory = amount > 0 ? category : secondaryCategory;
    _name = name;
    _currency = currency;
    _editMode = editMode;
    _note = note;
    _isExpenses = amount <= 0;
    _repeatDuration = repeatDuration;
    _isIncome = !_isExpenses;
    _isTransaction = false;
    _formerId = id;
    _repeatDurationEnum = initRepeatDurationEnum;
    _repeatDurationType = repeatDurationType;
    _repeatId = repeatId;
    _formerTime = formerTime;
    _selectedDate = formerTime != null ? formerTime.toDate() : DateTime.now();
    if (selectedDate != null) {
      _selectedDate = selectedDate;
    }
    _note = note;
    _isSerialTransaction = isSerialTransaction;
    _initialTime = initialTime;
    _endTime = endTime;
  }

  factory EnterScreenProvider.fromTransaction(
    Transaction transaction, {
    bool editMode = true,
  }) {
    return EnterScreenProvider(
      id: transaction.id,
      amount: transaction.amount,
      category: transaction.category,
      name: transaction.name,
      selectedDate: transaction.time.toDate(),
      editMode: editMode,
      repeatId: transaction.repeatId,
      formerTime: transaction.formerTime ?? transaction.time,
    );
  }

  factory EnterScreenProvider.fromSerialTransaction(
    SerialTransaction serialTransaction,
  ) {
    return EnterScreenProvider(
      id: serialTransaction.id,
      amount: serialTransaction.amount,
      category: serialTransaction.category,
      name: serialTransaction.name,
      editMode: true,
      isSerialTransaction: true,
      initialTime: serialTransaction.initialTime.toDate(),
      endTime: serialTransaction.endTime?.toDate(),
    );
  }

  bool get isExpenses {
    return _isExpenses;
  }

  bool get isIncome {
    return _isIncome;
  }

  bool get isTransaction {
    return _isTransaction;
  }

  String get name {
    return _name;
  }

  num get amount {
    return _amount;
  }

  String? get note {
    return _note;
  }

  String get category {
    return isExpenses ? _expenseCategory : _incomeCategory;
  }

  String get currency {
    return _currency;
  }

  DateTime get selectedDate {
    return _selectedDate;
  }

  int? get repeatDuration {
    return _repeatDuration;
  }

  RepeatDurationType? get repeatDurationTyp {
    return _repeatDurationType;
  }

  bool get editMode {
    return _editMode;
  }

  String? get formerId {
    return _formerId;
  }

  bool get isSerialTransaction {
    return _isSerialTransaction;
  }

  DateTime? get initialTime {
    return _initialTime;
  }

  DateTime? get endTime {
    return _endTime;
  }

  RepeatDuration get repeatDurationEnum {
    return _repeatDurationEnum;
  }

  String? get repeatId => _repeatId;

  firestore.Timestamp? get formerTime => _formerTime;

  void setExpense() {
    _isExpenses = true;
    _isIncome = false;
    _isTransaction = false;
    notifyListeners();
  }

  void setIncome() {
    _isExpenses = false;
    _isIncome = true;
    _isTransaction = false;
    notifyListeners();
  }

  void setTransaction() {
    _isExpenses = false;
    _isIncome = false;
    _isTransaction = true;
    notifyListeners();
  }

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void setNote(String note) {
    _note = note;
    notifyListeners();
  }

  void setAmount(double amount) {
    _amount = amount;
    notifyListeners();
  }

  void setCategory(String category) {
    if (isExpenses) {
      _expenseCategory = category;
    } else {
      _incomeCategory = category;
    }
    notifyListeners();
  }

  void setCurrency(String currency) {
    _currency = currency;
    notifyListeners();
  }

  void setSelectedDate(DateTime selectedDate) {
    _selectedDate = selectedDate;
    notifyListeners();
  }

  void setRepeatDuration(int? repeatDuration) {
    _repeatDuration = repeatDuration;
    notifyListeners();
  }

  void setRepeatDurationType(RepeatDurationType repeatDurationType) {
    _repeatDurationType = repeatDurationType;
    notifyListeners();
  }

  void setRepeatDurationEnum(RepeatDuration repeatDuration) {
    setRepeatDurationEnumSilently(repeatDuration);
    notifyListeners();
  }

  void setRepeatDurationEnumSilently(RepeatDuration repeatDuration) {
    _repeatDurationEnum = repeatDuration;
  }

  void setInitialTime(DateTime initialTime) {
    _initialTime = initialTime;
  }

  void setEndTime(DateTime? endTime) {
    _endTime = endTime;
  }

  //if the amount is entered in expenses, it's set to the negative equivalent if
  //the user did not accidentally press the minus
  num amountToDisplay() {
    if (isExpenses) {
      if (amount < 0) {
        return amount;
      } else {
        return -amount;
      }
    } else {
      return amount;
    }
  }
}
