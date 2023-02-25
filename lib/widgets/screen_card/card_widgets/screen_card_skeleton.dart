//  Home Screen Card Side - General Class for Layouting of one side of the HomeSceenCard
//
//  Author: NightmindOfficial
//  Co-Author: damattl
//  (Refactored)

import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:linum/providers/screen_card_provider.dart';
import 'package:provider/provider.dart';

class ScreenCardSkeleton extends StatefulWidget {
  final Widget frontSide;
  final Widget? backSide;
  final FlipCardController? flipCardController;

  const ScreenCardSkeleton({
    super.key,
    required this.frontSide,
    this.backSide,
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
      _flipCardController =
          widget.backSide != null ? FlipCardController() : null;
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
        ],
      ),
    );
  }
}
