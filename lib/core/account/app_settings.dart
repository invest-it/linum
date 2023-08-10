//  Account Settings Provider - Provider that handles all information about the current settings of the user
//
//  Author: SoTBurst
//  Co-Author: NightmindOfficial
//  (Refactored by damattl)

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/authentication/services/authentication_service.dart';
import 'package:linum/core/categories/constants/standard_categories.dart';
import 'package:linum/core/categories/models/category.dart';
import 'package:linum/features/currencies/constants/standard_currencies.dart';
import 'package:linum/features/currencies/models/currency.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class AppSettings extends ChangeNotifier {
  DocumentReference<Map<String, dynamic>>? _settings;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _settingsListener;
  late StreamSubscription<User?> _userListener;


  /// The uid of the user
  late String _uid;

  final Logger logger = Logger();

  Map<String, dynamic> lastGrabbedData = {};

  AppSettings({
    required BuildContext context,
    required User? user,
  }) {
    _uid = user?.uid ?? "";

    if (_uid != "") {
      _settings =
          FirebaseFirestore.instance.collection('account_settings').doc(_uid);
    }
    _createAutoUpdate(context);
  }

  Category? getIncomeEntryCategory() {
    final String categoryId =
        settings["StandardCategoryIncome"] as String? ?? "None";

    /* final StandardCategoryIncome? standardCategoryIncome = EnumToString
        .fromString<StandardCategoryIncome>(
      StandardCategoryIncome.values,
      categoryId ?? defaultId,
    ); */
    return standardCategories[categoryId];
  }

  Category? getExpenseEntryCategory() {
    final String categoryId =
        settings["StandardCategoryExpense"] as String? ?? "None";
    final Category? catExp = standardCategories[categoryId];
    return catExp;
  }

  Currency getStandardCurrency() {
    final String? currency = settings["StandardCurrency"] as String?;
    return standardCurrencies[currency] ?? standardCurrencies["EUR"]!;
  }

  Future<void> setStandardCurrency(Currency currency) async {
    final isInMap = standardCurrencies[currency.name] != null;
    if (!isInMap) {
      return;
    }
    final result = await updateSettings({"StandardCurrency": currency.name});
    if (result) {
      notifyListeners();
    }
  }

  // TODO: Check if this name makes sense
  Future<void> _createAutoUpdate(BuildContext context) async {
    if (_uid == "") {
      setToDeviceLocale(context);
      _settings = null;
      return;
    }
    if (_settings == null) {
      logger.v("Auto update could not be set up. _settings == null");
      return;
    }
    if (!(await _settings!.get()).exists) {
      await _settings!.set({});
    }
    _settingsListener = _settings!.snapshots().listen(
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

        context.read<AuthenticationService>().updateLanguageCode(
          context.locale.languageCode,
        );
        notifyListeners();
      },
      onError: (error, stackTrace) {
        logger.e(error.toString());
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
      logger.v("known life cycle error ");
    }
  }

  Map<String, dynamic> get settings {
    return lastGrabbedData;
  }

  Future<bool> updateSettings(Map<String, dynamic> settings) async {
    if (_settings == null) {
      logger.v("Settings could not be set. _settings == null");
      return false;
    }

    logger.v("updateSettings called");

    _settings!.update(settings);

    return true;
  }

  @override
  void dispose() {
    _settingsListener?.cancel();
    _userListener.cancel();
    super.dispose();
  }
}
