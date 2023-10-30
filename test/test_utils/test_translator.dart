import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/localization.dart';
import 'package:easy_localization/src/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linum/common/interfaces/translator.dart';

class TestTranslator implements ITranslator {
  final String locale;

  late final Future<void> initializationFinished;
  bool _isInitialized = false;

  TestTranslator({this.locale = "en-US"}) {
    initializationFinished = _loadLocalization();
  }



  /// Loads localization from JSON files.
  /// Required for testing localization dependent functions.
  /// Default Locale is `en-US`.
  Future<void> _loadLocalization() async {

    final content = await File('./assets/lang/$locale.json').readAsString();
    final data = jsonDecode(content) as Map<String, dynamic>;

    final localeSplits = locale.split('-');

    Localization.load(
      Locale(localeSplits[0], localeSplits[1]),
      translations: Translations(data),
    );

    _isInitialized = true;
  }

  @override
  String translate(String key) {
    if (!_isInitialized) {
      fail("Translator was not initialized, wait for initializationFinished to complete");
    }
    return tr(key);
  }

  @override
  String languageCode() {
    return locale;
  }
}
