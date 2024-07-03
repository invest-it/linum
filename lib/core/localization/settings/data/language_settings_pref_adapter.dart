import 'package:linum/core/localization/settings/data/language_settings.dart';
import 'package:linum/core/settings/data/pref_adapter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSettingsPrefAdapter extends IPrefAdapter<LanguageSettings> {
  final SharedPreferences preferences;

  LanguageSettingsPrefAdapter({required this.preferences});

  @override
  LanguageSettings load() {
    final languageTag = preferences.getString("languageTag");
  // TODO: Perhaps add useSystemLanguage to prefs
    return LanguageSettings(
        useSystemLanguage: languageTag == null,
        languageTag: languageTag,
    );
  }

  @override
  void store(LanguageSettings settings) {
    if (settings.languageTag == null) {
      preferences.remove("languageTag");
      return;
    }
    preferences.setString("languageTag", settings.languageTag!);
  }

}
