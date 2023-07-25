import 'package:linum/screens/enter_screen/enums/input_type.dart';
import 'package:linum/screens/enter_screen/models/structured_parsed_data.dart';


class ParsedInput<T extends dynamic> {
  final InputType type;
  final TextIndices indices;
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ParsedInput<T> &&
      other.type == type &&
      other.indices == indices &&
      other.value == value &&
      other.raw == raw;
  }

  @override
  int get hashCode {
    return type.hashCode ^
      indices.hashCode ^
      value.hashCode ^
      raw.hashCode;
  }
}
