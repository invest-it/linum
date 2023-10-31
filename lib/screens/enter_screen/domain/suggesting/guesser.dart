import 'package:linum/screens/enter_screen/domain/models/suggestion.dart';

abstract class IGuesser {
  Map<String, Suggestion> suggest(String text);
}
