import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:linum/constants/ring_colors.dart';
import 'package:linum/models/dialog_action.dart';
import 'package:linum/models/lock_screen_action.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:linum/providers/screen_index_provider.dart';
import 'package:linum/utilities/backend/local_app_localizations.dart';
import 'package:linum/utilities/frontend/user_alert.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinCodeProvider extends ChangeNotifier {
  String _code = '';
  int _pinSlot = 0;
  Color _ringColor = RingColors.green;
  bool _sessionIsSafe = false;
  late BuildContext _context;
  late ScreenIndexProvider _screenIndexProvider;
  late AuthenticationService _auth;
  late UserAlert confirmKillswitch;
  late bool _pinActive;
  String? _lastEmail;
  bool _pinActiveStillLoading = true;
  bool _lastEmailStillLoading = true;

  PinCodeProvider(BuildContext context) {
    _initialLastEmail();
    initialIsPINActive();
    _screenIndexProvider = Provider.of<ScreenIndexProvider>(
      context,
      listen: false,
    );
    _auth = Provider.of<AuthenticationService>(
      context,
      listen: false,
    );
    _context = context;
    confirmKillswitch = UserAlert(context: _context);
  }

  Future<void> initialIsPINActive() async {
    _pinActive = await _isPinActive();
    // dev.log(
    //   _pinActive
    //       ? "PIN lock is active for $_lastEmail"
    //       : "PIN lock is NOT ACTIVE for $_lastEmail",
    // );
    _pinActiveStillLoading = false;

    //Set Session to Safe if there is no PIN lock
    if (!_pinActive) {
      _sessionIsSafe = true;
    }
    if (_auth.uid == "") {
      _sessionIsSafe = false;
    }
  }

  Future<void> _initialLastEmail() async {
    _lastEmail = await _getLastEmail();
    _lastEmailStillLoading = false;
  }

  void updateSipAndAuth(BuildContext context) {
    _lastEmail = null;
    _lastEmailStillLoading = true;
    _initialLastEmail();
    initialIsPINActive();
    _screenIndexProvider = Provider.of<ScreenIndexProvider>(
      context,
      listen: false,
    );

    _auth = Provider.of<AuthenticationService>(context);

    _context = context;
  }

  // If the intent of the PIN lock is not set before the screen is called, assume that we want to check whether user knows the code (classic recall)
  PINLockIntent _intent = PINLockIntent.recall;

  // ACTIVATION & SETTINGS - Toggles the PIN Lock in the settingsScreen

  ///Activates - Deactivates the PIN Lock
  //TODO - change the switch condition of _pinActive into one that relies on whether _lastEmail + '.code' has a value in sharedPreferences
  void togglePINLock() {
    if (pinActive == false) {
      _sessionIsSafe = true;
      _pinActive = true;
      //Force the user to initialize their PIN number every time the PIN is (re-)activated.
      _setPINLockIntent(intent: PINLockIntent.initialize);
      _screenIndexProvider.setPageIndex(5);
    } else {
      _pinActive = false;
      _removePIN();
      Fluttertoast.showToast(
        msg: AppLocalizations.of(_context)!
            .translate("lock_screen/toast-pin-deactivated"),
      );
    }
    notifyListeners();
  }

  ///Returns the PIN status based on whether a PIN code is currently being stored in sharedPreferences
  Future<bool> _isPinActive() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    while (_lastEmailStillLoading) {
      await Future.delayed(
        const Duration(milliseconds: 10),
      );
    }
    return prefs.containsKey('${_lastEmail!}.code');
  }

  ///Returns the last email that has been used for login stored in sharedPreferences
  Future<String> _getLastEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('lastMail') ?? 'Error!';
  }

  /// Toggles a PIN change request
  void triggerPINChange() {
    _setPINLockIntent(intent: PINLockIntent.change);
    _screenIndexProvider.setPageIndex(5);
  }

  /// Triggers a PIN recall
  void triggerPINRecall() {
    _screenIndexProvider.setPageIndexSilently(5);
    _setPINLockIntent(intent: PINLockIntent.recall);
  }

  // PERSISTENCE - stores a (new) PIN number in the device storage, probably sharedPreferences

  /// Stores a new value for the PIN on the device
  Future<void> _storePIN(String code) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    log(_lastEmail ?? "No mail found"); // TODO: Remove
    log(code);
    prefs.setString('${_lastEmail!}.code', code);
    // dev.log(
    //   prefs.getString('${_lastEmail!}.code') ??
    //       "ERROR: No String stored in prefs!!!",
    // );
    // dev.log("PIN HAS BEEN STORED!");
    _sessionIsSafe = true;
  }

  /// Deletes the currently stored value for the PIN on the device
  Future<void> _removePIN() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('${_lastEmail!}.code');
  }

  // INTENT - provides the "style" of the PIN lock depending of the system intent
  // the function recallPINLockIntent() provides the lock screen with all information about the labels, as well as the action to be performed
  // when the bottom button, aka. "killswitch" is pressed

  void _setPINLockIntent({required PINLockIntent intent}) {
    _intent = intent;
  }

  LockScreenAction recallPINLockIntent() {
    switch (_intent) {
      case PINLockIntent.initialize:
        return LockScreenAction(
          screenTitle: "lock_screen/initialize/label-title",
          actionTitle: "lock_screen/initialize/label-button",
          function: () {
            confirmKillswitch.showMyActionDialog(
              "alertdialog/killswitch-initialize/message",
              [
                DialogAction(
                  actionTitle: "alertdialog/killswitch-initialize/action",
                  function: () {
                    _emptyCode();
                    _removePIN();
                    _pinActive = false;
                    _screenIndexProvider.setPageIndex(3);
                    Navigator.of(_context).pop();
                  },
                ),
                DialogAction(
                  actionTitle: "alertdialog/killswitch-initialize/cancel",
                  //If this is empty, UserAlert will use its own context to pop the dialog
                  function: () {
                    Navigator.of(_context).pop();
                  },
                  dialogPurpose: DialogPurpose.secondary,
                  popDialog: true,
                ),
              ],
              title: "alertdialog/killswitch-initialize/title",
            );
          },
        );
      case PINLockIntent.change:
        return LockScreenAction(
          screenTitle: "lock_screen/change/label-title",
          actionTitle: "lock_screen/change/label-button",
          function: () {
            confirmKillswitch.showMyActionDialog(
              "alertdialog/killswitch-change/message",
              [
                DialogAction(
                  actionTitle: "alertdialog/killswitch-change/action",
                  function: () {
                    _emptyCode();
                    _screenIndexProvider.setPageIndex(3);
                    Navigator.of(_context).pop();
                  },
                ),
                DialogAction(
                  actionTitle: "alertdialog/killswitch-change/cancel",
                  //If this is empty, UserAlert will use its own context to pop the dialog
                  function: () {
                    Navigator.of(_context).pop();
                  },
                  dialogPurpose: DialogPurpose.secondary,
                  popDialog: true,
                ),
              ],
              title: "alertdialog/killswitch-change/title",
            );
          },
        );
      case PINLockIntent.recall:
        return LockScreenAction(
          screenTitle: "lock_screen/recall/label-title",
          actionTitle: "lock_screen/recall/label-button",
          function: () {
            confirmKillswitch.showMyActionDialog(
              "alertdialog/killswitch-recall/message",
              [
                DialogAction(
                  actionTitle: "alertdialog/killswitch-recall/action",
                  function: () {
                    togglePINLock();
                    _auth.signOut().then((_) {
                      Provider.of<ScreenIndexProvider>(_context, listen: false)
                          .setPageIndex(0);
                      Navigator.of(_context).pop();
                    });
                  },
                ),
                DialogAction(
                  actionTitle: "alertdialog/killswitch-recall/cancel",
                  //If this is empty, UserAlert will use its own context to pop the dialog
                  function: () {
                    Navigator.of(_context).pop();
                  },
                  dialogPurpose: DialogPurpose.secondary,
                  popDialog: true,
                ),
              ],
              title: "alertdialog/killswitch-recall/title",
            );
          },
        );
    }
  }

  // RECALL - Handles the Code Check

  /// Adds the desired digit to the [_code] variable and checks automatically if the [_code] matches the stored PIN when 4 digits are reached.
  void addDigit(int digit) {
    if (_code.length < 4) {
      _code = _code + digit.toString();
      // log(_code);
      _pinSlot++;
      _ringColor = RingColors.green;
      //if code # is complete, check if it is correct
      // is not an invariant boolean
      // ignore: invariant_booleans
      if (_code.length == 4) {
        switch (_intent) {
          case PINLockIntent.initialize:
            if (_lastEmail != 'Error!') {
              _storePIN(_code);
              toastFromTranslationKey("lock_screen/toast-pin-set");
            } else {
              toastFromTranslationKey("lock_screen/errors/last-mail-missing");
            }

            _screenIndexProvider.setPageIndex(3);
            _emptyCode();
            break;
          case PINLockIntent.change:
            if (_lastEmail != 'Error!') {
              _storePIN(_code);
              toastFromTranslationKey("lock_screen/toast-pin-changed");
            } else {
              toastFromTranslationKey("lock_screen/errors/last-mail-missing");
            }

            _screenIndexProvider.setPageIndex(3);
            _emptyCode();
            break;
          case PINLockIntent.recall:
            _checkCode(_code);
            _emptyCode();
            break;
        }
      }
      notifyListeners();
    }
  }

  void toastFromTranslationKey(String key) {
    Fluttertoast.showToast(
      msg: AppLocalizations.of(_context)!
          .translate(key),
    );
  }

  /// If there is at least one digit in the [_code] input variable, remove the last character.
  void removeLastDigit() {
    if (_code.isNotEmpty) {
      _code = _code.substring(0, _code.length - 1);
      // log(_code);
      _pinSlot--;
      notifyListeners();
    }
  }

  /// Check if the current value of [_code] matches the locally stored PIN.
  Future<void> _checkCode(String _inputCode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String _pin = prefs.getString('${_lastEmail!}.code') ?? 'ERROR';
    // dev.log("pin:$_pin");
    if (_pin == _inputCode) {
      _correctCode();
    } else {
      _wrongCode();
    }
  }

  // RESULTS - After-Recall routing

  /// Set the page index to 0 - "welcome to the app"
  void _correctCode() {
    _sessionIsSafe = true;
    _screenIndexProvider.setPageIndex(0);
  }

  /// Reset [_code] and give visual and haptic feedback that the code did not match the locally stored PIN.
  void _wrongCode() {
    HapticFeedback.vibrate();
    _ringColor = RingColors.red;
    Fluttertoast.showToast(
      msg: AppLocalizations.of(_context)!
          .translate("lock_screen/toast-wrong-code"),
    );
    _emptyCode();
  }

  /// Resets the current value of [_code] to an empty String.
  void _emptyCode() {
    _code = '';
    _pinSlot = 0;
    notifyListeners();
  }

  /// Resets session
  void resetSession() {
    if (_pinActive) {
      _sessionIsSafe = false;
      notifyListeners();
    } else {
      // dev.log(
      //   "No PIN code is active, therefore the session will not be reset.",
      // );
    }
  }

  bool get sessionIsSafe => _sessionIsSafe;
  int get pinSlot => _pinSlot;
  Color get ringColor => _ringColor;
  bool get pinActive => !_pinActiveStillLoading && _pinActive;
  //TODO decide whether we should leave "Loading..." blank in shipping
  String get lastEmail => !_lastEmailStillLoading ? _lastEmail! : 'Loading...';
  bool get pinActiveStillLoading => _pinActiveStillLoading;
  bool get lastEmailStillLoading => _lastEmailStillLoading;
}

enum PINLockIntent {
  initialize,
  change,
  recall,
}
