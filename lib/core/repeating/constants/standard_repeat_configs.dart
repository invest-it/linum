import 'package:flutter/material.dart';
import 'package:linum/core/repeating/enums/repeat_duration_type_enum.dart';
import 'package:linum/core/repeating/enums/repeat_interval.dart';
import 'package:linum/core/repeating/models/repeat_configuration.dart';

final repeatConfigurations = <RepeatInterval, RepeatConfiguration>{
  RepeatInterval.none: const RepeatConfiguration(
    interval: RepeatInterval.none,
    label: 'enter_screen.repeat.none',
    icon: Icons.sync_disabled_rounded,
    duration: null,
    durationType: null,
  ),
  RepeatInterval.daily: RepeatConfiguration(
    interval: RepeatInterval.daily,
    label: 'enter_screen.repeat.daily',
    icon: Icons.calendar_today_rounded,
    duration: const Duration(days: 1).inSeconds,
    durationType: RepeatDurationType.seconds,
  ),
  RepeatInterval.weekly: RepeatConfiguration(
    interval: RepeatInterval.weekly,
    label: 'enter_screen.repeat.weekly',
    icon: Icons.calendar_view_week_rounded,
    duration: const Duration(days: 7).inSeconds,
    durationType: RepeatDurationType.seconds,
  ),
  RepeatInterval.monthly: const RepeatConfiguration(
    interval: RepeatInterval.monthly,
    label: 'enter_screen.repeat.thirty_days',
    icon: Icons.calendar_view_month_rounded,
    duration: 1,
    durationType: RepeatDurationType.months,
  ),
  RepeatInterval.quarterly: const RepeatConfiguration(
    interval: RepeatInterval.quarterly,
    label: 'enter_screen.repeat.quarterly',
    icon: Icons.grid_view_rounded,
    duration: 3,
    durationType: RepeatDurationType.months,
  ),
  RepeatInterval.semianually: const RepeatConfiguration(
    interval: RepeatInterval.semianually,
    label: 'enter_screen.repeat.semiannually',
    icon: Icons.splitscreen_rounded,
    duration: 6,
    durationType: RepeatDurationType.months,
  ),
  RepeatInterval.anually: const RepeatConfiguration(
    interval: RepeatInterval.anually,
    label: 'enter_screen.repeat.annually',
    icon: Icons.calendar_month_rounded,
    duration: 12,
    durationType: RepeatDurationType.months,
  ),
  RepeatInterval.custom: const RepeatConfiguration(
    interval: RepeatInterval.custom,
    label: 'enter_screen.repeat.custom',
    icon: Icons.build_rounded,
    duration: null,
    durationType: null,
  ),

  // TODO implement custom range picker
  // {
  //   "entryCategory": EntryCategory(
  //       label: AppLocalizations.of(context)!
  //           .translate('enter_screen/label-repeat-freeselect'),
  //       icon: Icons.repeat),
  //       "duration": null,
  // },
};
