import 'package:flutter/material.dart';
import 'package:linum/backend_functions/local_app_localizations.dart';

class ListHeader extends StatelessWidget {
  final String title;
  final String? tooltipMessage;

  ListHeader(this.title, {this.tooltipMessage});

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
          Text(AppLocalizations.of(context)!.translate(title),
              style: Theme.of(context).textTheme.overline),
          Tooltip(
            child: Align(
              heightFactor: 1,
              widthFactor: 1,
              child: Icon(
                Icons.help_outline_rounded,
                size: 10 * 1.8,
              ),
            ),
            message: AppLocalizations.of(context)!.translate(tooltipMessage!),
            triggerMode: TooltipTriggerMode.tap,
            padding: EdgeInsets.all(8.0),
            enableFeedback: false,
            preferBelow: false,
          ),
        ],
      );
    }
  }
}
