import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:linum/screens/enter_screen/constants/hightlight_colors.dart';
import 'package:linum/screens/enter_screen/models/enter_screen_input.dart';
import 'package:linum/screens/enter_screen/utils/enter_screen_text_editing_controller.dart';

const placeholderColor = Colors.white;

class HighlightsBuilder {
  final String newText;
  final EnterScreenInput parsed;
  final List<TextHighlightData> highlights = [];

  HighlightsBuilder(this.newText, this.parsed);

  void _addHighlight(TextIndices indices, Color color) {
    highlights.add((
      indices: indices,
      text: newText.substring(indices.start, indices.end),
      color: color,
    ),);
  }

  TextHighlightData createPlaceholder(TextIndices indices) {
    return (
      indices: indices,
      text: newText.substring(indices.start, indices.end),
      color: placeholderColor,
    );
  }

  List<TextHighlightData> build() {
    if (parsed.amountIndices?.start != parsed.amountIndices?.end) {
      _addHighlight(parsed.amountIndices!, highlightColors.amount);
    }

    if (parsed.nameIndices?.start != parsed.nameIndices?.end) {
      _addHighlight(parsed.nameIndices!, highlightColors.name);
    }

    if (parsed.currencyIndices?.start != parsed.currencyIndices?.end) {
      _addHighlight(parsed.currencyIndices!, highlightColors.currency);
    }

    // TODO: Implement for parsedElements as well

    if (highlights.isEmpty) {
      return highlights;
    }

    highlights.sortByCompare((element) => element.indices.start, (a, b) => a.compareTo(b));


    final List<({int position, TextHighlightData placeholder})> inserts = [];

    print(highlights);
    for (var i = 0; i < highlights.length - 1; i++) {
      final currentHighlight = highlights[i];
      final nextHighlight = highlights[i + 1];



      final diff = nextHighlight.indices.start - (currentHighlight.indices.end);
      if (diff != 0) {
        inserts.add((
          position: i + 1,
          placeholder: createPlaceholder((
            start: currentHighlight.indices.end,
            end: nextHighlight.indices.start
          ),)
        ),);
      }
    }

    for (var i = 0; i < inserts.length; i++) {
      final element = inserts[i];
      print(element);
      print(element.placeholder.text.length);
      highlights.insert(element.position + i, element.placeholder);
    }

    return highlights;
  }
}

