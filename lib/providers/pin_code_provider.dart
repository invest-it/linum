import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PinCodeProvider extends ChangeNotifier {
  String _code = '';
  int _pinSlot = 0;
  Color ringColor = Color(0XFF279E44);

  void addDigit(int digit) {
    if (_code.length < 4) {
      _code = _code + digit.toString();
      log(_code);
      _pinSlot++;
      ringColor = Color(0XFF279E44);
      notifyListeners();

      //if code # is complete, check if it is correct
      if (_code.length == 4) checkCode(_code);
    }
  }

  void checkCode(String _inputCode) {
    // TODO handle case in which the code is actually correct
    wrongCode();
  }

  void removeLastDigit() {
    if (_code.length > 0) {
      _code = _code.substring(0, _code.length - 1);
      log(_code);
      _pinSlot--;
      notifyListeners();
    }
  }

  void wrongCode() {
    HapticFeedback.vibrate();
    ringColor = Color(0XFFEB5757);
    Fluttertoast.showToast(msg: "Wrong Code");
    emptyCode();
  }

  void emptyCode() {
    _code = '';
    _pinSlot = 0;
    notifyListeners();
  }

  int get pinSlot => _pinSlot;
}
