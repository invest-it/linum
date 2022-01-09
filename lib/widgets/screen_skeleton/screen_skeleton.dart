import 'package:flutter/material.dart';
import 'package:linum/frontend_functions/size_guide.dart';
import 'package:linum/widgets/home_screen/home_screen_card.dart';
import 'package:linum/widgets/screen_skeleton/body_section.dart';
import 'package:linum/widgets/screen_skeleton/lip_section.dart';

class ScreenSkeleton extends StatelessWidget {
  final String head;
  final Widget body;
  final bool isInverted;
  final bool hasHomeScreenCard;

  const ScreenSkeleton({
    Key? key,
    required this.head,
    required this.body,
    required this.isInverted,
    this.hasHomeScreenCard = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            LipSection(
              lipTitle: head,
              isInverted: isInverted,
            ),
            BodySection(
              body: body,
              isInverted: isInverted,
            ),
          ],
        ),
        Positioned(
          top: proportionateScreenHeight(164 - 25),
          left: 0,
          right: 0,
          child: HomeScreenCard(
            balance: 1081.46,
            income: 1200.00,
            expense: 1200 - 1081.46,
          ),
        ),
      ],
    );
  }
}
