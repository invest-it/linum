import 'package:flutter/material.dart';

class OnboardingScreenProvider extends ChangeNotifier {
  int _pageState = 0;
  String _mailInput = "";
  bool _hasPageChanged = false;

  /// States: 0 = normal onboarding, 1 = login page, 2 = register page
  void setPageState(int newState) {
    if (newState != _pageState) {
      _hasPageChanged = true;
    }
    _pageState = newState;
    notifyListeners();
  }

  bool get hasPageChanged {
    final bool _pageChangeTemp = _hasPageChanged;
    _hasPageChanged = false;
    return _pageChangeTemp;
  }

  int get pageState => _pageState;

  ///Email Address of the Login Controller.
  void setEmailLoginInputSilently(String newMail) {
    _mailInput = newMail;
  }

  String get mailInput {
    //Getter only works for one time, after that the "cache" is cleared.
    final String _tempMail = _mailInput;
    _mailInput = "";
    return _tempMail;
  }
}
