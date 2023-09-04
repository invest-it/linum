import 'package:linum/screens/enter_screen/domain/constants/input_flag_map.dart';
import 'package:linum/screens/enter_screen/domain/enums/input_flag.dart';

typedef ParsedTag = ({InputFlag? flag, String text});

class TagParser {
   ParsedTag parse(String tag) {
    final splits = tag.split(":");
    if (splits.length > 1) {
      final flag = inputFlagMap[splits[0].toUpperCase()];
      final value = splits[1];
      return (flag: flag, text: value);
    }
    return (flag: null, text: splits[0]);
  }
}
