class LanguageSettings {
  final bool? useSystemLanguage;
  final String? languageCode;

  LanguageSettings({
    required this.useSystemLanguage,
    required this.languageCode,
  });

  LanguageSettings copyWith({
    bool? useSystemLanguage,
    String? languageCode,
  }) {
    return LanguageSettings(
      useSystemLanguage: useSystemLanguage ?? this.useSystemLanguage,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  @override
  String toString() {
    return 'LanguageSettings(useSystemLanguage: $useSystemLanguage, languageCode: $languageCode})';
  }
}
