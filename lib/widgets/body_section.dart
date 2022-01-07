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
    //initialize Responsive Behaviour
    SizeGuide().init(context);

    return isInverted
        ? Container(
            color: Theme.of(context).colorScheme.primary,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
                bottom: Radius.zero,
              ),
              child: Container(
                height: proportionateScreenHeight(250),
                color: Theme.of(context).colorScheme.onBackground,
                child: Center(
                  child: Text("Hi"),
                ),
              ),
            ),
          )
        : body;
  }
}
