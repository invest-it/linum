import 'deepl.dart';

Future<Map<String, String>> translate(
    Map<String, String> differences,
    String targetLang,
    String sourceLang,
    DeepL deepL,
) async {
  final translations = Map<String, String>.from(differences);
  if (targetLang == sourceLang) {
    return translations;
  }

  for (final entry in differences.entries) {
    final result = await deepL.translateText(entry.value, sourceLang, targetLang);
    translations[entry.key] = result.text;
  }

  return translations;
}
