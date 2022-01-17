import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserAlert {
  final BuildContext _context;
  final String _message;
  final String _title;
  final String _actionTitle;
  final bool _userMustDismissWithButton;

  UserAlert(
      {message = 'Ein unbekannter Fehler ist aufgetreten.',
      title = 'Fehler',
      actionTitle = 'Okay',
      userMustDismissWithButton = true,
      required BuildContext context})
      : _message = message,
        _title = title,
        _actionTitle = actionTitle,
        _userMustDismissWithButton = userMustDismissWithButton,
        _context = context {
    _showMyDialog();
  }

  static createUserAlert(String message) {}

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: _context,
      barrierDismissible:
          !_userMustDismissWithButton, // user must tap button if userMustDismissWithButton is true
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(_message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(_actionTitle),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
