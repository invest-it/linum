import 'package:linum/screens/enter_screen/models/suggestion.dart';

abstract class IGuesser {
  Map<String, Suggestion> suggest(String text);
}