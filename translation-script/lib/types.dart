class TranslatorConfig {
  final String authKey;
  final Map<String, String> lang;
  TranslatorConfig(this.authKey, this.lang);

  factory TranslatorConfig.fromJson(Map<String, dynamic> json) {
    return TranslatorConfig(
      json["auth_key"] as String,
      (json["lang"] as Map<String, dynamic>).map((key, value) => MapEntry(key, value as String)),
    );
  }
}

class LanguageEntry {
  final String value;
  final Map<String, dynamic>? config;
  LanguageEntry(this.value, {
    this.config,
  });

  factory LanguageEntry.fromDynamic(dynamic value) {
    if (value is String) {
      return LanguageEntry(value);
    } else if (value is List) {
      final config = value[1] as Map<String, dynamic>?;
      return LanguageEntry(value[0] as String, config: config);
    } else {
      print("This should not happen");
      return LanguageEntry("");
    }
  }
}
