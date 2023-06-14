// TODO Work In Progress

import 'package:flutter/material.dart';
import 'package:linum/screens/enter_screen/utils/enter_screen_text_editing_controller.dart';

class TextHighlight extends StatelessWidget {
  final TextHighlightData highlightData;
  final TextStyle? baseStyle;
  const TextHighlight(this.highlightData, {super.key, this.baseStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1.0),
      decoration: BoxDecoration(
        color: highlightData.color,
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
      ),
      child: Text(highlightData.text, style: baseStyle?.copyWith(color: Colors.transparent)),
    );
  }
}
