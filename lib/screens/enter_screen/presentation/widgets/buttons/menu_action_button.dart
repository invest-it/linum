import 'package:flutter/material.dart';

class MenuActionButton extends StatelessWidget {
  final EdgeInsets padding;
  final String label;
  final VoidCallback onPressed;
  const MenuActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.padding = EdgeInsets.zero,

  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: FilledButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(label),
        ),
      ),
    );
  }
}
