import 'package:linum/screens/enter_screen/models/parsed_input.dart';

class PlaceholderData {
  final ParsedInput match;
  final String unicode;
  final int position;
  PlaceholderData({
    required this.match,
    required this.unicode,
    required this.position,
  });

  @override
  String toString() {
    return "PlaceholderData(match: $match, unicode: $unicode, position: $position)";
  }
}
