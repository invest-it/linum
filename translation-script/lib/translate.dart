import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as path;
import 'package:translation_script/compare.dart';
import 'package:translation_script/deepl.dart';
import 'package:translation_script/flatten.dart';
import 'package:translation_script/helpers.dart';
import 'package:translation_script/types.dart';


Future<Map<String, String>> translate(
    Map<String, LanguageEntry> differences,
    String targetLang,
    String sourceLang,
    String targeFile,
    DeepL deepL,
) async {
  final translations = Map<String, String>.from(differences.map((key, value) => MapEntry(key, value.value)));
  if (targetLang == sourceLang) {
    return translations;
  }

  for (final entry in differences.entries) {
    final noTranslate = entry.value.config?['no-overwrite'] as String?;
    if (noTranslate != null && noTranslate == targeFile.split('.')[0]) {
      translations.remove(entry.key);
      continue;
    }

    final result = await deepL.translateText(entry.value.value, sourceLang, targetLang);
    translations[entry.key] = result.text;
    print(result.text);
  }

  return translations;
}

Future<void> addTranslationsToFile(
    Map<String, String> translations,
    List<String> removedTranslations,
    String filePath,
) async {
  final fileStr = await File(filePath).readAsString();
  final jsonData = jsonDecode(fileStr) as Map<String, dynamic>;

  final flattened = flattenMap(jsonData, [], {});

  for (final entry in translations.entries) {
    flattened[entry.key] = LanguageEntry(entry.value);
  }

  for (final removed in removedTranslations) {
    flattened.remove(removed);
  }

  final inflated = inflateMap(flattened);

  const jsonEncoder = JsonEncoder.withIndent("    ");
  final jsonStr = jsonEncoder.convert(inflated);

  await File(filePath).writeAsString(jsonStr);
}

Future<void> generateTranslations(ArgResults args) async {
  if (args["dir"] == null || args["base"] == null || args["compare"] == null) {
    stderr.writeln("Not enough arguments specified! Type --help or -h for more information.");
    stdout.writeln("Press enter to exit");
    stdin.readLineSync();
    return;
  }

  final configStr = await File("translator-config.json").readAsString();
  final config = TranslatorConfig.fromJson(jsonDecode(configStr) as Map<String, dynamic>);

  final translator = DeepL(config.authKey);

  if (!Directory(args["dir"] as String).existsSync()) {
    stdout.writeln("Could not find the directory specified for the language files: '${args["dir"]}'");
    stdout.writeln("Press enter to exit");
    stdin.readLineSync();
    return;
  }

  final fullBasePath = path.join(args["dir"] as String, args["base"] as String);
  final fullComparePath = path.join(args["dir"] as String, args["compare"] as String);

  if (!File(fullBasePath).existsSync()) {
    stdout.writeln("Could not find the base file: '$fullBasePath'");
    stdout.writeln("Press enter to exit");
    stdin.readLineSync();
    return;
  }

  if (!File(fullComparePath).existsSync()) {
    stdout.writeln("Could not find the file specified for comparison: '$fullComparePath'");
    stdout.writeln("Press enter to exit");
    stdin.readLineSync();
    return;
  }

  final results = await compareFiles(fullBasePath, fullComparePath);

  if (results.item1.isEmpty && results.item2.isEmpty) {
    stdout.writeln("Not enough changed tags to translate.");
    stdout.writeln("Press enter to exit");
    stdin.readLineSync();
    return;
  }

  stdout.writeln("Found the following changed tags(s): ");
  stdout.writeln(results.item1.map((key, value) => MapEntry(key, value.value)));

  if (continueTranslating()) {
    for (final langConfigEntry in config.lang.entries) {
      final outputPath = path.join(args["dir"], langConfigEntry.value);
      if (!File(outputPath).existsSync()) {
        stdout.writeln("Configured output file '$outputPath' does not exist.");
        stdout.writeln("Please check for typos in translator-config.json!");
        stdout.writeln("Press enter to exit");
        stdin.readLineSync();
        return;
      }

      if (args["single"] as bool) {
        if (langConfigEntry.value == args["compare"] as String) {
          final translations = await translate(
              results.item1,
              langConfigEntry.key,
              "DE",
              langConfigEntry.value,
              translator,
          );
          addTranslationsToFile(translations, results.item2, outputPath);
          break;
        }
      }

      final translations = await translate(
        results.item1,
        langConfigEntry.key,
        "DE",
        langConfigEntry.value,
        translator,
      );
      addTranslationsToFile(translations, results.item2, outputPath);
    }

    stdout.writeln("Translations for tag(s): \n");
    stdout.writeln(results.item1.map((key, value) => MapEntry(key, value.value)));
    stdout.writeln("Successfully translated ${results.item1.length} tag(s). Deleted ${results.item2.length} tag(s). Exiting now..");
    sleep(Duration(seconds: 5));
  }
}


