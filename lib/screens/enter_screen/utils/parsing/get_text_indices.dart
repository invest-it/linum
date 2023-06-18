import 'package:linum/screens/enter_screen/models/enter_screen_input.dart';

TextIndices? getTextIndices(
    String? substr,
    String raw, {
      int startIndex = 0,
}) {
      if (substr == null) {
            return null;
      }
      final start = raw.indexOf(substr);
      final end = start + substr.length;
      return (start: start + startIndex, end: end + startIndex);
}
