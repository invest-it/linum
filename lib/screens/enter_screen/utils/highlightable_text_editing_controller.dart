import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:linum/screens/enter_screen/constants/hightlight_colors.dart';
import 'package:linum/screens/enter_screen/models/enter_screen_input.dart';
import 'package:linum/screens/enter_screen/models/placeholder_data.dart';
import 'package:linum/screens/enter_screen/models/suggestion.dart';
import 'package:linum/screens/enter_screen/models/suggestion_filters.dart';
import 'package:linum/screens/enter_screen/utils/example_string_builder.dart';
import 'package:linum/screens/enter_screen/utils/parsing/input_parser.dart';
import 'package:linum/screens/enter_screen/utils/suggestions/make_suggestions.dart';

final unicodeRangeStart = int.parse("E000", radix: 16);
final placeholderRegex = RegExp(r"(?:^|\s)([\uE000-\uF8FF])(?:\s|$)");



typedef PlaceholderMap = Map<String, PlaceholderData>;

Map<String, PlaceholderData> createPlaceholderList(EnterScreenInput parsed, int unicodeOffset) {
  final PlaceholderMap placeholders = {};
  final parsedList = parsed.toList();
  parsedList.sortByCompare((element) => element.indices.start, (a, b) => a.compareTo(b));

  int diffCounter = 0;
  for (int i = 0; i < parsedList.length; i++) {
    final match = parsedList[i];

    final unicode = String.fromCharCode(unicodeRangeStart + i + unicodeOffset);
    placeholders[unicode] = PlaceholderData(
      unicode: unicode,
      match: match,
      position: match.indices.start - diffCounter,
    );
    diffCounter += (match.indices.end - match.indices.start) - 1;
  }
  return placeholders;
}



String replaceWithPlaceholders(String text, Map<String, PlaceholderData> placeholders) {
  final buffer = StringBuffer();
  var counter = 0; // Current position in Text
  for (final placeholder in placeholders.values) {
    final start = placeholder.match.indices.start;
    final end = placeholder.match.indices.end;
    if (counter < start) {
      buffer.write(text.substring(counter, start));
    }
    buffer.write(placeholder.unicode);
    counter = end;
  }

  if (counter < text.length) {
    buffer.write(text.substring(counter, text.length));
  }
  return buffer.toString();
}

int calculateTextLengthDifference(int newCursor, Map<String, PlaceholderData> placeholders) {
  int counter = 0;
  for (final placeholder in placeholders.values) {
    if (placeholder.match.indices.start > newCursor) {
      break;
    }
    final diff = placeholder.match.indices.end - placeholder.match.indices.start - 1;
    counter += diff;
  }
  // print("Counter $counter");
  return counter;
}

TextSelection getSelectionFromCursor(int cursor) {
  return TextSelection.fromPosition(TextPosition(offset: cursor));
}



String restoreText(String newText, PlaceholderMap placeholderMap) {
  String text = newText;
  for (final entry in placeholderMap.entries) {

    text = text.replaceAll(entry.key, entry.value.match.raw);

  }
  return text;
}
// TODO Shorten loop
int restoreCursor(String newText, int newCursor, PlaceholderMap placeholderMap) {
  int counter = 0;
  // print(newCursor);
  // print(placeholderMap);
  for (final placeholder in placeholderMap.values) {
    if (placeholder.position >= newCursor) {
      // print("Broke");
      break;
    }
    final diff = placeholder.match.indices.end - placeholder.match.indices.start;
    counter += diff - 1;

  }
  // print("Counter $counter");
  return newCursor + counter;
}



class HighlightableTextEditingController extends TextEditingController {
  final ExampleStringBuilder exampleStringBuilder;
  final SuggestionFilters? suggestionFilters;

  HighlightableTextEditingController({
    required this.exampleStringBuilder,
    this.suggestionFilters,
    super.text,
  });

  String trueText = "";
  Map<String, PlaceholderData> _placeholderMap = {};
  Map<String, Suggestion> _suggestions = {};
  Map<String, Suggestion> get suggestions => _suggestions;

  EnterScreenInput? _parsed;
  EnterScreenInput? get parsed => _parsed;


  List<PlaceholderData> get sortedPlaceholders {
    final placeholders = _placeholderMap.values.toList();
    placeholders.sortByCompare((element) => element.match.indices.start, (a, b) => a.compareTo(b));
    return placeholders;
  }

  int offsetCounter = 0;


  @override
  set value(TextEditingValue newValue) {
    final int oldCursor = value.selection.base.offset;
    int newCursor = newValue.selection.base.offset;

    final String oldText = value.text;
    String newText = newValue.text;


    print("New: '$newText', $newCursor");
    print("Old: '$oldText', $oldCursor");
    if (oldText == newText) {
      if (newCursor == oldCursor) {
        super.value = newValue;
        return;
      }
      super.value = newValue;
      return;
    }

    final restoredText = restoreText(newText, _placeholderMap);
    final restoredCursor = restoreCursor(newText, newCursor, _placeholderMap);
    trueText = restoredText;
    // print("Restored: '$restoredText', $restoredCursor");


    final parsed = InputParser().parse(restoredText);

    offsetCounter++;
    if(offsetCounter > 3) {
      offsetCounter = 0;
    }
    final placeholders = createPlaceholderList(parsed, offsetCounter);
    exampleStringBuilder.rebuild(parsed);
    _parsed = parsed;
    _suggestions = makeSuggestions(
      restoredText,
      restoredCursor, // Cursor position
      categoryFilter: suggestionFilters?.categoryFilter,
      repeatFilter: suggestionFilters?.repeatFilter,
      dateFilter: suggestionFilters?.dateFilter,
    );
    // updatePlaceholders(newText, newCursor, placeholders);

    _placeholderMap = placeholders;


    newText = replaceWithPlaceholders(restoredText, placeholders);

    final textLengthDiff = calculateTextLengthDifference(restoredCursor, placeholders);
    newCursor = restoredCursor - textLengthDiff;

    print("Final: '$newText', $newCursor");
    print(newText.runes);

    final newSelection = getSelectionFromCursor(newCursor);
    final newComposing = TextRange(
        start: newValue.composing.start,
        end: newValue.composing.end == -1 ? -1 : newCursor,
    );
    print(newSelection);
    print(newValue.composing);
    print(newComposing);

    super.value = newValue.copyWith(
      text: newText,
      selection: newSelection,
      composing: newComposing,
    );
  }


  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style , required bool withComposing}) {
    assert(!value.composing.isValid || !withComposing || value.isComposingRangeValid);


    final text = trueText;

    final highlightStyle = style?.copyWith(color: Colors.white);

    style = style?.copyWith(
      height: 1.5,
    );
    final exampleTextStyle = style?.copyWith(color: Colors.black26);

    final List<InlineSpan> spans = [];

    var counter = 0; // Current position in Text
    for (final placeholder in sortedPlaceholders) {
      final start = placeholder.match.indices.start;
      final end = placeholder.match.indices.end;

      if (counter < start) {
        spans.add(
          TextSpan(text: text.substring(counter, start), style: style),
        );
      }

      spans.add(
        WidgetSpan(

          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 2.5),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              color: highlightColors[placeholder.match.type.name],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 2.5),
            child: Text(placeholder.match.raw, style: highlightStyle),
          ),
        ),
      );
      counter = end;
    }

    if (counter < text.length) {
      spans.add(
        TextSpan(text: text.substring(counter, text.length), style: style),
      );
    }

    // print(spans);
    if (!text.contains(trimTagRegex)) {
      spans.add(
        TextSpan(style: exampleTextStyle, text: exampleStringBuilder.value.item2),
      );
    }

    return TextSpan(
      children: spans,
    );
  }
}
