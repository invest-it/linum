import 'package:easy_localization/easy_localization.dart';
import 'package:linum/core/repeating/constants/standard_repeat_configs.dart';
import 'package:linum/core/repeating/enums/repeat_interval.dart';
import 'package:linum/screens/enter_screen/domain/constants/parsable_date_map.dart';
import 'package:linum/screens/enter_screen/domain/enums/parsable_date.dart';

class SupportedValues {
  final _dates = <String, ParsableDate>{
    "tmrw": ParsableDate.tomorrow,
    "tmr": ParsableDate.tomorrow,
    "tdy": ParsableDate.today,
    "ydy": ParsableDate.yesterday,
  };
  static Map<String, ParsableDate> get dates => SupportedValues.instance()._dates;

  final _repeatIntervals = <String, RepeatInterval>{
    "dly": RepeatInterval.daily,
    "wkly": RepeatInterval.weekly,
    "wkl": RepeatInterval.weekly,
    "mnt": RepeatInterval.monthly,
    "mntl": RepeatInterval.monthly,
  };
  static Map<String, RepeatInterval> get repeatIntervals => SupportedValues.instance()._repeatIntervals;

  void _initDates() {
    for (final entry in parsableDateMap.entries) {
      _dates[entry.value.tr().toLowerCase()] = entry.key;
      _dates[entry.key.name] = entry.key;
    }
  }

  void _initRepeatIntervals() {
    for (final entry in repeatConfigurations.entries) {
      _repeatIntervals[entry.value.label.tr().toLowerCase()] = entry.key;
      _repeatIntervals[entry.key.name] = entry.key;
    }
  }

  SupportedValues._() {
    _initDates();
    _initRepeatIntervals();
  }

  static SupportedValues? _instance;

  factory SupportedValues.instance() {
    return _instance ??= SupportedValues._();
  }
}
