//  Onboarding Screen Provider - Handles Operation and information exchange on the Onboarding Screen
//
//  Author: NightmindOfficial
//  Co-Author: damattl
//  (Refactored)

import 'package:flutter/material.dart';
import 'package:linum/screens/onboarding_screen/enums/onboarding_page_state.dart';


class OnboardingScreenViewModel extends ChangeNotifier {
  final slideController = PageController();
  int _currentSlide = 0;

  OnboardingPageState _pageState = OnboardingPageState.none;
  String _mailInput = "";
  bool _hasPageChanged = false;

  /// States: 0 = normal onboarding, 1 = login page, 2 = register page
  void setPageState(OnboardingPageState newState) {
    if (newState != _pageState) {
      _hasPageChanged = true;
    }
    _pageState = newState;
    notifyListeners();
  }

  bool get hasPageChanged {
    final bool pageChangeTemp = _hasPageChanged;
    _hasPageChanged = false;
    return pageChangeTemp;
  }

  OnboardingPageState get pageState => _pageState;

  ///Email Address of the Login Controller.
  void setEmailLoginInputSilently(String newMail) {
    _mailInput = newMail;
  }

  String get mailInput {
    // Getter only works for one time, after that the "cache" is cleared.
    final String tempMail = _mailInput;
    _mailInput = "";
    return tempMail;
  }

  int get currentSlide => _currentSlide;

  set currentSlide(int slide) {
    _currentSlide = slide;
    notifyListeners();
  }
}
