
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

    if (parsedTag.flag != null) {
      final fun = parserFunctions[parsedTag.flag];
      if (fun != null) {
        final result = fun(parsedTag.text);
        if (result != null) {
          return ParsedInputTag(
            flag: parsedTag.flag!,
            indices: getTextIndices(tag.trimRight(), fullInput),
            value: result,
            raw: tag.trimRight(),
          );
        }
      }
    } else {
      final guess = findFitting(parsedTag.text);
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
