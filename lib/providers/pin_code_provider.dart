import 'dart:developer';

import 'package:flutter/cupertino.dart';

class PinCodeProvider extends ChangeNotifier {
  String _code = '';
  int _pinSlot = 0;

  void addDigit(int digit) {
    if (_code.length < 4) {
      _code = _code + digit.toString();
      log(_code);
      _pinSlot++;
      notifyListeners();
    }
  }

  void removeLastDigit() {
    if (_code != null && _code.length > 0) {
      _code = _code.substring(0, _code.length - 1);
      log(_code);
      _pinSlot--;
      notifyListeners();
    }
  }

  int get pinSlot => _pinSlot;
}
