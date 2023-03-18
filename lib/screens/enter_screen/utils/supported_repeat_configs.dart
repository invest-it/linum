import 'package:easy_localization/easy_localization.dart';
import 'package:linum/core/repeating/constants/standard_repeat_configs.dart';
import 'package:linum/core/repeating/enums/repeat_interval.dart';

final supportedRepeatIntervals = <String, RepeatInterval>{
  "dly": RepeatInterval.daily,
  "wkly": RepeatInterval.weekly,
  "wkl": RepeatInterval.weekly,
  "mnt": RepeatInterval.monthly,
  "mntl": RepeatInterval.monthly,
};

void initSupportedRepeatIntervals() {
  for (final entry in repeatConfigurations.entries) {
    supportedRepeatIntervals[entry.value.label.tr().toLowerCase()] = entry.key;
    supportedRepeatIntervals[entry.key.name] = entry.key;
  }
}
