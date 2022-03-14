import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:linum/backend_functions/local_app_localizations.dart';
import 'package:linum/frontend_functions/user_alert.dart';
import 'package:linum/models/dialog_action.dart';
import 'package:linum/models/lock_screen_action.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:linum/providers/screen_index_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinCodeProvider extends ChangeNotifier {
  //TODO turn this off. This should not be active by default, but as long as the switch in settings_screen isn't implemented, there is no other way of turning the feature on.
  bool _pinActive = true;
  String _code = '';
  int _pinSlot = 0;
  Color _ringColor = Color(0XFF279E44);
  late BuildContext _context;
  late ScreenIndexProvider _screenIndexProvider;
  late AuthenticationService _auth;
  late UserAlert confirmKillswitch;

  PinCodeProvider(BuildContext context) {
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

  updateSipAndAuth(BuildContext context) {
    _screenIndexProvider = Provider.of<ScreenIndexProvider>(
      context,
      listen: false,
    );

    _auth = Provider.of<AuthenticationService>(context);

    _context = context;
  }

  // If the intent of the PIN lock is not set before the screen is called, assume that we want to check whether user knows the code (classic recall)
  PINLockIntent _intent = PINLockIntent.RECALL;

  // ACTIVATION & SETTINGS - Toggles the PIN Lock in the settingsScreen

  ///Activates - Deactivates the PIN Lock
  //TODO - change the switch condition of _pinActive into one that relies on whether 'applock' has a value in sharedPreferences
  void togglePINLock() {
    if (pinActive == false) {
      _pinActive = true;
      //Force the user to initialize their PIN number every time the PIN is (re-)activated.
      _setPINLockIntent(intent: PINLockIntent.INITIALIZE);
      _screenIndexProvider.setPageIndex(5);
    } else {
      _pinActive = false;
      _removePIN();
      Fluttertoast.showToast(
          msg: AppLocalizations.of(_context)!
              .translate("lock_screen/toast-pin-deactivated"));
    }
    notifyListeners();
  }

  /// Toggles a PIN change request
  void triggerPINChange() {
    _setPINLockIntent(intent: PINLockIntent.CHANGE);
    _screenIndexProvider.setPageIndex(5);
  }

  /// Triggers a PIN recall
  void triggerPINRecall() {
    _setPINLockIntent(intent: PINLockIntent.RECALL);
    _screenIndexProvider.setPageIndex(5);
  }

  // PERSISTENCE - stores a (new) PIN number in the device storage, probably sharedPreferences

  /// Stores a new value for the PIN on the device
  void _storePIN(String code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('applock', code);
    log(prefs.getString('applock') ?? "ERROR: No String stored in prefs!!!");
  }

  /// Deletes the currently stored value for the PIN on the device
  void _removePIN() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('applock');
  }

  // INTENT - provides the "style" of the PIN lock depending of the system intent
  // the function recallPINLockIntent() provides the lock screen with all information about the labels, as well as the action to be performed
  // when the bottom button, aka. "killswitch" is pressed

  void _setPINLockIntent({required PINLockIntent intent}) {
    _intent = intent;
  }

  LockScreenAction recallPINLockIntent() {
    switch (_intent) {
      case PINLockIntent.INITIALIZE:
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
                  dialogPurpose: DialogPurpose.PRIMARY,
                ),
                DialogAction(
                  actionTitle: "alertdialog/killswitch-initialize/cancel",
                  //If this is empty, UserAlert will use its own context to pop the dialog
                  function: () {
                    Navigator.of(_context).pop();
                  },
                  dialogPurpose: DialogPurpose.SECONDARY,
                  popDialog: true,
                ),
              ],
              title: "alertdialog/killswitch-initialize/title",
            );
          },
        );
      case PINLockIntent.CHANGE:
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
                  dialogPurpose: DialogPurpose.PRIMARY,
                ),
                DialogAction(
                  actionTitle: "alertdialog/killswitch-change/cancel",
                  //If this is empty, UserAlert will use its own context to pop the dialog
                  function: () {
                    Navigator.of(_context).pop();
                  },
                  dialogPurpose: DialogPurpose.SECONDARY,
                  popDialog: true,
                ),
              ],
              title: "alertdialog/killswitch-change/title",
            );
          },
        );
      case PINLockIntent.RECALL:
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
                    _auth.signOut().then((_) {
                      Provider.of<ScreenIndexProvider>(_context, listen: false)
                          .setPageIndex(0);
                      Navigator.of(_context).pop();
                    });
                  },
                  dialogPurpose: DialogPurpose.PRIMARY,
                ),
                DialogAction(
                  actionTitle: "alertdialog/killswitch-recall/cancel",
                  //If this is empty, UserAlert will use its own context to pop the dialog
                  function: () {
                    Navigator.of(_context).pop();
                  },
                  dialogPurpose: DialogPurpose.SECONDARY,
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
      _ringColor = Color(0XFF279E44);
      notifyListeners();

      //if code # is complete, check if it is correct
      if (_code.length == 4)
        switch (_intent) {
          case PINLockIntent.INITIALIZE:
            _storePIN(_code);
            Fluttertoast.showToast(
              msg: AppLocalizations.of(_context)!
                  .translate("lock_screen/toast-pin-set"),
            );
            _screenIndexProvider.setPageIndex(3);
            _emptyCode();
            break;
          case PINLockIntent.CHANGE:
            _storePIN(_code);
            Fluttertoast.showToast(
              msg: AppLocalizations.of(_context)!
                  .translate("lock_screen/toast-pin-changed"),
            );
            _screenIndexProvider.setPageIndex(3);
            _emptyCode();
            break;
          case PINLockIntent.RECALL:
            _checkCode(_code);
            _emptyCode();
            break;
        }
    }
  }

  /// If there is at least one digit in the [_code] input variable, remove the last character.
  void removeLastDigit() {
    if (_code.length > 0) {
      _code = _code.substring(0, _code.length - 1);
      // log(_code);
      _pinSlot--;
      notifyListeners();
    }
  }

  /// Check if the current value of [_code] matches the locally stored PIN.
  void _checkCode(String _inputCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _pin = prefs.getString('applock') ?? '';
    if (_pin == _inputCode) {
      _correctCode();
    } else
      _wrongCode();
  }

  // RESULTS - After-Recall routing

  /// Set the page index to 0 - "welcome to the app"
  void _correctCode() {
    _screenIndexProvider.setPageIndex(0);
  }

  /// Reset [_code] and give visual and haptic feedback that the code did not match the locally stored PIN.
  void _wrongCode() {
    HapticFeedback.vibrate();
    _ringColor = Color(0XFFEB5757);
    Fluttertoast.showToast(
        msg: AppLocalizations.of(_context)!
            .translate("lock_screen/toast-wrong-code"));
    _emptyCode();
  }

  /// Resets the current value of [_code] to an empty String.
  void _emptyCode() {
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
