import 'package:flutter/material.dart';

class EnterScreenAbortButton extends StatelessWidget {
  const EnterScreenAbortButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: const Icon(
        Icons.close,
        color: Colors.black26,
      ),
    );
  }
}
