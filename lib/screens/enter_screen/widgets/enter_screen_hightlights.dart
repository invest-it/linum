// TODO Work In Progress

import 'package:flutter/material.dart';
import 'package:linum/screens/enter_screen/models/enter_screen_input.dart';
import 'package:linum/screens/enter_screen/utils/enter_screen_text_editing_controller.dart';
import 'package:linum/screens/enter_screen/widgets/text_highlight.dart';

class EnterScreenHighlights extends StatefulWidget {
  final EnterScreenTextEditingController _controller;
  final ScrollController textScrollController;
  final ScrollController scrollController = ScrollController();
  final TextStyle textStyle;

  EnterScreenHighlights({
    super.key,
    required EnterScreenTextEditingController controller,
    required this.textScrollController,
    required this.textStyle,
  }) : _controller = controller;

  @override
  State<EnterScreenHighlights> createState() => _EnterScreenHighlightsState();
}

class _EnterScreenHighlightsState extends State<EnterScreenHighlights> {
  EnterScreenInput? parsed;
  List<TextHighlightData> highlights = [];
  double scrollOffset = 0.0;

  @override
  void initState() {
    widget._controller.highlightsStream.listen((highlights) {
      setState(() {
        this.highlights = highlights;
      });

    });

    widget.textScrollController.addListener(() {
      widget.scrollController.jumpTo(widget.textScrollController.offset);
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.scrollController,
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...highlights.map((highlight) {
            return TextHighlight(
              highlight,
              style: widget.textStyle,
            );
          }).toList()
        ],
      ),
    );
  }
}

