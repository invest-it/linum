import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:easy_localization/src/localization.dart';
import 'package:easy_localization/src/translations.dart';

/// Loads localization from JSON files.
/// Required for testing localization dependent functions.
/// Default Locale is `en-US`.
Future<void> loadLocalization({String locale = "en-US"}) async {

  final content = await File('./assets/lang/$locale.json').readAsString();
  final data = jsonDecode(content) as Map<String, dynamic>;

  final localeSplits = locale.split('-');

  Localization.load(
    Locale(localeSplits[0], localeSplits[1]),
    translations: Translations(data),
  );
}
