import 'package:linum/constants/repeat_duration_type_enum.dart';
import 'package:linum/models/entry_category.dart';

class RepeatConfiguration {
  final EntryCategory entryCategory;
  final int? duration;
  final RepeatDurationType? durationType;

  RepeatConfiguration({
    required this.entryCategory,
    required this.duration,
    required this.durationType,
  });
}
