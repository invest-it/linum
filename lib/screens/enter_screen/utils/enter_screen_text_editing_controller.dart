
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:linum/screens/enter_screen/models/enter_screen_input.dart';
import 'package:linum/screens/enter_screen/models/suggestion.dart';
import 'package:linum/screens/enter_screen/models/suggestion_filters.dart';
import 'package:linum/screens/enter_screen/utils/example_string_builder.dart';
import 'package:linum/screens/enter_screen/utils/highlights_builder.dart';
import 'package:linum/screens/enter_screen/utils/parsing/input_parser.dart';
import 'package:linum/screens/enter_screen/utils/suggestions/make_suggestions.dart';
import 'package:rxdart/rxdart.dart';

typedef TextHighlightData = ({Color color, TextIndices indices, String text});


class EnterScreenTextEditingController extends TextEditingController {
  final ExampleStringBuilder exampleStringBuilder;

  final SuggestionFilters? suggestionFilters;

  EnterScreenTextEditingController({
    super.text,
    required this.exampleStringBuilder,
    this.suggestionFilters,
  });


  Map<String, Suggestion> _suggestions = {};
  Map<String, Suggestion> get suggestions => _suggestions;

  EnterScreenInput? _parsed;
  EnterScreenInput? get parsed => _parsed;


  @override
  set value(TextEditingValue newValue) {
    assert(
    !newValue.composing.isValid || newValue.isComposingRangeValid,
    'New TextEditingValue $newValue has an invalid non-empty composing range '
        '${newValue.composing}. It is recommended to use a valid composing range, '
        'even for readonly text fields',
    );

    final newOffset = newValue.selection.base.offset;
    if (value.text != newValue.text) {
      _onChange(newValue.text, newOffset);
    }

    super.value = newValue;
  }

  void _onChange(String newText, int cursor) {
    final parsed  = parse(newText);
    exampleStringBuilder.rebuild(parsed);
    _parsed = parsed;
    _suggestions = makeSuggestions(
      newText,
      cursor, // Cursor position
      categoryFilter: suggestionFilters?.categoryFilter,
      repeatFilter: suggestionFilters?.repeatFilter,
      dateFilter: suggestionFilters?.dateFilter,
    );
    recalculateHighlights(newText);
  }

  final _highlightsBehaviourSubject = BehaviorSubject<List<TextHighlightData>>();
  Stream<List<TextHighlightData>> get highlightsStream => _highlightsBehaviourSubject.stream;


  void recalculateHighlights(String newText) {
    final parsed = _parsed;
    if (parsed != null) {
      final highlights = HighlightsBuilder(newText, parsed).build();
      _highlightsBehaviourSubject.add(highlights);
    } else {
      _highlightsBehaviourSubject.add([]);
    }
  }


  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style , required bool withComposing}) {
    assert(!value.composing.isValid || !withComposing || value.isComposingRangeValid);


    final highlightTextStyle = style?.copyWith(color: Colors.white);
    final exampleTextStyle = style?.copyWith(color: Colors.black26);
    final List<TextSpan> spans = [];

    var counter = 0; // Current position in Text
    if (_highlightsBehaviourSubject.hasValue) {
      for (final span in _highlightsBehaviourSubject.value) {
        // If highlight indices start after current write position add prev chars first
        if (span.indices.start > counter) {
          spans.add(
            TextSpan(
              style: style,
              text: text.substring(counter, span.indices.start),
            ),
          );
        }
        // Add highlighted text with special style (just the font-color)
        spans.add(
          TextSpan(style: highlightTextStyle, text: span.text),
        );
        // Set the write position at the end of the highlighted text
        counter = span.indices.end;
      }
    }

    // Add the rest of the text, if there is any
    if (counter < text.length) {
      spans.add(
        TextSpan(style: style, text: text.substring(counter)),
      );
    }

    // Add the examples
    spans.add(
        TextSpan(style: exampleTextStyle, text: exampleStringBuilder.value.item2),
    );

    return TextSpan(
      children: spans,
    );
    // TODO: Might not need composing in this way
    /*
    // If the composing range is out of range for the current text, ignore it to
    // preserve the tree integrity, otherwise in release mode a RangeError will
    // be thrown and this EditableText will be built with a broken subtree.
    final bool composingRegionOutOfRange = !value.isComposingRangeValid || !withComposing;

    if (composingRegionOutOfRange) {
      return TextSpan(style: style, text: text);
    }

    final TextStyle composingStyle = style?.merge(
        const TextStyle(
          decoration: TextDecoration.underline,
          color: Colors.red,
        ),
    ) ?? const TextStyle(decoration: TextDecoration.underline);

    return TextSpan(
      style: style,
      children: <TextSpan>[
        TextSpan(text: value.composing.textBefore(value.text)),
        TextSpan(
          style: composingStyle,
          text: value.composing.textInside(value.text),
        ),
        TextSpan(text: value.composing.textAfter(value.text)),
      ],
    );
    */
  }

  /// Check that the [selection] is inside of the composing range.
  bool _isSelectionWithinComposingRange(TextSelection selection) {
    return selection.start >= value.composing.start && selection.end <= value.composing.end;
  }
}
