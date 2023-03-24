import 'package:easy_localization/easy_localization.dart';
import 'package:linum/screens/enter_screen/constants/suggestion_defaults.dart';
import 'package:linum/screens/enter_screen/enums/input_flag.dart';
import 'package:linum/screens/enter_screen/utils/date_formatter.dart';
import 'package:linum/screens/enter_screen/models/enter_screen_data.dart';

String generateStringFromExistingData(EnterScreenData data) {
  const dFormatter = DateFormatter();
  var base = "${data.amount} ${data.currency?.name ?? "EUR"}";
  if (data.name != null || data.name != "") {
    base += " ${data.name}";
  }
  if (data.category != null) {
    base += " #${flagSuggestionDefaults[InputFlag.category]?.tr()}:"
        "${data.category!.label.tr()}";
  }
  if (data.date != null) {
    base += " #${flagSuggestionDefaults[InputFlag.date]?.tr()}:"
        "${dFormatter.format(data.date!)?.tr()}";
  }

  return base;
  
}
