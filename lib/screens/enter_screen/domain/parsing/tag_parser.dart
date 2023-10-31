import 'package:linum/screens/enter_screen/domain/enums/input_flag.dart';

typedef ParsedTag = ({InputFlag? flag, String text});

// Testable
class TagParser {
  final Map<String, InputFlag> flagMap;
  TagParser(this.flagMap);

   ParsedTag parse(String tag) {
    final splits = tag.split(":");
    if (splits.length > 1) {
      final flag = flagMap[splits[0].toUpperCase()];
      final value = splits[1];
      return (flag: flag, text: value);
    }
    return (flag: null, text: splits[0]);
  }
}
