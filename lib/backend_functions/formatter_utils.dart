import 'dart:math';

import 'package:flutter/services.dart';

TextEditingValue textManipulation(
    TextEditingValue oldValue, TextEditingValue newValueParameter,
    {TextInputFormatter? textInputFormatter,
    String formatPattern(String filteredString)?}) {
  final originalUserInput = newValueParameter.text;

  // remove all invalid characters

  TextEditingValue newValue = textInputFormatter != null
      ? textInputFormatter.formatEditUpdate(oldValue, newValueParameter)
      : newValueParameter;

  // current selection
  int selectionIndex = newValue.selection.end;

  // format original string

  final newText =
      formatPattern != null ? formatPattern(newValue.text) : newValue.text;

  if (newText == newValue.text) {
    return newValue;
  }

  // count # of inserts in new string
  int insertCount = 0;

  // count # of original input characters in new string
  int inputCount = 0;

  bool _isUserInput(String s) {
    if (textInputFormatter == null) return originalUserInput.contains(s);
    return newValue.text.contains(s);
  }

  for (int i = 0; i < newText.length && inputCount < selectionIndex; i++) {
    final character = newText[i];
    if (_isUserInput(character)) {
      inputCount++;
    } else {
      insertCount++;
    }
  }

  // adjust selection according to # of selected characters
  selectionIndex += insertCount;
  selectionIndex = min(selectionIndex, newText.length);

  if (selectionIndex - 1 >= 0 &&
      selectionIndex - 1 < newText.length &&
      !_isUserInput(newText[selectionIndex - 1])) {
    selectionIndex--;
  }

  return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: selectionIndex),
      composing: TextRange.empty);
}
