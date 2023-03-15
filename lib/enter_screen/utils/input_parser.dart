import 'package:linum/enter_screen/constants/input_flag_map.dart';
import 'package:linum/enter_screen/utils/parser_functions.dart';
import 'package:linum/enter_screen/enums/input_flag.dart';
import 'package:linum/enter_screen/models/enter_screen_input.dart';
import 'package:linum/enter_screen/utils/amount_parsing.dart';
import 'package:tuple/tuple.dart';

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
  final result = parseAmount(amount, input);

  for (var i = 1; i < splits.length; i++) {
    final parsed = interpretTag(splits[i]);
    if (parsed != null) {
      result.parsedInputs.add(parsed);
    }
  }
  print("${result.name ?? "No name"}: ${result.amount} ${result.currency}");
  for (final tag in result.parsedInputs) {
    print(tag);
  }
  return result;
}

Tuple2<InputFlag?, String> parseTag(String tag) {
  final splits = tag.split(":");
  if (splits.length > 1) {
    final flag = inputFlagMap[splits[0].toUpperCase()];
    final value = splits[1];
    return Tuple2(flag, value);
  }
  return Tuple2(null, splits[0]);
}

Tuple2<InputFlag, String>? interpretTag(String tag) {
  final parsed = parseTag(tag);
  if (parsed.item1 != null) {
    var fun = parserFunctions[parsed.item1];
    if (fun != null) {
      final result = fun(parsed.item2);
      if (result != null) {
        return Tuple2(parsed.item1!, result);
      }
    }
  } else {
    return findFitting(parsed.item2);
  }
  return null;
}




// TODO: Entering a Category Name first fucks up the parser

