import 'package:flutter/material.dart';

class HomeScreenCardArrow extends StatelessWidget {
  final Color arrowColor;
  final Color arrowBoxColor;
  final bool isUpward;

  const HomeScreenCardArrow({
    Key? key,
    required this.arrowBoxColor,
    required this.arrowColor,
    this.isUpward = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: arrowBoxColor,
      ),
      child: Center(
        child: Icon(
          isUpward ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
          color: arrowColor,
        ),
      ),
    );
  }
}
