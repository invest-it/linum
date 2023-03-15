import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/enter_screen/models/suggestion.dart';

TextEditingValue insertSuggestion({
  required Suggestion suggestion,
  required String oldText,
  required int oldCursor,
  Suggestion? parentSuggestion,
}) {
  final preCursorText = oldText.substring(0, oldCursor);
  String translatedValue;
  int lastTagPosition;

  if (parentSuggestion != null) {
    translatedValue =
        "${parentSuggestion.display(tr)}:${suggestion.display(tr)}";
    lastTagPosition = preCursorText.lastIndexOf(RegExp(r'[#@]'));
  } else {
    translatedValue =
        suggestion.display(tr) + (suggestion.isInputFlag ? ":" : "");

    lastTagPosition = preCursorText.lastIndexOf(RegExp(r'[#@:]'));
  }

  final cleanedPreCursorText = preCursorText.substring(0, lastTagPosition + 1);

  final newText = cleanedPreCursorText +
      translatedValue +
      oldText.substring(oldCursor, oldText.length);

  final newCursor = cleanedPreCursorText.length + translatedValue.length;
  return TextEditingValue(
      text: newText,
      selection: TextSelection.fromPosition(TextPosition(offset: newCursor)));
}
