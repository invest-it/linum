import 'dart:math';

import 'package:linum/widgets/settings_screen/language_selector.dart';

class LanguageEntry {
  final String value;
  LanguageEntry(this.value);

  factory LanguageEntry.fromDynamic(dynamic value) {
    if (value is String) {
      return LanguageEntry(value);
    } else if (value is List) {
      return LanguageEntry(value[0] as String);
    } else {
      print("This should not happen");
      return LanguageEntry("");
    }
  }
}

Map<String, LanguageEntry> flattenMap(
    Map<String, dynamic> map,
    List<String> prevNodes,
    Map<String, LanguageEntry> flattened,
) {
  for (final entry in map.entries) {
    final nodes = List<String>.from(prevNodes)..add(entry.key);
    if (entry.value is List || entry.value is String) {
      flattened[nodes.join(".")] = LanguageEntry.fromDynamic(entry.value);
    } else if(entry.value is Map<String, dynamic>) {
      flattenMap(entry.value as Map<String, dynamic>, nodes, flattened);
    }
  }
  return flattened;
}

void mapFromNodes(Map<String, dynamic> prevMap, List<String> nodes, int index, String value) {
  final node = nodes[index];
  if (index == nodes.length - 1) {
    prevMap[node] = value;
    return;
  }

  if (prevMap[node] == null) {
    prevMap[node] = <String, dynamic>{};
  }

  mapFromNodes(prevMap[node] as Map<String, dynamic>, nodes, index + 1, value);

}

Map<String, dynamic> inflateMap(Map<String, LanguageEntry> flattened) {
  final inflated = <String, dynamic>{};
  for (final entry in flattened.entries) {
    final nodes = entry.key.split('.');
    mapFromNodes(inflated, nodes, 0, entry.value.value);
  }
  return inflated;
}
