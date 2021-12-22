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
        ? Center(
            child: Text('Inverted Body (Card)'),
          )
        : body;
  }
}
