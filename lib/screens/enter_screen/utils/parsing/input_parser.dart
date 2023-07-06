
import 'package:linum/common/types/filter_function.dart';
import 'package:linum/core/categories/models/category.dart';
import 'package:linum/core/repeating/enums/repeat_interval.dart';
import 'package:linum/screens/enter_screen/enums/input_flag.dart';
import 'package:linum/screens/enter_screen/enums/parsable_date.dart';
import 'package:linum/screens/enter_screen/models/enter_screen_input.dart';
import 'package:linum/screens/enter_screen/models/parsed_input.dart';
import 'package:linum/screens/enter_screen/models/parsed_input_tag.dart';
import 'package:linum/screens/enter_screen/utils/parsing/get_text_indices.dart';
import 'package:linum/screens/enter_screen/utils/parsing/natural_lang_parser.dart';
import 'package:linum/screens/enter_screen/utils/parsing/parser_functions.dart';
import 'package:linum/screens/enter_screen/utils/parsing/tag_parser.dart';


final RegExp splitRegex = RegExp("(?=#)|(?=@)");
final RegExp trimTagRegex = RegExp("(#)|(@)");

class InputParser {
  Filter<Category>? categoryFilter;
  Filter<RepeatInterval>? repeatFilter;
  Filter<ParsableDate>? dateFilter;


  EnterScreenInput parse(String? input) {
    if (input == null || input.isEmpty) {
      return EnterScreenInput(input ?? "");
    }

    final List<ParsedInput> parsedInputs = [];

    final splits = _splitInput(input);

    for (var i = 0; i < splits.length; i++) {
      final split = splits[i];

      if (split.startsWith(trimTagRegex)) {
        final parsedTag = _interpretTag(splits[i], input);
        if (parsedTag != null) {
          parsedInputs.add(ParsedInput<String>(
            type: parsedTag.flag.toInputType(),
            value: parsedTag.value,
            raw: parsedTag.raw,
            indices: parsedTag.indices!,
          ),);
        }
        continue;
      }
      parsedInputs.addAll(
          NaturalLangParser().parse(split, input),
      );
    }


    return EnterScreenInput.fromParsedInputs(parsedInputs, input);
  }

  List<String> _splitInput(String input) {
    final splits = input.split(splitRegex);

    for (var i = 0; i < splits.length; i++) {
      splits[i] = splits[i].trimRight();
    }
    return splits;
  }

  ParsedInputTag? _interpretTag(String tag, String fullInput) {
    final trimmedTag = tag.replaceAll(trimTagRegex, "");
    final parsedTag = TagParser().parse(trimmedTag);

    switch(parsedTag.flag) {
      case InputFlag.category:
        final result = categoryParser(parsedTag.text, filter: categoryFilter);
        if (result != null) {
          return ParsedInputTag(
            flag: InputFlag.category,
            indices: getTextIndices(tag.trimRight(), fullInput),
            value: result,
            raw: tag.trimRight(),
          );
        }
      case InputFlag.repeatInfo:
        final result = repeatInfoParser(parsedTag.text, filter: repeatFilter);
        if (result != null) {
          return ParsedInputTag(
            flag: InputFlag.repeatInfo,
            indices: getTextIndices(tag.trimRight(), fullInput),
            value: result,
            raw: tag.trimRight(),
          );
        }
      case InputFlag.date:
        final result = dateParser(parsedTag.text, filter: dateFilter);
        if (result != null) {
          return ParsedInputTag(
            flag: InputFlag.date,
            indices: getTextIndices(tag.trimRight(), fullInput),
            value: result,
            raw: tag.trimRight(),
          );
        }
      case null:
        final guess = findFitting(
          parsedTag.text,
          categoryFilter: categoryFilter,
          repeatFilter: repeatFilter,
          dateFilter: dateFilter,
        );
        if (guess == null) {
          return null;
        }
        return ParsedInputTag(
          flag: guess.flag,
          value: guess.value,
          raw: tag.trimRight(),
          indices: getTextIndices(tag.trimRight(), fullInput),
        );
    }

    return null;
  }
}








// TODO: Entering a Category Name first fucks up the parser
