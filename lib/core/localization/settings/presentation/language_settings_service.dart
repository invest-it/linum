import 'package:flutter/cupertino.dart';

abstract class ILanguageSettingsService with ChangeNotifier {
  String? getLanguageCode();
  Future<void> setLanguageCode(String? languageCode);
  Future<void> setUseSystemLanguage(bool value);
  bool get useSystemLanguage;

  bool isCurrentLanguageCode(String code);
}
