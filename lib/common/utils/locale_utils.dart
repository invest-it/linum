import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

extension LocaleExtensions on BuildContext {
  void setAppLocale(Locale locale) {
    if (supportedLocales.contains(locale)) {
      setLocale(locale);
    } else {
      setLocaleToDeviceLocale();
    }
  }

  void setLocaleToDeviceLocale() {
    try {
      if (supportedLocales.contains(deviceLocale)) {
        resetLocale();
      } else if (deviceLocale.languageCode == "en") {
        setLocale(const Locale("en", "US"));
      } else if (fallbackLocale != null) {
        setLocale(fallbackLocale!);
      }
    } catch (e) {
      Logger().v("known life cycle error ");
    }
  }
}
