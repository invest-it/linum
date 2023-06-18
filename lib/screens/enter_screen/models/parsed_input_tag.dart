import 'package:linum/screens/enter_screen/enums/input_flag.dart';
import 'package:linum/screens/enter_screen/models/enter_screen_input.dart';

class ParsedInputTag {
  final InputFlag flag;
  final TextIndices? indices;
  final String value;
  final String raw;

  ParsedInputTag({
    required this.flag,
    required this.value,
    required this.raw,
    required this.indices,
  });

  @override
  String toString() {
    return "ParsedInputTag(flag: $flag, value: $value, raw: $raw, indices: $indices)";
  }
}
