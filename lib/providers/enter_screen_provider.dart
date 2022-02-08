import 'package:flutter/material.dart';

class EnterScreenProvider with ChangeNotifier {
  late bool _isExpenses;
  late bool _isIncome;
  late bool _isTransaction;
  String _name = "";
  late num _amount;
  String _expenseCategory = "";
  String _incomeCategory = "";
  String _currency = "";
  String _repeat = "Niemals";
  DateTime _selectedDate = DateTime.now();
  Duration? _repeatDuration;
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
    Duration? repeatDuration,
  }) {
    _amount = amount <= 0 ? -1 * amount : amount;
    _expenseCategory = amount <= 0 ? category : secondaryCategory;
    _incomeCategory = amount > 0 ? category : secondaryCategory;
    _name = name;
    _repeat = repeat;
    _currency = currency;
    _editMode = editMode;
    _selectedDate = selectedDate ?? DateTime.now();
    _isExpenses = amount <= 0;
    _repeatDuration = repeatDuration;
    _isIncome = !_isExpenses;
    _isTransaction = false;
    _formerId = id;
  }
  //amount: amount, category: category, currency: currency, name: name, time: time

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

  void setRepeat(String repeat) {
    _repeat = repeat;
    notifyListeners();
  }

  void setRepeatDuration(Duration? repeatDuration) {
    _repeatDuration = repeatDuration;
    notifyListeners();
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

  String get repeat {
    return _repeat;
  }

  Duration? get repeatDuration {
    return _repeatDuration;
  }

  bool get editMode {
    return _editMode;
  }

  String? get formerId {
    return _formerId;
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
}
