import 'package:flutter/material.dart';
import 'package:linum/backend_functions/local_app_localizations.dart';
import 'package:linum/frontend_functions/size_guide.dart';

class TimeWidget extends StatelessWidget {
  TimeWidget({required this.displayValue, this.isTranslated = false});

  final String displayValue;
  final bool isTranslated;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: proportionateScreenHeight(48),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          isTranslated
              ? displayValue.toUpperCase()
              : AppLocalizations.of(context)!
                  .translate(displayValue)
                  .toUpperCase(),
          style: Theme.of(context).textTheme.overline?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }
}
