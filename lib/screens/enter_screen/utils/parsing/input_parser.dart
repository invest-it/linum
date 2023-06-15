import 'package:linum/screens/enter_screen/constants/input_flag_map.dart';
import 'package:linum/screens/enter_screen/enums/input_flag.dart';
import 'package:linum/screens/enter_screen/models/enter_screen_input.dart';
import 'package:linum/screens/enter_screen/utils/parsing/amount_parsing.dart';
import 'package:linum/screens/enter_screen/utils/parsing/parser_functions.dart';

List<String> splitInput(String input) {
  final splitsByHashtag = input.split("#");
  final List<String> splits = [];
  for (final split in splitsByHashtag) {
    final splitsByAt = split.split("@");
    if (splitsByAt.length == 1) {
      splits.add(split);
      continue;
    }
    for (final atSplit in splitsByAt) {
      splits.add(atSplit);
    }
  }
  return splits;
}

EnterScreenInput parse(String? input) {
  if (input == null || input.isEmpty) {
    return EnterScreenInput(input ?? "");
  }

  final splits = splitInput(input);

  final amount = splits[0];
  final result = parseBaseInfo(amount, input);

  for (var i = 1; i < splits.length; i++) {
    final parsed = interpretTag(splits[i]);
    if (parsed != null) {
      result.parsedInputs.add(parsed);
    }
  }
  return result;
}

({InputFlag? flag, String text}) parseTag(String tag) {
  final splits = tag.split(":");
  if (splits.length > 1) {
    final flag = inputFlagMap[splits[0].toUpperCase()];
    final value = splits[1];
    return (flag: flag, text: value);
  }
  return (flag: null, text: splits[0]);
}

ParsedInput? interpretTag(String tag) {
  final parsed = parseTag(tag);
  if (parsed.flag != null) {
    final fun = parserFunctions[parsed.flag];
    if (fun != null) {
      final result = fun(parsed.text);
      if (result != null) {
        return (flag: parsed.flag!, text: result);
      }
    }
  } else {
    return findFitting(parsed.text);
  }
  return null;
}




// TODO: Entering a Category Name first fucks up the parser
