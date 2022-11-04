import 'dart:convert';
import 'dart:io';
import 'package:tuple/tuple.dart';
import '../flatten.dart';

List<String> getDeletedEntries(
    Map<String, LanguageEntry> baseFlattened,
    Map<String, LanguageEntry> comparedFlattened,
) {
  final deleted = <String>[];
  for (final key in comparedFlattened.keys) {
    if (baseFlattened[key] == null) {
      deleted.add(key);
    }
  }
  return deleted;
}

Map<String, LanguageEntry> getChangedEntries(
    Map<String, LanguageEntry> baseFlattened,
    Map<String, LanguageEntry> comparedFlattened,
) {
  final differences = <String, LanguageEntry>{};
  for (final baseEntry in baseFlattened.entries) {
    final comparedLangEntry = comparedFlattened[baseEntry.key];
    if (comparedLangEntry == null || comparedLangEntry.value != baseEntry.value.value) {
      differences[baseEntry.key] = baseEntry.value;
    }

  }
  return differences;
}

Future<Tuple2<Map<String, LanguageEntry>, List<String>>> compareFiles(
    String baseFilePath,
    String comparedFilePath
) async {

  final baseStr = await File(baseFilePath).readAsString();
  final baseData = jsonDecode(baseStr) as Map<String, dynamic>;

  final comparedStr = await File(comparedFilePath).readAsString();
  final comparedData = jsonDecode(comparedStr) as Map<String, dynamic>;

  final comparedFlattened = flattenMap(comparedData, <String>[], <String, LanguageEntry>{});
  final baseFlattened = flattenMap(baseData, <String>[], <String, LanguageEntry>{});

  final differences = getChangedEntries(baseFlattened, comparedFlattened);
  final deleted = getDeletedEntries(baseFlattened, comparedFlattened);

  return Tuple2(differences, deleted);
}
