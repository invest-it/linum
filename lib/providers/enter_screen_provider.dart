import 'package:flutter/material.dart';
import 'package:linum/models/repeat_duration_type_enum.dart';
import 'package:linum/providers/account_settings_provider.dart';

class EnterScreenProvider with ChangeNotifier {
  late bool _isExpenses;
  late bool _isIncome;
  late bool _isTransaction;
  String _name = "";
  late num _amount;
  String _expenseCategory = "";
  String _incomeCategory = "";
  String _currency = "";
  DateTime _selectedDate = DateTime.now();
  int? _repeatDuration;
  RepeatDurationType? _repeatDurationType;
  late RepeatDuration _repeatDurationEnum;

  late bool _editMode;
  String? _formerId;

  EnterScreenProvider({
    num amount = 0.0,
    String category = "None",
    String name = "",
    String repeat = "",
    String currency = "",
    String secondaryCategory = "None",
    DateTime? selectedDate,
    bool editMode = false,
    String? id,
    int? repeatDuration,
    RepeatDurationType? repeatDurationType,
    RepeatDuration initRepeatDurationEnum = RepeatDuration.NONE,
  }) {
    _amount = amount <= 0 ? -1 * amount : amount;
    _expenseCategory = amount <= 0 ? category : secondaryCategory;
    _incomeCategory = amount > 0 ? category : secondaryCategory;
    _name = name;
    _currency = currency;
    _editMode = editMode;
    _selectedDate = selectedDate ?? DateTime.now();
    _isExpenses = amount <= 0;
    _repeatDuration = repeatDuration;
    _isIncome = !_isExpenses;
    _isTransaction = false;
    _formerId = id;
    _repeatDurationEnum = initRepeatDurationEnum;
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

  RepeatDuration get repeatDurationEnum {
    return _repeatDurationEnum;
  }

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
}
