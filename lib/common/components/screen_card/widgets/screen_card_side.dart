import 'package:flutter/material.dart';

class ScreenCardSide extends StatelessWidget {
  final Widget content;
  final double cardWidth;
  final double cardHeight;
  const ScreenCardSide({
    super.key,
    required this.content,
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
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Material(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/cubes.png"),
                    // opacity: 0.99,
                    fit: BoxFit.cover,
                  ),
                ),
                width: cardWidth, //345 old value
                height: cardHeight, //196 old value
                // color: Colors.grey[100],
                child: content,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
