import 'package:linum/core/repeating/constants/standard_repeat_configs.dart';
import 'package:linum/screens/enter_screen/domain/constants/parsable_date_map.dart';
import 'package:linum/screens/enter_screen/domain/enums/input_flag.dart';
import 'package:linum/screens/enter_screen/domain/models/suggestion.dart';
import 'package:linum/screens/enter_screen/domain/suggesting/suggestable_categories.dart';

List<Suggestion> getSubSuggestions(InputFlag flag) {
  switch (flag) {
    case InputFlag.category:
      return getSuggestableCategories()
          .map((e) => Suggestion(label: e.value.label))
          .toList();
    case InputFlag.date:
      return parsableDateMap.entries
          .map((e) => Suggestion(label: e.value))
          .toList();
    case InputFlag.repeatInfo:
      return repeatConfigurations.entries
          .map((e) => Suggestion(label: e.value.label))
          .toList();
    default:
      return [];
  }
}
