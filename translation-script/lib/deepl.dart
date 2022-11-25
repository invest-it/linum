import 'dart:convert';

import 'package:http/http.dart' as http;

const deeplAPI = "https://api-free.deepl.com/v2/translate";

class TranslationResult {
  final String? detectedSourceLang;
  final String text;
  TranslationResult(this.detectedSourceLang, this.text);

  factory TranslationResult.fromJson(Map<String, dynamic> json) {
    return TranslationResult(
        json['detected_source_lang'] as String?,
        json['text'] as String,
    );
  }
}

class DeepL {
  String authKey;
  DeepL(this.authKey);
  Future<TranslationResult> translateText(String text, String sourceLang, String targetLang) async {
    final requestStr = "$deeplAPI?text=$text&target_lang=$targetLang&source_lang=$sourceLang";

    final response = await http.post(
      Uri.parse(requestStr),
      headers: <String, String> {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'DeepL-Auth-Key $authKey',
      },
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      final translations = json['translations'] as List<dynamic>;
      return TranslationResult.fromJson(translations[0] as Map<String, dynamic>);
    } else {
      throw Exception("Translator not working");
    }
  }
  
  
}
