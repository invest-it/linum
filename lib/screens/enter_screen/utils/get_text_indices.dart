import 'package:tuple/tuple.dart';

Tuple2<int, int>? getTextIndices(
    String? text,
    String raw, {
      int startIndex = 0,
}) {
      if (text == null) {
            return null;
      }
      final start = raw.indexOf(text);
      final end = start + text.length;
      return Tuple2(start + startIndex, end + startIndex);
}
