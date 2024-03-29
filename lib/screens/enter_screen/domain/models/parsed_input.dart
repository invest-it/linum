import 'package:linum/screens/enter_screen/domain/enums/input_type.dart';
import 'package:linum/screens/enter_screen/domain/models/structured_parsed_data.dart';


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

  factory ParsedInput.fromSubstring({
    required InputType type,
    required T value,
    required String text,
    required String substr,
  }) {
    return ParsedInput(
        type: type,
        value: value,
        raw: substr,
        indices: _getIndices(text, substr),
    );
  }

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


TextIndices _getIndices(String text, String substr) {
  final start = text.indexOf(substr);
  return (
    start: start,
    end: start + substr.length,
  );
}
