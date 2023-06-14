import 'package:linum/screens/enter_screen/models/enter_screen_input.dart';

TextIndices? getTextIndices(
    String? text,
    String raw, {
      int startIndex = 0,
}) {
      if (text == null) {
            return null;
      }
      final start = raw.indexOf(text);
      final end = start + text.length;
      return (start: start + startIndex, end: end + startIndex);
}
