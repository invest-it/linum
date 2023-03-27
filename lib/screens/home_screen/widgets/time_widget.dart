//  Time Widget - Formats Timestamps to a human-readable format
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:linum/screens/home_screen/enums/time_widget_date.dart';

// ignore_for_file: deprecated_member_use
//TODO DEPRECATED

//TODO: RemoveFromBudgetScreen

class TimeWidget extends StatelessWidget {
  const TimeWidget({
    this.label,
    this.timeWidgetDate,
    this.isTranslated = false,
    super.key,
  });

  final String? label;
  final TimeWidgetDate? timeWidgetDate;
  final bool isTranslated;


  @override
  Widget build(BuildContext context) {
    assert(timeWidgetDate != null || label != null);

    var usedLabel = timeWidgetDate?.toLabel();
    usedLabel ??= label;

    return SizedBox(
      width: double.infinity,
      height: context.proportionateScreenHeight(32),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          isTranslated
              ? usedLabel!.toUpperCase()
              : tr(usedLabel!).toUpperCase(),
          style: Theme.of(context).textTheme.overline?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }
}
