
import 'package:linum/common/types/filter_function.dart';
import 'package:linum/core/categories/models/category.dart';
import 'package:linum/core/repeating/enums/repeat_interval.dart';
import 'package:linum/core/repeating/models/repeat_configuration.dart';
import 'package:linum/screens/enter_screen/enums/input_flag.dart';
import 'package:linum/screens/enter_screen/enums/input_type.dart';
import 'package:linum/screens/enter_screen/enums/parsable_date.dart';
import 'package:linum/screens/enter_screen/models/parsed_input.dart';
import 'package:linum/screens/enter_screen/models/structured_parsed_data.dart';
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


  StructuredParsedData parse(String? input) {
    if (input == null || input.isEmpty) {
      return StructuredParsedData("");
    }

    final List<ParsedInput> parsedInputs = [];

    final splits = _splitInput(input);

    for (var i = 0; i < splits.length; i++) {
      final split = splits[i];

      if (split.startsWith(trimTagRegex)) {
        final parsedInput = _interpretTag(splits[i], input);
        if (parsedInput != null) {
          parsedInputs.add(parsedInput);
        }
        continue;
      }
      parsedInputs.addAll(
          NaturalLangParser().parse(split, input),
      );
    }


    return StructuredParsedData.fromParsedInputs(parsedInputs, input);
  }

  List<String> _splitInput(String input) {
    final splits = input.split(splitRegex);

    for (var i = 0; i < splits.length; i++) {
      splits[i] = splits[i].trimRight();
    }
    return splits;
  }

  ParsedInput? _interpretTag(String tag, String fullInput) {
    final trimmedTag = tag.replaceAll(trimTagRegex, "");
    final parsedTag = TagParser().parse(trimmedTag);
    return _handleFlag(
        flag: parsedTag.flag,
        tag: tag,
        fullInput: fullInput,
        parsedTag: parsedTag,
    );
  }

  ParsedInput? _handleFlag({
    required InputFlag? flag,
    required String tag,
    required String fullInput,
    required ParsedTag parsedTag,
  }) {
    switch(flag) {
      case InputFlag.category:
        return _handleCategoryFlag(tag, fullInput, parsedTag);
      case InputFlag.date:
        return _handleDateFlag(tag, fullInput, parsedTag);
      case InputFlag.repeatInfo:
        return _handleRepeatInfoFlag(tag, fullInput, parsedTag);
      default:
        return _handleNullFlag(tag, fullInput, parsedTag);
    }
  }

  ParsedInput? _handleNullFlag(
      String tag,
      String fullInput,
      ParsedTag parsedTag,
  ) {
    final categoryResult = _handleCategoryFlag(tag, fullInput, parsedTag);
    if (categoryResult != null) {
      return categoryResult;
    }

    final dateResult = _handleDateFlag(tag, fullInput, parsedTag);
    if (dateResult != null) {
      return dateResult;
    }

    final repeatInfoResult = _handleRepeatInfoFlag(tag, fullInput, parsedTag);
    if (repeatInfoResult != null) {
      return repeatInfoResult;
    }

    return null;
  }


  ParsedInput<Category>? _handleCategoryFlag(
      String tag,
      String fullInput,
      ParsedTag parsedTag,
  ) {
    final category = categoryParser(parsedTag.text, filter: categoryFilter);
    if (category != null) {
      return ParsedInput<Category>(
        type: InputType.category,
        indices: getTextIndices(tag.trimRight(), fullInput)!,
        value: category,
        raw: tag.trimRight(),
      );
    }
    return null;
  }

  ParsedInput<RepeatConfiguration>? _handleRepeatInfoFlag(
      String tag,
      String fullInput,
      ParsedTag parsedTag,
      ) {
    final result = repeatInfoParser(parsedTag.text, filter: repeatFilter);
    if (result != null) {
      return ParsedInput<RepeatConfiguration>(
        type: InputType.repeatInfo,
        indices: getTextIndices(tag.trimRight(), fullInput)!,
        value: result,
        raw: tag.trimRight(),
      );
    }
    return null;
  }

  ParsedInput<String>? _handleDateFlag(
      String tag,
      String fullInput,
      ParsedTag parsedTag,
      ) {
    final result = dateParser(parsedTag.text, filter: dateFilter);
    if (result != null) {
      return ParsedInput<String>(
        type: InputType.date,
        indices: getTextIndices(tag.trimRight(), fullInput)!,
        value: result,
        raw: tag.trimRight(),
      );
    }
    return null;
  }
}








// TODO: Entering a Category Name first fucks up the parser
