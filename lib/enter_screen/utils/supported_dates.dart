import 'package:easy_localization/easy_localization.dart';
import 'package:linum/enter_screen/constants/parsable_date_map.dart';
import 'package:linum/enter_screen/enums/parsable_date.dart';

final supportedDates = <String, ParsableDate>{
  "tmrw": ParsableDate.tomorrow,
  "tmr": ParsableDate.tomorrow,
  "tdy": ParsableDate.today,
  "ydy": ParsableDate.yesterday,
};

void initSupportedDates() {
  for (final entry in parsableDateMap.entries) {
    supportedDates[entry.value.tr().toLowerCase()] = entry.key;
    supportedDates[entry.key.name] = entry.key;
  }
}
