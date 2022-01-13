import 'package:flutter/material.dart';

class EnterScreenProvider with ChangeNotifier {
  bool _isExpenses = true;
  bool _isIncome = false;
  bool _isTransaction = false;
  String _name = "";
  double _amount = 0.0;
  String _category = "";
  String _currency = "";
  DateTime _selectedDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();
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
}
