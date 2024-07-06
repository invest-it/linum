//  Body Section - the lower part of the Screen Skeleton.
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//

import 'package:flutter/material.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';

class BodySection extends StatelessWidget {
  final Widget body;
  final bool isInverted;
  final bool hasScreenCard;

  const BodySection({
    super.key,
    required this.body,
    required this.isInverted,
    this.hasScreenCard = false,
  });

  @override
  Widget build(BuildContext context) {

    return isInverted
        ? Expanded(
            // ignore: use_colored_box
            child: Container(
              color: Theme.of(context).colorScheme.primary,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(64),
                ),
                // ignore: use_colored_box
                child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: Padding(
                    padding: hasScreenCard
                        ? EdgeInsets.only(
                            top: context
                                .proportionateScreenHeight(196 - 25),
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
              padding: hasScreenCard
                  ? EdgeInsets.only(
                      top:
                          context.proportionateScreenHeight(196 - 25),
                    )
                  : EdgeInsets.zero,
              child: body,
            ),
          );
  }
}
