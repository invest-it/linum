import 'package:linum/screens/enter_screen/enums/input_type.dart';
import 'package:linum/screens/enter_screen/models/enter_screen_input.dart';


class ParsedInput<T extends dynamic> {
  final InputType type;
  final TextIndices? indices;
  final T value;
  final String raw;

  ParsedInput({
    required this.type,
    required this.value,
    required this.raw,
    required this.indices,
  });

  @override
  String toString() {
    return "ParsedInput(value: $value, raw: $raw, indices: $indices)";
  }
}
