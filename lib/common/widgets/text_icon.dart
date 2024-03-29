import 'package:flutter/material.dart';

class TextIcon extends StatelessWidget {
  final String text;
  final bool selected;
  const TextIcon(this.text, {super.key, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: Center(
        child: Text(
          text,
          overflow: TextOverflow.visible,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
          softWrap: false,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: !selected
              ? const Color.fromRGBO(136, 136, 136, 1)
              : Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
