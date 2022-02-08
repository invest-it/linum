import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linum/backend_functions/local_app_localizations.dart';
import 'package:linum/models/entry_category.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:provider/provider.dart';

class AccountSettingsProvider extends ChangeNotifier {
  /// _balance is the documentReference to get the balance data from the database. It will be null if the constructor isnt ready yet
  DocumentReference<Map<String, dynamic>>? _settings;

  /// The uid of the user
  late String _uid;
  int _dontDispose = 0;

  Map<String, dynamic> lastGrabbedData = {};

  /// List of Categories the User can declare as a Standard when tracking an EXPENSE.
  /// e.g. Söncke usually incurs expenses for WATER, therefore he can choose FOOD
  /// as his Standard Category for Expenses so he does not have to choose FOOD as a category when adding as an expense.
  final Map<StandardCategoryExpense, EntryCategory> standardCategoryExpenses = {
    StandardCategoryExpense.None: EntryCategory(
        label: 'settings_screen/standards-selector-none',
        icon: Icons.check_box_outline_blank_rounded),
    StandardCategoryExpense.Food: EntryCategory(
        label: "settings_screen/standard-expense-selector/food",
        icon: Icons.local_dining_rounded),
    StandardCategoryExpense.FreeTime: EntryCategory(
        label: "settings_screen/standard-expense-selector/freetime",
        icon: Icons.beach_access_rounded),
    StandardCategoryExpense.House: EntryCategory(
        label: "settings_screen/standard-expense-selector/house",
        icon: Icons.home_rounded),
    StandardCategoryExpense.Lifestyle: EntryCategory(
        label: "settings_screen/standard-expense-selector/lifestyle",
        icon: Icons.local_fire_department_outlined),
    StandardCategoryExpense.Car: EntryCategory(
        label: "settings_screen/standard-expense-selector/car",
        icon: Icons.directions_car_rounded),
    StandardCategoryExpense.Miscellaneous: EntryCategory(
        label: "settings_screen/standard-expense-selector/misc",
        icon: Icons.inventory_2),
  };

  /// List of Categories the User can declare as a Standard when tracking INCOME.
  /// e.g. Otis works as a freelancer, so the income he tracks is mostly in the category SIDE JOB, therefore he can choose SIDE JOB
  /// as his Standard Category for Income so he does not have to choose SIDE JOB as a category when adding an income.
  final Map<StandardCategoryIncome, EntryCategory> standardCategoryIncomes = {
    StandardCategoryIncome.None: EntryCategory(
        label: "settings_screen/standards-selector-none",
        icon: Icons.check_box_outline_blank_rounded),
    StandardCategoryIncome.Income: EntryCategory(
        label: "settings_screen/standard-income-selector/salary",
        icon: Icons.work_rounded),
    StandardCategoryIncome.Allowance: EntryCategory(
        label: "settings_screen/standard-income-selector/allowance",
        icon: Icons.savings_rounded),
    StandardCategoryIncome.SideJob: EntryCategory(
        label: "settings_screen/standard-income-selector/sidejob",
        icon: Icons.add_business_rounded),
    StandardCategoryIncome.Investments: EntryCategory(
        label: "settings_screen/standard-income-selector/investments",
        icon: Icons.auto_graph_rounded),
    StandardCategoryIncome.ChildSupport: EntryCategory(
        label: "settings_screen/standard-income-selector/childsupport",
        icon: Icons.baby_changing_station_rounded),
    StandardCategoryIncome.Interest: EntryCategory(
        label: "settings_screen/standard-income-selector/interest",
        icon: Icons.attach_money_rounded),
    StandardCategoryIncome.Miscellaneous: EntryCategory(
        label: "settings_screen/standard-income-selector/misc",
        icon: Icons.inventory_2),
  };

  final Map<RepeatDuration, Map<String, dynamic>> categoriesRepeat = {
    RepeatDuration.None: {
      "entryCategory": EntryCategory(
        label: 'enter_screen/label-repeat-none',
        icon: Icons.sync_disabled_rounded,
      ),
      "duration": null,
    },
    RepeatDuration.Daily: {
      "entryCategory": EntryCategory(
        label: 'enter_screen/label-repeat-daily',
        icon: Icons.calendar_today_rounded,
      ),
      "duration": Duration(days: 1),
    },
    RepeatDuration.Weekly: {
      "entryCategory": EntryCategory(
        label: 'enter_screen/label-repeat-weekly',
        icon: Icons.calendar_view_week_rounded,
      ),
      "duration": Duration(days: 7),
    },
    RepeatDuration.Monthly: {
      "entryCategory": EntryCategory(
        label: 'enter_screen/label-repeat-monthly',
        icon: Icons.calendar_view_month_rounded,
      ),
      // TODO implement correctly
      "duration": Duration(days: 30),
    },
    // TODO implement custom range picker
    // {
    //   "entryCategory": EntryCategory(
    //       label: AppLocalizations.of(context)!
    //           .translate('enter_screen/label-repeat-freeselect'),
    //       icon: Icons.repeat),
    //       "duration": null,
    // },
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
    if (_uid != auth.uid) {
      _uid = auth.uid;

      if (_uid != "") {
        _settings =
            FirebaseFirestore.instance.collection('account_settings').doc(_uid);
      }
      _createAutoUpdate(context);
      notifyListeners();
    }
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

  void dontDisposeOneTime() {
    _dontDispose++;
  }

  @override
  void dispose() {
    if (_dontDispose-- == 0) {
      super.dispose();
    }
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

enum StandardCategoryIncome {
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

enum RepeatDuration {
  None,
  Daily,
  Weekly,
  Monthly,
  // TODO implement custom repeat
  // Custom,
}
