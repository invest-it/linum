//  Home Screen Card Side - General Class for Layouting of one side of the HomeSceenCard
//
//  Author: NightmindOfficial
//  Co-Author: damattl
//  (Refactored)

import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:linum/providers/screen_card_provider.dart';
import 'package:linum/utilities/frontend/size_guide.dart';
import 'package:provider/provider.dart';

class ScreenCardSkeleton extends StatefulWidget {
  final Widget frontSide;
  final Widget? backSide;
  final double cardWidth;
  final double cardHeight;
  final FlipCardController? flipCardController;

  const ScreenCardSkeleton({
    super.key,
    required this.frontSide,
    this.backSide,
    required this.cardWidth,
    required this.cardHeight,
    this.flipCardController,
  });

  @override
  State<ScreenCardSkeleton> createState() => _ScreenCardSkeletonState();
}

class _ScreenCardSkeletonState<TData> extends State<ScreenCardSkeleton> {
  late FlipCardController? _flipCardController;

  @override
  void initState() {
    super.initState();
    if (widget.flipCardController != null) {
      _flipCardController = widget.flipCardController;
    } else {
      _flipCardController = widget.backSide != null ? FlipCardController() : null;
    }
  }

  @override
  Widget build(BuildContext context) {


    return ChangeNotifierProvider<ScreenCardProvider>(
      create: (_) => ScreenCardProvider(controller: _flipCardController),
      child: Column(
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
                  width: proportionateScreenWidth(widget.cardWidth), //345 old value
                  height: proportionateScreenHeight(widget.cardHeight), //196 old value
                  // color: Colors.grey[100],
                  child: widget.backSide == null
                      ? widget.frontSide
                      : FlipCard(
                          controller: _flipCardController,
                          front: widget.frontSide,
                          back: widget.backSide!,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


