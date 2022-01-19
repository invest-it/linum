import 'package:flutter/material.dart';

class EnterScreenProvider with ChangeNotifier {
  bool _isExpenses = true;
  bool _isIncome = false;
  bool _isTransaction = false;
  String _name = "";
  num _amount;
  String _category = "";
  String _currency = "";
  String _repeat = "Niemals";
  DateTime _selectedDate = DateTime.now();

  final _formKey = GlobalKey<FormState>();

  EnterScreenProvider({
    num amount = 1.0,
    String category = "",
  })  : _amount = amount,
        _category = category;
  //amount: amount, category: category, currency: currency, name: name, time: time

  setIsExpenses(bool isExpenses) {
    _isExpenses = isExpenses;
    notifyListeners();
  }

  setIsIncome(bool isIncome) {
    _isIncome = isIncome;
    notifyListeners();
  }

  setIsTransaction(bool isTransaction) {
    _isTransaction = isTransaction;
    notifyListeners();
  }

  setName(String name) {
    _name = name;
    notifyListeners();
  }

  setAmount(double amount) {
    _amount = amount;
    notifyListeners();
  }

  setCategory(String category) {
    _category = category;
    notifyListeners();
  }

  setCurrency(String currency) {
    _currency = currency;
    notifyListeners();
  }

  setSelectedDate(DateTime selectedDate) {
    _selectedDate = selectedDate;
    notifyListeners();
  }

  setRepeat(String repeat) {
    _repeat = repeat;
    notifyListeners();
  }

  get isExpenses {
    return _isExpenses;
  }

  get isIncome {
    return _isIncome;
  }

  get isTransaction {
    return _isTransaction;
  }

  get name {
    return _name;
  }

  get amount {
    return _amount;
  }

  get category {
    return _category;
  }

  get currency {
    return _currency;
  }

  get selectedDate {
    return _selectedDate;
  }

  get formKey {
    return _formKey;
  }

  get repeat {
    return _repeat;
  }
}
