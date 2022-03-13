import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:linum/providers/screen_index_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinCodeProvider extends ChangeNotifier {
  //TODO turn this off. This should not be active by default, but as long as the switch in settings_screen isn't implemented, there is no other way of turning the feature on.
  bool _pinActive = true;
  String _code = '';
  int _pinSlot = 0;
  Color _ringColor = Color(0XFF279E44);
  late ScreenIndexProvider _screenIndexProvider;

  PinCodeProvider(BuildContext context) {
    _screenIndexProvider = Provider.of<ScreenIndexProvider>(
      context,
      listen: false,
    );
  }

  updateScreenIndexProvider(ScreenIndexProvider screenIndexProvider) {
    _screenIndexProvider = screenIndexProvider;
  }

  // If the intent of the PIN lock is not set before the screen is called, assume that we want to check whether user knows the code (classic recall)
  PINLockIntent _intent = PINLockIntent.RECALL;

  // ACTIVATION & SETTINGS - Toggles the PIN Lock in the settingsScreen

  ///Activates - Deactivates the PIN Lock
  void togglePINLock() {
    if (pinActive == false) {
      _pinActive = true;
      //Force the user to initialize their PIN number every time the PIN is (re-)activated.
      setPINLockIntent(intent: PINLockIntent.INITIALIZE);
      _screenIndexProvider.setPageIndex(5);
    } else {
      _pinActive = false;
      removePIN();
      Fluttertoast.showToast(msg: "Die PIN-Sperre wurde deaktiviert.");
    }
    notifyListeners();
  }

  /// Toggles a PIN change request
  void changePINLock() {
    setPINLockIntent(intent: PINLockIntent.CHANGE);
    _screenIndexProvider.setPageIndex(5);
  }

  // PERSISTENCE - stores a (new) PIN number in the device storage, probably sharedPreferences

  /// Stores a new value for the PIN on the device
  void storePIN(String code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('applock', code);
  }

  /// Deletes the currently stored value for the PIN on the device
  void removePIN() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('applock');
  }

  // INTENTION - provides the "style" of the PIN lock depending of the system intent

  void setPINLockIntent({required PINLockIntent intent}) {
    _intent = intent;
  }

  Map<String, dynamic> recallPINLockIntent() {
    switch (_intent) {
      case PINLockIntent.INITIALIZE:
        return {
          "label-title": "Wähle eine PIN",
          "label-action": "Abbrechen",
          "action": () {
            log("Back to Settings Screen");
          }
        };
      case PINLockIntent.CHANGE:
        return {
          "label-title": "Wähle eine neue PIN",
          "label-action": "Abbrechen",
          "action": () {
            log("Back to Settings Screen");
          }
        };
      case PINLockIntent.RECALL:
        return {
          "label-title": "Bitte PIN eingeben",
          "label-action": "Abmelden",
          "action": () {
            log("Log out and turn off PIN");
          }
        };
    }
  }

  // RECALL - Handles the Code Check

  /// Adds the desired digit to the [_code] variable and checks automatically if the [_code] matches the stored PIN when 4 digits are reached.
  void addDigit(int digit) {
    if (_code.length < 4) {
      _code = _code + digit.toString();
      log(_code);
      _pinSlot++;
      _ringColor = Color(0XFF279E44);
      notifyListeners();

      //if code # is complete, check if it is correct
      if (_code.length == 4)
        switch (_intent) {
          case PINLockIntent.INITIALIZE:
            storePIN(_code);
            Fluttertoast.showToast(
                msg: "Du hast deine PIN erfolgreich aktiviert!");
            _screenIndexProvider.setPageIndex(3);
            break;
          case PINLockIntent.CHANGE:
            storePIN(_code);
            Fluttertoast.showToast(
                msg: "Du hast deine PIN erfolgreich geändert!");
            _screenIndexProvider.setPageIndex(3);
            break;
          case PINLockIntent.RECALL:
            checkCode(_code);
            break;
        }
    }
  }

  /// If there is at least one digit in the [_code] input variable, remove the last character.
  void removeLastDigit() {
    if (_code.length > 0) {
      _code = _code.substring(0, _code.length - 1);
      log(_code);
      _pinSlot--;
      notifyListeners();
    }
  }

  /// Check if the current value of [_code] matches the locally stored PIN.
  void checkCode(String _inputCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('applock') == _code) {
      correctCode();
    } else
      wrongCode();
  }

  // RESULTS - After-Recall routing

  /// Set the page index to 0 - "welcome to the app"
  void correctCode() {
    emptyCode();
    _screenIndexProvider.setPageIndex(0);
  }

  /// Reset [_code] and give visual and haptic feedback that the code did not match the locally stored PIN.
  void wrongCode() {
    // TODO test this on a physical device (it goes without saying that I cannot verify this feature on an emulator)
    HapticFeedback.vibrate();
    _ringColor = Color(0XFFEB5757);
    Fluttertoast.showToast(msg: "Wrong Code");
    emptyCode();
  }

  /// Resets the current value of [_code] to an empty String.
  void emptyCode() {
    _code = '';
    _pinSlot = 0;
    notifyListeners();
  }

  int get pinSlot => _pinSlot;
  Color get ringColor => _ringColor;
  bool get pinActive => _pinActive;
}

enum PINLockIntent {
  INITIALIZE,
  CHANGE,
  RECALL,
}
