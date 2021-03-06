//  Account Settings Provider - Provider that handles all information about the current settings of the user
//
//  Author: SoTBurst
//  Co-Author: NightmindOfficial
//  (Refactored by damattl)

import 'dart:async';
import 'dart:developer' as dev;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linum/constants/standard_expense_categories.dart';
import 'package:linum/constants/standard_income_categories.dart';
import 'package:linum/models/entry_category.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:linum/utilities/backend/local_app_localizations.dart';
import 'package:provider/provider.dart';

class AccountSettingsProvider extends ChangeNotifier {
  /// _balance is the documentReference to get the balance data from the database. It will be null if the constructor isnt ready yet
  DocumentReference<Map<String, dynamic>>? _settings;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? settingsListener;

  /// The uid of the user
  late String _uid;
  int _dontDispose = 0;

  Map<String, dynamic> lastGrabbedData = {};

  EntryCategory? getIncomeEntryCategory() {
    final String categoryId =
        settings["StandardCategoryIncome"] as String? ?? "None";

    /* final StandardCategoryIncome? standardCategoryIncome = EnumToString
        .fromString<StandardCategoryIncome>(
      StandardCategoryIncome.values,
      categoryId ?? defaultId,
    ); */
    return standardCategoryIncomes[categoryId];
  }

  EntryCategory? getExpenseEntryCategory() {
    final String categoryId =
        settings["StandardCategoryExpense"] as String? ?? "None";
    final EntryCategory? catExp = standardCategoryExpenses[categoryId];
    return catExp;
  }

  AccountSettingsProvider(BuildContext context) {
    _uid = Provider.of<AuthenticationService>(context, listen: false).uid;

    if (_uid != "") {
      _settings =
          FirebaseFirestore.instance.collection('account_settings').doc(_uid);
    }
    _createAutoUpdate(context);
  }

  void updateAuth(AuthenticationService auth, BuildContext context) {
    if (_uid != auth.uid) {
      dev.log("this still works");
      _uid = auth.uid;
      if (_uid == "") {
        if (settingsListener != null) {
          settingsListener!.cancel().then((_) {
            updateAuthHelper(context);
          });
        }
      }
      updateAuthHelper(context);
    }
  }

  void updateAuthHelper(BuildContext context) {
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
      dev.log("Auto update could not be set up. _settings == null");
      return;
    }
    if (!(await _settings!.get()).exists) {
      await _settings!.set({});
    }
    settingsListener = _settings!.snapshots().listen(
      (DocumentSnapshot<Map<String, dynamic>> innerSnapshot) {
        lastGrabbedData = innerSnapshot.data() ?? {};

        final String? langString = lastGrabbedData["languageCode"] as String?;
        Locale? lang;
        if (lastGrabbedData["systemLanguage"] == false && langString != null) {
          final List<String> langArray = langString.split("-");
          lang = Locale(langArray[0], langArray[1]);
        }
        AppLocalizations.of(context)!.load(locale: lang);
        Provider.of<AuthenticationService>(context, listen: false)
            .updateLanguageCode(context);
        notifyListeners();
      },
      onError: (error, stackTrace) {
        dev.log("i am evil $error and this is my path $stackTrace");
      },
    );
  }

  void dontDisposeOneTime() {
    _dontDispose++;
  }

  @override
  void dispose() {
    if (_dontDispose-- == 0) {
      super.dispose();
      settingsListener?.cancel();
    }
  }

  Map<String, dynamic> get settings {
    return lastGrabbedData;
  }

  Future<bool> updateSettings(Map<String, dynamic> settings) async {
    if (_settings == null) {
      dev.log("Settings could not be set. _settings == null");
      return false;
    }

    dev.log("updateSettings called");

    _settings!.update(settings);

    return true;
  }
}
