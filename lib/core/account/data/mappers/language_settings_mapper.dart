import 'package:linum/core/account/data/mappers/settings_mapper_interface.dart';
import 'package:linum/core/account/data/models/language_settings.dart';

class LanguageSettingsMapper implements ISettingsMapper<LanguageSettings> {
  @override
  Map<String, dynamic> toMap(LanguageSettings model) {
    final Map<String, dynamic> map = {};
    final systemLanguage = model.useSystemLanguage;
    final languageCode = model.languageCode;

    if (languageCode != null) {
      map["languageCode"] = languageCode;
    }
    if (systemLanguage != null) {
      map["systemLanguage"] = systemLanguage;
    }

    return map;
  }

  @override
  LanguageSettings toModel(Map<String, dynamic> map) {
    final useSystemLanguage = map["systemLanguage"] as bool?;
    final languageCode = map["languageCode"] as String?;

    return LanguageSettings(
        useSystemLanguage: useSystemLanguage,
        languageCode: languageCode,
    );
  }
}
