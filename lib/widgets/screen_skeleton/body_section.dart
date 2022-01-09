import 'package:flutter/material.dart';
import 'package:linum/frontend_functions/size_guide.dart';

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
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(64),
                  bottom: Radius.zero,
                ),
                child: Container(
                  color: Theme.of(context).colorScheme.background,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: proportionateScreenHeight(196 - 25)),
                    child: body,
                  ),
                ),
              ),
            ),
          )
        : Expanded(
            child: Padding(
              padding:
                  EdgeInsets.only(top: proportionateScreenHeight(196 - 25)),
              child: body,
            ),
          );
  }
}
