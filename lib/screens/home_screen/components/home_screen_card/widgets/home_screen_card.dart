//  HomeScreenCard - Main Widget for the Home Screen Card
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//  (Refactored by damattl)

import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/components/screen_card/widgets/screen_card_side.dart';
import 'package:linum/common/components/screen_card/widgets/screen_card_skeleton.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:linum/screens/home_screen/components/home_screen_card/widgets/home_screen_card_back.dart';
import 'package:linum/screens/home_screen/components/home_screen_card/widgets/home_screen_card_front.dart';

class HomeScreenCard extends StatelessWidget {
  final FlipCardController controller;
  const HomeScreenCard({super.key, required this.controller});

  @override
  ScreenCardSkeleton build(BuildContext context) {
    final cardWidth = context.proportionateScreenWidth(345);
    final cardHeight = context.proportionateScreenHeight(196);

    return ScreenCardSkeleton(
      frontSide: ScreenCardSide(
        content: HomeScreenCardFront(),
        cardWidth: cardWidth,
        cardHeight: cardHeight,
      ),
      backSide: ScreenCardSide(
        content: HomeScreenCardBack(),
        cardWidth: cardWidth,
        cardHeight: cardHeight,
      ),
      flipCardController: controller,
    );
  }
}
