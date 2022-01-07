import 'package:flutter/material.dart';
import 'package:linum/frontend_functions/size_guide.dart';

class BodySection extends StatelessWidget {
  final Widget body;
  final bool isInverted;

  const BodySection({
    Key? key,
    required this.body,
    required this.isInverted,
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
                  height: proportionateScreenHeight(250),
                  color: Theme.of(context).colorScheme.background,
                  child: Center(
                    child: Text("Hi"),
                  ),
                ),
              ),
            ),
          )
        : body;
  }
}
