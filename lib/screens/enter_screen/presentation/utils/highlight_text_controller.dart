import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/interfaces/translator.dart';
import 'package:linum/screens/enter_screen/domain/models/parsed_input.dart';
import 'package:linum/screens/enter_screen/domain/models/structured_parsed_data.dart';
import 'package:linum/screens/enter_screen/domain/models/suggestion.dart';
import 'package:linum/screens/enter_screen/domain/models/suggestion_filters.dart';
import 'package:linum/screens/enter_screen/domain/parsing/input_parser.dart';
import 'package:linum/screens/enter_screen/domain/suggesting/insert_suggestion.dart';
import 'package:linum/screens/enter_screen/domain/suggesting/make_suggestions.dart';
import 'package:linum/screens/enter_screen/presentation/constants/highlight_colors.dart';
import 'package:linum/screens/enter_screen/presentation/utils/example_string_builder.dart';
import 'package:linum/screens/enter_screen/presentation/utils/span_list_builder.dart';

TextSelection getSelectionFromCursor(int cursor) {
  return TextSelection.fromPosition(TextPosition(offset: cursor));
}

class HighlightTextEditingController extends TextEditingController {
  final ExampleStringBuilder exampleStringBuilder;
  final ParsingFilters? parsingFilters;
  final ITranslator translator;
  final GlobalKey cursorRefKey =
      GlobalKey(debugLabel: "TextEditingFieldCursorRef");

  HighlightTextEditingController({
    required this.exampleStringBuilder,
    required this.translator,
    this.parsingFilters,
    super.text,
  }) {
    cursorHeightOffset = verticalPadding * 2 + verticalMargin * 2 + 2;
  }

  Map<String, Suggestion> _suggestions = {};
  List<Suggestion> get suggestions => _suggestions.values.toList();

  StructuredParsedData? get parsed => _parsed;
  StructuredParsedData? _parsed;

  int offsetCounter = 0;

  final double verticalPadding = 2.5;
  final double verticalMargin = 1;
  late final double cursorHeightOffset;

  @override
  set value(TextEditingValue newValue) {
    final newCursor = newValue.selection.base.offset;

    final oldText = value.text;
    final newText = newValue.text;

    if (oldText == newText) {
      super.value = newValue;
      return;
    }

    final parser = InputParser(translator)
      ..categoryFilter = parsingFilters?.categoryFilter
      ..repeatFilter = parsingFilters?.repeatFilter
      ..dateFilter = parsingFilters?.dateFilter;
    final parsed = parser.parse(newText);

    exampleStringBuilder.rebuild(parsed);
    _parsed = parsed;
    _suggestions = makeSuggestions(
      text: newText,
      cursor: newCursor, // Cursor position
      translator: translator,
      categoryFilter: parsingFilters?.categoryFilter,
      repeatFilter: parsingFilters?.repeatFilter,
      dateFilter: parsingFilters?.dateFilter,
    );

    super.value = newValue;
  }

  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    assert(!value.composing.isValid ||
        !withComposing ||
        value.isComposingRangeValid);

    final parsedInputList = _parsed?.toList() ?? [];
    parsedInputList.sortByCompare(
        (element) => element.indices.start, (a, b) => a.compareTo(b));

    final builder = SpanListBuilder(
      verticalPadding: verticalPadding,
      horizontalPadding: 2.5,
      verticalMargin: verticalMargin,
      borderRadius: const Radius.circular(5.0),
      baseStyle: style,
      cursorRefKey: cursorRefKey,
      cursor: selection.base.offset,
    );

    var counter = 0; // Current position in Text

    for (final parsedInput in parsedInputList) {
      _addParsedInputToSpan(parsedInput, builder, counter);
      counter = parsedInput.indices.end;
    }

    _addRemainingChars(builder, counter);
    _addExampleString(builder);

    return TextSpan(
      children: builder.build(),
    );
  }

  void useSuggestion(Suggestion suggestion, Suggestion? flagSuggestion) {
    value = insertSuggestion(
      suggestion: suggestion,
      oldText: text,
      oldCursor: selection.base.offset,
      flagSuggestion: flagSuggestion,
    );
  }

  void _addRemainingChars(SpanListBuilder builder, int counter) {
    if (counter < text.length) {
      builder.addCharList(
        charList: text.substring(counter, text.length),
      );
    }
  }

  void _addExampleString(SpanListBuilder builder) {
    if (!text.contains(trimTagRegex)) {
      builder.addCharList(
        charList: exampleStringBuilder.value.item2,
        textColor: Colors.black26,
      );
    }
  }

  void _addParsedInputToSpan(
      ParsedInput parsedInput, SpanListBuilder builder, int counter) {
    final start = parsedInput.indices.start;

    if (counter < start) {
      builder.addCharList(
        charList: text.substring(counter, start),
      );
    }

    final highlightColor = highlightColors[parsedInput.type.name];
    assert(highlightColor != null);

    final raw = parsedInput.raw;

    builder.addHighlightedCharList(
      charList: raw,
      color: highlightColor!,
    );
  }
}
