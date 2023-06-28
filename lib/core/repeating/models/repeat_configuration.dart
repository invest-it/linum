import 'package:flutter/material.dart';
import 'package:linum/core/repeating/enums/repeat_duration_type_enum.dart';
import 'package:linum/core/repeating/enums/repeat_interval.dart';


class RepeatConfiguration {
  final RepeatInterval interval;
  final String label;
  final IconData icon;
  final int? duration;
  final RepeatDurationType? durationType;

  const RepeatConfiguration({
    required this.interval,
    required this.label,
    required this.icon,
    required this.duration,
    required this.durationType,
  });

  @override
  String toString() {
    return 'RepeatConfiguration{'
        'interval: $interval, '
        'label: $label, '
        'icon: $icon, '
        'duration: $duration, '
        'durationType: $durationType'
        '}';
  }
}
