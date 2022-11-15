//  Home Screen Card Side - General Class for Layouting of one side of the HomeSceenCard
//
//  Author: NightmindOfficial
//  Co-Author: damattl
//  (Refactored)

import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:linum/models/home_screen_card_data.dart';
import 'package:linum/utilities/frontend/size_guide.dart';

class HomeScreenCardSkeleton extends StatelessWidget {
  final FlipCardController flipCardController;
  final HomeScreenCardData data;
  final Widget body;
  final double cardWidth;
  final double cardHeight;
  const HomeScreenCardSkeleton({
    super.key,
    required this.flipCardController,
    required this.data,
    required this.body,
    required this.cardWidth,
    required this.cardHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(64),
                blurRadius: 16.0,
                spreadRadius: 1.0,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Material(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/v01-cubes-12.png"),
                    // opacity: 0.99,
                    fit: BoxFit.cover,
                  ),
                ),
                width: proportionateScreenWidth(cardWidth), //345 old value
                height: proportionateScreenHeight(cardHeight), //196 old value
                // color: Colors.grey[100],
                child: body,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
