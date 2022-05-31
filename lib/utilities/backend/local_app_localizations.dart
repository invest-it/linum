//  Local App Localizations - Defines which Language File to use for String Resolve
//
//  Author: NightmindOfficial
//  Co-Author: SoTBurst
//

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linum/app.dart';


class AppLocalizations {
  late final Locale _locale;
  late Locale _currentLocale;

  AppLocalizations(Locale locale)
      : _locale = locale,
        _currentLocale = locale;

  // Helper method to keep the code in the widgets concise
  // Localizations are accessed using an InheritedWidget "of" syntax
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  Locale get locale => _currentLocale;

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  late Map<String, String> _localizedStrings;

  Future<bool> load({Locale? locale}) async {
    final String langCode = _chooseLanguageCode(locale);
    _currentLocale =
        Locale(langCode, langCode != "en" ? langCode.toUpperCase() : "US");

    // Load the language JSON file from the "lang" folder
    final String jsonString =
        await rootBundle.loadString("lang/$langCode.json");
    final Map<String, dynamic>? jsonMap =
        json.decode(jsonString) as Map<String, dynamic>?;
    if (jsonMap == null) {
      return false;
    }
    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  // This method will be called from every widget which needs a localized text
  String translate(String key) {
    return _localizedStrings[key] ?? "$key could not be translated.";
  }

  /// use actively set language if that is null choose languageCode read from preferences and if that is null use system language
  String _chooseLanguageCode(Locale? locale) {
    if (locale == null) {
      if (MyApp.currentLocalLanguageCode == null) {
        return _locale.languageCode;
      } else {
        return MyApp.currentLocalLanguageCode!;
      }
    } else {
      return locale.languageCode;
    }
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Include all of your supported language codes here
    return [
      'de',
      'en',
      'nl',
      'es',
      'fr',
    ].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    final AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
