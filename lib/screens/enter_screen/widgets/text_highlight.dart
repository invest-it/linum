// TODO Work In Progress

import 'package:flutter/material.dart';
import 'package:linum/screens/enter_screen/utils/enter_screen_text_editing_controller.dart';

class TextHighlight extends StatelessWidget {
  final TextHighlightData highlightData;
  final TextStyle style;
  final double paddingY;
  final double paddingX;

  const TextHighlight(this.highlightData, {
    super.key,
    required this.style,
    required this.paddingX,
    required this.paddingY,
  });

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr,)
      ..layout();
    return textPainter.size;
  }

  @override
  Widget build(BuildContext context) {
    if (highlightData.color == Colors.white) {
      final size = _textSize(
          highlightData.text,
          style.copyWith(color: Colors.transparent),
      ).width - (paddingX * 2 + 0.5);
      return Container(
        width: size > 0.0 ? size : 0.0,
      );
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: paddingY, horizontal: paddingX),
      decoration: BoxDecoration(
        color: highlightData.color,
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
      ),
      child: Text(highlightData.text, style: style.copyWith(color: Colors.transparent)),
    );
  }
}
