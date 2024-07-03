//  Pin Code Provider - Complex Provider handling all States and Authentication around the PIN Lock
//
//  Author: NightmindOfficial
//  Co-Author: SoTBurst
//  (Partly refactored by damattl)

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:linum/common/components/dialogs/dialog_action.dart';
import 'package:linum/common/components/dialogs/show_action_dialog.dart';
import 'package:linum/core/authentication/domain/services/authentication_service.dart';
import 'package:linum/core/design/theme/ring_colors.dart';
import 'package:linum/core/navigation/get_delegate.dart';
import 'package:linum/core/navigation/main_routes.dart';
import 'package:linum/generated/translation_keys.g.dart';
import 'package:linum/screens/lock_screen/models/lock_screen_action.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinCodeService extends ChangeNotifier {
  String _code = '';
  int _pinSlot = 0;
  Color _ringColor = RingColors.green;
  bool _sessionIsSafe = false;
  late AuthenticationService _auth;
  late bool _pinSet;
  String? _lastEmail;
  bool _pinSetStillLoading = true;
  bool _lastEmailStillLoading = true;

  PinCodeService(
    AuthenticationService authenticationService,
  ) {
    _initializeLastEmail();
    initializeIsPINSet();
    _auth = authenticationService;
  }

  Future<void> initializeIsPINSet() async {
    _pinSet = await _isPinSet();

    _pinSetStillLoading = false;

    //Set Session to Safe if there is no PIN lock
    if (!_pinSet) {
      _sessionIsSafe = true;
    }
    if (_auth.currentUser == null) {
      _sessionIsSafe = false;
    }
  }

  Future<void> _initializeLastEmail() async {
    _lastEmail = await _getLastEmail();
    _lastEmailStillLoading = false;
  }

  // If the intent of the PIN lock is not set before the screen is called, assume that we want to check whether user knows the code (classic recall)
  PINLockIntent _intent = PINLockIntent.recall;

  // ACTIVATION & SETTINGS - Toggles the PIN Lock in the settingsScreen

  ///Activates - Deactivates the PIN Lock
  //TODO - change the switch condition of _pinSet into one that relies on whether _lastEmail + '.code' has a value in sharedPreferences
  void togglePINLock(BuildContext context) {
    if (pinSet == false) {
      _sessionIsSafe = true;
      _pinSet = true;
      //Force the user to initialize their PIN number every time the PIN is (re-)activated.
      _setPINLockIntent(intent: PINLockIntent.initialize);
      context.getMainRouterDelegate().pushRoute(MainRoute.lock);
    } else {
      _pinSet = false; // TODO: Re-Enter pin?
      _removePIN();
      Fluttertoast.showToast(
        msg: tr(translationKeys.lockScreen.toastPinDeactivated),
      );
    }
    notifyListeners();
  }

  void resetOnLogout() {
    _pinSet = false;
    _removePIN();
    notifyListeners();
  }

  ///Returns the PIN status based on whether a PIN code is currently being stored in sharedPreferences
  Future<bool> _isPinSet() async {
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
  void triggerPINChange(BuildContext context) {
    _setPINLockIntent(intent: PINLockIntent.change);
    context.getMainRouterDelegate().pushRoute(MainRoute.lock);
  }

  /*
  /// Triggers a PIN recall
  void triggerPINRecall() {
    // TODO: _screenIndexProvider.setPageIndexSilently(5);
    _setPINLockIntent(intent: PINLockIntent.recall);
  } */ // TOOD: Probably not needed anymore

  void setRecallIntent() {
    _setPINLockIntent(intent: PINLockIntent.recall);
  }

  // PERSISTENCE - stores a (new) PIN number in the device storage, probably sharedPreferences

  /// Stores a new value for the PIN on the device
  Future<void> _storePIN(String code) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('${_lastEmail!}.code', code);

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

  LockScreenAction recallPINLockIntent(BuildContext context) {
    switch (_intent) {
      case PINLockIntent.initialize:
        return LockScreenAction(
          screenTitle: translationKeys.lockScreen.initialize.labelTitle,
          actionTitle: translationKeys.lockScreen.initialize.labelButton,
          function: () {
            showActionDialog(
              context,
              message: translationKeys.alertdialog.killswitchInitialize.message,
              actions: [
                DialogAction(
                  actionTitle:
                      translationKeys.alertdialog.killswitchInitialize.action,
                  callback: () {
                    _emptyCode();
                    _removePIN();
                    _pinSet = false;
                    // Navigator.of(context, rootNavigator: true).pop();
                    context.getMainRouterDelegate().popRoute();
                  },
                ),
                DialogAction(
                  actionTitle:
                      translationKeys.alertdialog.killswitchInitialize.cancel,
                  //If this is empty, UserAlert will use its own context to pop the dialog
                  dialogPurpose: DialogPurpose.secondary,
                ),
              ],
              title: translationKeys.alertdialog.killswitchInitialize.title,
            );
          },
        );
      case PINLockIntent.change:
        return LockScreenAction(
          screenTitle: translationKeys.lockScreen.change.labelTitle,
          actionTitle: translationKeys.lockScreen.change.labelButton,
          function: () {
            showActionDialog(
              context,
              message: translationKeys.alertdialog.killswitchChange.message,
              actions: [
                DialogAction(
                  actionTitle:
                      translationKeys.alertdialog.killswitchChange.action,
                  callback: () {
                    _emptyCode();
                    context.getMainRouterDelegate().popRoute();
                    // Navigator.of(_context).pop();
                  },
                ),
                DialogAction(
                  actionTitle:
                      translationKeys.alertdialog.killswitchChange.cancel,
                  //If this is empty, UserAlert will use its own context to pop the dialog
                  dialogPurpose: DialogPurpose.secondary,
                ),
              ],
              title: translationKeys.alertdialog.killswitchChange.title,
            );
          },
        );
      case PINLockIntent.recall:
        return LockScreenAction(
          screenTitle: translationKeys.lockScreen.recall.labelTitle,
          actionTitle: translationKeys.lockScreen.recall.labelButton,
          function: () {
            showActionDialog(
              context,
              message: translationKeys.alertdialog.killswitchRecall.message,
              actions: [
                DialogAction(
                  actionTitle:
                      translationKeys.alertdialog.killswitchRecall.action,
                  callback: () {
                    _pinSet = false;
                    _removePIN();
                    _auth.signOut().then((_) {
                      context.getMainRouterDelegate().rebuild();
                    });
                  },
                ),
                DialogAction(
                  actionTitle:
                      translationKeys.alertdialog.killswitchRecall.cancel,
                  dialogPurpose: DialogPurpose.secondary,
                ),
              ],
              title: translationKeys.alertdialog.killswitchRecall.title,
            );
          },
        );
    }
  }

  // RECALL - Handles the Code Check

  /// Adds the desired digit to the [_code] variable and checks automatically if the [_code] matches the stored PIN when 4 digits are reached.
  void addDigit(int digit, BuildContext context) {
    if (_code.length < 4) {
      _code = _code + digit.toString();

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
              toastFromTranslationKey(translationKeys.lockScreen.toastPinSet);
            } else {
              toastFromTranslationKey(
                translationKeys.lockScreen.errors.lastMailMissing,
              );
            }
            context.getMainRouterDelegate().popRoute();
            _emptyCode();
          case PINLockIntent.change:
            if (_lastEmail != 'Error!') {
              _storePIN(_code);
              toastFromTranslationKey(
                translationKeys.lockScreen.toastPinChanged,
              );
            } else {
              toastFromTranslationKey(
                translationKeys.lockScreen.errors.lastMailMissing,
              );
            }

            context.getMainRouterDelegate().popRoute();
            _emptyCode();
          case PINLockIntent.recall:
            _checkCode(_code);
            _emptyCode();
        }
      }
      notifyListeners();
    }
  }

  void toastFromTranslationKey(String key) {
    Fluttertoast.showToast(
      msg: tr(key),
    );
  }

  /// If there is at least one digit in the [_code] input variable, remove the last character.
  void removeLastDigit() {
    if (_code.isNotEmpty) {
      _code = _code.substring(0, _code.length - 1);

      _pinSlot--;
      notifyListeners();
    }
  }

  /// Check if the current value of [_code] matches the locally stored PIN.
  Future<void> _checkCode(String inputCode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String pin = prefs.getString('${_lastEmail!}.code') ?? 'ERROR';

    if (pin == inputCode) {
      _correctCode();
    } else {
      _wrongCode();
    }
  }

  // RESULTS - After-Recall routing

  /// Set the page index to 0 - "welcome to the app"
  void _correctCode() {
    _sessionIsSafe = true;
    //TODO: PAGE = 0 (Why again?)
  }

  /// Reset [_code] and give visual and haptic feedback that the code did not match the locally stored PIN.
  void _wrongCode() {
    HapticFeedback.vibrate();
    _ringColor = RingColors.red;
    Fluttertoast.showToast(
      msg: tr(translationKeys.lockScreen.toastWrongCode),
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
    if (_pinSet) {
      _sessionIsSafe = false;
      notifyListeners();
    }
  }

  bool get sessionIsSafe => _sessionIsSafe;
  int get pinSlot => _pinSlot;
  Color get ringColor => _ringColor;
  bool get pinSet => !_pinSetStillLoading && _pinSet;
  //TODO decide whether we should leave "Loading..." blank in shipping
  String get lastEmail => !_lastEmailStillLoading ? _lastEmail! : 'Loading...';
  bool get pinSetStillLoading => _pinSetStillLoading;
  bool get lastEmailStillLoading => _lastEmailStillLoading;
}

enum PINLockIntent {
  initialize,
  change,
  recall,
}
