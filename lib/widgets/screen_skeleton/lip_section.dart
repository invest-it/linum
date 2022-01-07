import 'package:flutter/material.dart';
import 'package:linum/frontend_functions/size_guide.dart';

class LipSection extends StatelessWidget {
  final String lipTitle;
  final bool isInverted;

  const LipSection({
    Key? key,
    required this.lipTitle,
    required this.isInverted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isInverted
        ? ClipRRect(
            child: Container(
              alignment: Alignment.bottomCenter,
              width: proportionateScreenWidth(375),
              height: proportionateScreenHeight(164),
              color: Theme.of(context).colorScheme.primary,
              child: Baseline(
                baselineType: TextBaseline.alphabetic,
                baseline: (proportionateScreenHeight(164) - 8),
                child: Text(lipTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6),
              ),
            ),
          )
        : ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.zero,
              bottom: Radius.circular(40),
            ),
            child: Container(
              alignment: Alignment.bottomCenter,
              width: proportionateScreenWidth(375),
              height: proportionateScreenHeight(164),
              color: Theme.of(context).colorScheme.primary,
              child: Baseline(
                baselineType: TextBaseline.alphabetic,
                baseline: (proportionateScreenHeight(164) - 12),
                child: Text(lipTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6),
              ),
            ),
          );
  }
}
