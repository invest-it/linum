import 'package:flutter/material.dart';

class ScreenCardSide extends StatelessWidget {
  Widget content;
  double cardWidth;
  double cardHeight;
  ScreenCardSide({
    super.key,
    required this.content,
    required this.cardWidth,
    required this.cardHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
