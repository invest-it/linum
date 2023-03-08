//  HomeScreenCard - Main Widget for the Home Screen Card
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//  (Refactored by damattl)

import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:linum/widgets/screen_card/card_widgets/screen_card_skeleton.dart';
import 'package:linum/widgets/screen_card/home_screen_card/home_screen_card_back.dart';
import 'package:linum/widgets/screen_card/home_screen_card/home_screen_card_front.dart';

class HomeScreenCard extends StatelessWidget {
  final FlipCardController controller;
  const HomeScreenCard({super.key, required this.controller});

  @override
  ScreenCardSkeleton build(BuildContext context) {
    return ScreenCardSkeleton(
      frontSide: HomeScreenCardFront(),
      backSide: HomeScreenCardBack(),
      flipCardController: controller,
    );
  }
}
