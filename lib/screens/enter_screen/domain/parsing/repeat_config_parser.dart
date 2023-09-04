import 'package:linum/common/types/filter_function.dart';
import 'package:linum/core/repeating/constants/standard_repeat_configs.dart';
import 'package:linum/core/repeating/enums/repeat_interval.dart';
import 'package:linum/core/repeating/models/repeat_configuration.dart';
import 'package:linum/screens/enter_screen/domain/parsing/parser.dart';
import 'package:linum/screens/enter_screen/domain/utils/supported_values.dart';

class RepeatConfigParser implements IParser<RepeatConfiguration> {
  final Filter<RepeatInterval>? filter;

  RepeatConfigParser({
    required this.filter,
  });

  @override
  RepeatConfiguration? parse(String input) {
    final lowercase = input.trim().toLowerCase();
    final repeatInterval = SupportedValues.repeatIntervals[lowercase];
    if (repeatInterval == null) {
      return null;
    }

    if (filter == null || filter!(repeatInterval)) {
      return repeatConfigurations[repeatInterval];
    }

    return null;
  }


}
