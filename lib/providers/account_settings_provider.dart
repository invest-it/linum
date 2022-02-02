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

  /// List of Categories the User can declare as a Standard when tracking an EXPENSE.
  /// e.g. Söncke usually incurs expenses for WATER, therefore he can choose FOOD
  /// as his Standard Category for Expenses so he does not have to choose FOOD as a category when adding as an expense.
  final Map<StandardCategoryExpense, String> standardCategoryExpenses = {
    StandardCategoryExpense.None: "settings_screen/standards-selector-none",
    StandardCategoryExpense.Food:
        "settings_screen/standard-expense-selector/food",
    StandardCategoryExpense.FreeTime:
        "settings_screen/standard-expense-selector/freetime",
    StandardCategoryExpense.House:
        "settings_screen/standard-expense-selector/house",
    StandardCategoryExpense.Lifestyle:
        "settings_screen/standard-expense-selector/lifestyle",
    StandardCategoryExpense.Car:
        "settings_screen/standard-expense-selector/car",
    StandardCategoryExpense.Miscellaneous:
        "settings_screen/standard-expense-selector/misc",
  };

  /// List of Categories the User can declare as a Standard when tracking INCOME.
  /// e.g. Otis works as a freelancer, so the income he tracks is mostly in the category SIDE JOB, therefore he can choose SIDE JOB
  /// as his Standard Category for Income so he does not have to choose SIDE JOB as a category when adding an income.
  final Map<StandardIncome, String> standardCategoryIncome = {
    StandardIncome.None: "settings_screen/standards-selector-none",
    StandardIncome.Income: "settings_screen/standard-income-selector/salary",
    StandardIncome.Allowance:
        "settings_screen/standard-income-selector/allowance",
    StandardIncome.SideJob: "settings_screen/standard-income-selector/sidejob",
    StandardIncome.Investments:
        "settings_screen/standard-income-selector/investments",
    StandardIncome.ChildSupport:
        "settings_screen/standard-income-selector/childsupport",
    StandardIncome.Interest:
        "settings_screen/standard-income-selector/interest",
    StandardIncome.Miscellaneous:
        "settings_screen/standard-income-selector/misc",
  };

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

enum StandardIncome {
  None,
  Income,
  Allowance,
  SideJob,
  Investments,
  ChildSupport,
  Interest,
  Miscellaneous,
}

enum StandardCategoryExpense {
  None,
  Food,
  FreeTime,
  House,
  Lifestyle,
  Car,
  Miscellaneous,
}
enum StandardAccount {
  None,
  Debit,
  Credit,
  Cash,
  Depot,
}
