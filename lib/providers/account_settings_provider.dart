import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linum/backend_functions/local_app_localizations.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:provider/provider.dart';

class AccountSettingsProvider extends ChangeNotifier {
  /// _balance is the documentReference to get the balance data from the database. It will be null if the constructor isnt ready yet
  DocumentReference<Map<String, dynamic>>? _settings;

  /// The uid of the user
  late String _uid;

  Map<String, dynamic> lastGrabbedData = {};

  AccountSettingsProvider(BuildContext context) {
    _uid = Provider.of<AuthenticationService>(context, listen: false).uid;

    if (_uid != "") {
      _settings =
          FirebaseFirestore.instance.collection('account_settings').doc(_uid);
    }
    _createAutoUpdate(context);
  }

  void updateAuth(AuthenticationService auth, BuildContext context) {
    _uid = auth.uid;

    if (_uid != "") {
      _settings =
          FirebaseFirestore.instance.collection('account_settings').doc(_uid);
    }
    _createAutoUpdate(context);
    notifyListeners();
  }

  Future<void> _createAutoUpdate(BuildContext context) async {
    if (_uid == "") {
      return;
    }
    if (_settings == null) {
      log("Auto update could not be set up. _settings == null");
      return;
    }
    if (!(await _settings!.get()).exists) {
      await _settings!.set({});
    }
    _settings!
        .snapshots()
        .listen((DocumentSnapshot<Map<String, dynamic>> innerSnapshot) {
      lastGrabbedData = innerSnapshot.data() ?? {};

      String? langString = lastGrabbedData["languageCode"];
      Locale? lang;
      if (lastGrabbedData["systemLanguage"] == false && langString != null) {
        List<String> langArray = langString.split("-");
        lang = Locale(langArray[0], langArray[1]);
      }
      AppLocalizations.of(context)!.load(locale: lang);
      notifyListeners();
    });
  }

  Map<String, dynamic> get settings {
    return lastGrabbedData;
  }

  Future<bool> updateSettings(Map<String, dynamic> settings) async {
    if (_settings == null) {
      log("Settings could not be set. _settings == null");
      return false;
    }

    _settings!.update(settings);

    return true;
  }
}
