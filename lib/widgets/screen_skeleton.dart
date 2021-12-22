import 'package:flutter/material.dart';
import 'package:linum/widgets/body_section.dart';
import 'package:linum/widgets/lip_section.dart';

class ScreenSkeleton extends StatelessWidget {
  final String head;
  final Widget body;
  final bool isInverted;

  const ScreenSkeleton({
    Key? key,
    required this.head,
    required this.body,
    required this.isInverted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LipSection(lipTitle: head, isInverted: isInverted),
        BodySection(body: body, isInverted: isInverted),
      ],
    );
  }
}
