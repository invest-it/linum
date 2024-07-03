import 'package:flutter/cupertino.dart';

abstract class ILanguageSettingsService with ChangeNotifier {
  String? getLanguageTag();
  Future<void> setLanguageTag(String? languageCode);
  Future<void> setUseSystemLanguage(bool value);
  bool get useSystemLanguage;

  bool isCurrentLanguageTag(String code);
}
