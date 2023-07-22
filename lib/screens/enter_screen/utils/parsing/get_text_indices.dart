import 'package:linum/screens/enter_screen/models/enter_screen_input.dart';

TextIndices? getTextIndices(
    String? substring,
    String raw, {
      int startIndex = 0,
}) {
      if (substring == null) {
            return null;
      }
      final start = raw.indexOf(substring);
      final end = start + substring.length;
      return (start: start + startIndex, end: end + startIndex);
}
