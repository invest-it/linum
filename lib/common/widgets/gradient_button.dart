import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final LinearGradient gradient;
  final Widget child;
  final Size? minimumSize;

  const GradientButton({
    super.key,
    required this.onPressed,
    required this.gradient,
    required this.child,
    this.minimumSize,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: gradient,
        ),
        constraints: BoxConstraints(
          minWidth: minimumSize?.width ?? 64,
          minHeight: minimumSize?.height ?? 36,
        ),
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
