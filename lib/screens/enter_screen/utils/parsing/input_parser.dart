
import 'package:linum/screens/enter_screen/models/enter_screen_input.dart';
import 'package:linum/screens/enter_screen/models/parsed_input_tag.dart';
import 'package:linum/screens/enter_screen/utils/parsing/base_input_parser.dart';
import 'package:linum/screens/enter_screen/utils/parsing/get_text_indices.dart';
import 'package:linum/screens/enter_screen/utils/parsing/parser_functions.dart';
import 'package:linum/screens/enter_screen/utils/parsing/tag_parser.dart';

final RegExp splitRegex = RegExp("(?=#)|(?=@)");
final RegExp trimTagRegex = RegExp("(#)|(@)");

class InputParser {
  EnterScreenInput parse(String? input) {
    if (input == null || input.isEmpty) {
      return EnterScreenInput(input ?? "");
    }

    final splits = _splitInput(input);

    final amount = splits[0];
    final result = NaturalLangParser().parse(amount, input);

    for (var i = 0; i < splits.length; i++) {
      final split = splits[i];

      if (split.startsWith(trimTagRegex)) {
        final parsed = _interpretTag(splits[i], input);
        if (parsed != null) {
          result.parsedInputs.add(parsed);
        }
      }



    }
    return result;
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
            indices: getTextIndices(tag, fullInput),
            value: result,
            raw: tag,
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
          raw: tag,
          indices: getTextIndices(tag, fullInput),
      );
    }
    return null;
  }
}








// TODO: Entering a Category Name first fucks up the parser
