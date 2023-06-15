// TODO Work In Progress

import 'package:flutter/material.dart';
import 'package:linum/screens/enter_screen/utils/enter_screen_text_editing_controller.dart';

class TextHighlight extends StatelessWidget {
  final TextHighlightData highlightData;
  final TextStyle style;
  const TextHighlight(this.highlightData, {super.key, required this.style});

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr,);
    return textPainter.size;
  }

  @override
  Widget build(BuildContext context) {
    if (highlightData.color == Colors.white) {
      return Container(
        width: _textSize(highlightData.text, style.copyWith(color: Colors.transparent)).width - 3.5,
      );
    }
    return Container(
      padding: const EdgeInsets.all(1.0),
      decoration: BoxDecoration(
        color: highlightData.color,
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
      ),
      child: Text(highlightData.text, style: style.copyWith(color: Colors.transparent)),
    );
  }
}
