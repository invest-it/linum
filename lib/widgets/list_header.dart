//  List Header - can be used as a title for a list. Used on the Settings Screen to differentiate between settings categories. Comes with its own tooltip if needed.
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//

import 'package:flutter/material.dart';
import 'package:linum/utilities/backend/local_app_localizations.dart';

class ListHeader extends StatelessWidget {
  final String title;
  final String? tooltipMessage;

  const ListHeader(this.title, {this.tooltipMessage});

  @override
  Widget build(BuildContext context) {
    if (tooltipMessage == null) {
      return Text(
        AppLocalizations.of(context)!.translate(title),
        style: Theme.of(context).textTheme.overline,
      );
    } else {
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        children: [
          Text(
            AppLocalizations.of(context)!.translate(title),
            style: Theme.of(context).textTheme.overline,
          ),
          Tooltip(
            message: AppLocalizations.of(context)!.translate(tooltipMessage!),
            triggerMode: TooltipTriggerMode.tap,
            padding: const EdgeInsets.all(8.0),
            enableFeedback: false,
            preferBelow: false,
            child: const Align(
              heightFactor: 1,
              widthFactor: 1,
              child: Icon(
                Icons.help_outline_rounded,
                size: 10 * 1.8,
              ),
            ),
          ),
        ],
      );
    }
  }
}
