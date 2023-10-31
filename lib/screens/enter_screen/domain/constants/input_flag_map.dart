import 'package:linum/common/interfaces/translator.dart';
import 'package:linum/screens/enter_screen/domain/constants/suggestion_defaults.dart';
import 'package:linum/screens/enter_screen/domain/enums/input_flag.dart';

String? _initializedWithLanguage;

final _inputFlagMap = <String, InputFlag>{
  "KATEGORIE": InputFlag.category,
  "CATEGORY": InputFlag.category,
  "CAT": InputFlag.category,
  "C": InputFlag.category,
  "K": InputFlag.category,
  "DATUM": InputFlag.date,
  "DATE": InputFlag.date,
  "D": InputFlag.date,
  "WIEDERHOLUNG": InputFlag.repeatInfo,
  "REPEATINFO": InputFlag.repeatInfo,
  "REPEAT": InputFlag.repeatInfo,
  "REPETITION": InputFlag.repeatInfo,
  "R": InputFlag.repeatInfo,
  "W": InputFlag.repeatInfo,
};

void _mergeWithLanguageDefaults(ITranslator translator) {
  for (final entry in flagSuggestionDefaults.entries) {
    final key = translator.translate(entry.value).toUpperCase();
    _inputFlagMap[key] = entry.key;
  }
}

Map<String, InputFlag> getInputFlagMap(ITranslator translator) {
  if (_initializedWithLanguage == null
      || _initializedWithLanguage != translator.languageCode()) {

    _mergeWithLanguageDefaults(translator);
    _initializedWithLanguage = translator.languageCode();
  }

  return Map.unmodifiable(_inputFlagMap);
}
