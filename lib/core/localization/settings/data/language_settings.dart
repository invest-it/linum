class LanguageSettings {
  final bool? useSystemLanguage;
  final String? languageTag;

  LanguageSettings({
    required this.useSystemLanguage,
    required this.languageTag,
  });

  LanguageSettings copyWith({
    bool? useSystemLanguage,
    String? languageTag,
  }) {
    return LanguageSettings(
      useSystemLanguage: useSystemLanguage ?? this.useSystemLanguage,
      languageTag: languageTag ?? this.languageTag,
    );
  }

  @override
  String toString() {
    return 'LanguageSettings(useSystemLanguage: $useSystemLanguage, languageCode: $languageTag})';
  }
}
