import 'package:flutter/material.dart';

class ChangeModeButton extends StatelessWidget {
  final void Function() onPressed;
  final String label;
  const ChangeModeButton({super.key, required this.label, required this.onPressed});


  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelMedium?.copyWith(
      color: Colors.black,
      fontSize: 16.0,
    );

    return GestureDetector(
      onTap: () => onPressed(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        child: Text(label, style: style),
      ),
    );
  }
}
