import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/utils/debug.dart';
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
      isPlaceholder: false,
    ),);
  }

  TextHighlightData createPlaceholder(TextIndices indices) {
    return (
      indices: indices,
      text: newText.substring(indices.start, indices.end),
      color: placeholderColor,
      isPlaceholder: true,
    );
  }

  List<TextHighlightData> build() {
    if (parsed.amount?.indices?.start != parsed.amount?.indices?.end) {
      _addHighlight(parsed.amount!.indices!, highlightColors.amount);
    }

    if (parsed.name?.indices?.start != parsed.name?.indices?.end) {
      _addHighlight(parsed.name!.indices!, highlightColors.name);
    }

    if (parsed.currency?.indices?.start != parsed.currency?.indices?.end) {
      _addHighlight(parsed.currency!.indices!, highlightColors.currency);
    }

    if (parsed.category?.indices?.start != parsed.category?.indices?.end) {
      _addHighlight(parsed.category!.indices!, highlightColors.category);
    }

    if (parsed.date?.indices?.start != parsed.date?.indices?.end) {
      _addHighlight(parsed.date!.indices!, highlightColors.date);
    }

    if (parsed.repeatInfo?.indices?.start != parsed.repeatInfo?.indices?.end) {
      _addHighlight(parsed.repeatInfo!.indices!, highlightColors.repeatInfo);
    }


    if (highlights.isEmpty) {
      return highlights;
    }

    highlights.sortByCompare((element) => element.indices.start, (a, b) => a.compareTo(b));


    final List<({int position, TextHighlightData placeholder})> inserts = [];

    debug(highlights);
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
      debug(element);
      debug(element.placeholder.text.length);
      highlights.insert(element.position + i, element.placeholder);
    }

    return highlights;
  }
}
