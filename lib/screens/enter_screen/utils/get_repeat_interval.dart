import 'package:collection/collection.dart';
import 'package:linum/core/repeating/constants/standard_repeat_configs.dart';
import 'package:linum/core/repeating/enums/repeat_duration_type_enum.dart';
import 'package:linum/core/repeating/enums/repeat_interval.dart';

RepeatInterval getRepeatInterval(int duration, RepeatDurationType durationType) {
  final result = repeatConfigurations.values.firstWhereOrNull((config) =>
    config.durationType == durationType && config.duration == duration,
  );
  if (result == null) {
    return RepeatInterval.custom;
  }
  return result.interval;
}