//  Account Settings Provider - Provider that handles all information about the current settings of the user
//
//  Author: SoTBurst
//  Co-Author: NightmindOfficial
//  (Refactored by damattl)

import 'dart:async';
import 'dart:developer' as dev;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/constants/standard_currencies.dart';
import 'package:linum/constants/standard_expense_categories.dart';
import 'package:linum/constants/standard_income_categories.dart';
import 'package:linum/models/entry_category.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../models/currency.dart';

class AccountSettingsProvider extends ChangeNotifier {
  DocumentReference<Map<String, dynamic>>? _settings;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? settingsListener;

  /// The uid of the user
  late String _uid;

  Map<String, dynamic> lastGrabbedData = {};

  EntryCategory? getIncomeEntryCategory() {
    final String categoryId =
        settings["StandardCategoryIncome"] as String? ?? "None";

    /* final StandardCategoryIncome? standardCategoryIncome = EnumToString
        .fromString<StandardCategoryIncome>(
      StandardCategoryIncome.values,
      categoryId ?? defaultId,
    ); */
    return standardIncomeCategories[categoryId];
  }

  EntryCategory? getExpenseEntryCategory() {
    final String categoryId =
        settings["StandardCategoryExpense"] as String? ?? "None";
    final EntryCategory? catExp = standardExpenseCategories[categoryId];
    return catExp;
  }

  Currency getStandardCurrency() {
    final String? currency = settings["StandardCurrency"] as String?;
    return standardCurrencies[currency] ?? standardCurrencies["EUR"]!;
  }
  Future<bool> setStandardCurrency(Currency currency) async {
    final isInMap = standardCurrencies[currency.name] != null;
    if (!isInMap) {
      return false;
    }
    return updateSettings({"StandardCurrency": currency.name});
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
      setToDeviceLocale(context);
      _settings = null;
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
        Locale? locale;
        if (lastGrabbedData["systemLanguage"] == false && langString != null) {
          final List<String> langArray = langString.split("-");
          locale = Locale(langArray[0], langArray[1]);
          setLocale(context, locale);
        } else {
          setToDeviceLocale(context);
        }

        Provider.of<AuthenticationService>(context, listen: false)
            .updateLanguageCode(context);
        notifyListeners();
      },
      onError: (error, stackTrace) {
        dev.log("i am evil $error and this is my path $stackTrace");
      },
    );
  }

  void setLocale(BuildContext context, Locale locale) {
    if (context.supportedLocales.contains(locale)) {
      context.setLocale(locale);
    } else {
      setToDeviceLocale(context);
    }
  }

  void setToDeviceLocale(BuildContext context) {
    try {
      if (context.supportedLocales.contains(context.deviceLocale)) {
        context.resetLocale();
      } else if (context.deviceLocale.languageCode == "en") {
        context.setLocale(const Locale("en", "US"));
      } else if (context.fallbackLocale != null) {
        context.setLocale(context.fallbackLocale!);
      }
    } catch (e) {
      dev.log("known life cycle error ");
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

  @override
  void dispose() {
    settingsListener?.cancel();
    super.dispose();
  }


  static SingleChildWidget provider(BuildContext context, {bool testing = false}) {
    return ChangeNotifierProxyProvider<AuthenticationService,
        AccountSettingsProvider>(
      create: (ctx) {
        return AccountSettingsProvider(ctx);
      },
      update: (ctx, auth, oldAccountSettings) {
        if (oldAccountSettings != null) {
          return oldAccountSettings..updateAuth(auth, ctx);
        } else {
          return AccountSettingsProvider(ctx);
        }
      },
      lazy: false,
    );
  }
}
