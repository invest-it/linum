//  HomeScreenCard - Main Widget for the Home Screen Card
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//  (Refactored by damattl)

// ignore: unused_import
import 'dart:developer' as dev;
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:linum/utilities/frontend/size_guide.dart';
import 'package:linum/widgets/screen_card/card_widgets/screen_card_skeleton.dart';
import 'package:linum/widgets/screen_card/home_screen_card/home_screen_card_back.dart';
import 'package:linum/widgets/screen_card/home_screen_card/home_screen_card_front.dart';


class HomeScreenCard extends StatelessWidget {
  final FlipCardController controller;
  const HomeScreenCard({super.key, required this.controller});

  @override
  ScreenCardSkeleton build(BuildContext context) {
    return ScreenCardSkeleton(
      cardWidth: proportionateScreenWidth(345),
      cardHeight: proportionateScreenHeight(196),
      frontSide: HomeScreenCardFront(),
      backSide: HomeScreenCardBack(),
      flipCardController: controller,
    );
  }
}
