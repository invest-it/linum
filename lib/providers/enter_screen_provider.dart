import 'package:flutter/material.dart';

class EnterScreenProvider with ChangeNotifier {
  bool _isExpenses = true;
  bool _isIncome = false;
  bool _isTransaction = false;

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

  get isExpenses {
    return _isExpenses;
  }

  get isIncome {
    return _isIncome;
  }

  get isTransaction {
    return _isTransaction;
  }
}
