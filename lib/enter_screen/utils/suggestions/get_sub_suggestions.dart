import 'package:linum/enter_screen/constants/parsable_date_map.dart';
import 'package:linum/constants/standard_categories.dart';
import 'package:linum/constants/standard_repeat_configs.dart';
import 'package:linum/enter_screen/enums/input_flag.dart';
import 'package:linum/enter_screen/models/suggestion.dart';

List<Suggestion> getSubSuggestions(InputFlag flag) {
  switch (flag) {
    case InputFlag.category:
      return standardCategories.entries
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
