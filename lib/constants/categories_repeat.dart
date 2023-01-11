//  Categories Repeat - Constants File that inhabitates all Repeat Durations used in the Enter Screen.
//
//  Author: NightmindOfficial
//  Co-Author: damattl
//  (Refactored)

import 'package:flutter/material.dart';
import 'package:linum/constants/repeat_duration_type_enum.dart';
import 'package:linum/constants/settings_enums.dart';
import 'package:linum/models/entry_category.dart';
import 'package:linum/models/repeat_configuration.dart';

final Map<RepeatDuration, RepeatConfiguration> repeatConfigurations = {
  RepeatDuration.none: RepeatConfiguration(
    entryCategory: const EntryCategory(
      label: 'enter_screen.label-repeat-none',
      icon: Icons.sync_disabled_rounded,
    ),
    duration: null,
    durationType: null,
  ),
  RepeatDuration.daily: RepeatConfiguration(
    entryCategory: const EntryCategory(
      label: 'enter_screen.label-repeat-daily',
      icon: Icons.calendar_today_rounded,
    ),
    duration: const Duration(days: 1).inSeconds,
    durationType: RepeatDurationType.seconds,
  ),
  RepeatDuration.weekly: RepeatConfiguration(
    entryCategory: const EntryCategory(
      label: 'enter_screen.label-repeat-weekly',
      icon: Icons.calendar_view_week_rounded,
    ),
    duration: const Duration(days: 7).inSeconds,
    durationType: RepeatDurationType.seconds,
  ),
  RepeatDuration.monthly: RepeatConfiguration(
    entryCategory: const EntryCategory(
      label: 'enter_screen.label-repeat-30days',
      icon: Icons.calendar_view_month_rounded,
    ),
    duration: 1,
    durationType: RepeatDurationType.months,
  ),
  RepeatDuration.quarterly: RepeatConfiguration(
    entryCategory: const EntryCategory(
      label: 'enter_screen.label-repeat-quarterly',
      icon: Icons.grid_view_rounded,
    ),
    duration: 3,
    durationType: RepeatDurationType.months,
  ),
  RepeatDuration.semiannually: RepeatConfiguration(
    entryCategory: const EntryCategory(
      label: 'enter_screen.label-repeat-semiannually',
      icon: Icons.splitscreen_rounded,
    ),
    duration: 6,
    durationType: RepeatDurationType.months,
  ),
  RepeatDuration.annually: RepeatConfiguration(
    entryCategory: const EntryCategory(
      label: 'enter_screen.label-repeat-annually',
      icon: Icons.calendar_month_rounded,
    ),
    duration: 12,
    durationType: RepeatDurationType.months,
  )
  // TODO implement custom range picker
  // {
  //   "entryCategory": EntryCategory(
  //       label: AppLocalizations.of(context)!
  //           .translate('enter_screen/label-repeat-freeselect'),
  //       icon: Icons.repeat),
  //       "duration": null,
  // },
};
