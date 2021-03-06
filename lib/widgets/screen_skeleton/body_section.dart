//  Body Section - the lower part of the Screen Skeleton.
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//

import 'package:flutter/material.dart';
import 'package:linum/utilities/frontend/size_guide.dart';

class BodySection extends StatelessWidget {
  final Widget body;
  final bool isInverted;
  final bool hasHomeScreenCard;

  const BodySection({
    Key? key,
    required this.body,
    required this.isInverted,
    this.hasHomeScreenCard = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isInverted
        ? Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primary,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(64),
                ),
                child: Container(
                  color: Theme.of(context).colorScheme.background,
                  child: Padding(
                    padding: hasHomeScreenCard
                        ? EdgeInsets.only(
                            top: proportionateScreenHeight(196 - 25),
                          )
                        : EdgeInsets.zero,
                    child: body,
                  ),
                ),
              ),
            ),
          )
        : Expanded(
            child: Padding(
              padding: hasHomeScreenCard
                  ? EdgeInsets.only(top: proportionateScreenHeight(196 - 25))
                  : EdgeInsets.zero,
              child: body,
            ),
          );
  }
}
