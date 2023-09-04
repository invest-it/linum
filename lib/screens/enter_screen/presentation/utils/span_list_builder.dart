
import 'package:flutter/material.dart';


class SpanListBuilder {

  List<InlineSpan> spans = [];
  final double verticalPadding;
  final double horizontalPadding;
  final double verticalMargin;
  final Radius borderRadius;
  final TextStyle? baseStyle;

  SpanListBuilder({
    required this.verticalPadding,
    required this.horizontalPadding,
    required this.borderRadius,
    required this.verticalMargin,
    this.baseStyle,
  });

  Color _highlightColor = Colors.black;
  Color _highlightTextColor = Colors.white;

  void setHighlightColor(Color color, {Color textColor = Colors.white}) {
    _highlightColor = color;
    _highlightTextColor = textColor;
  }

  void addChar({
    required String char,
    Color? textColor,
  }) {
    assert(char.length == 1);

    TextStyle? style = baseStyle;
    if (textColor != null) {
      style = style?.copyWith(color: textColor);
    }

    spans.add(
      WidgetSpan(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: verticalMargin),
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          child: Text(
            char,
            style: style,
          ),
        ),
      ),
    );
  }

  EdgeInsets _getCorrectHighlightPadding(bool isStart, bool isEnd) {
    if (isStart && isEnd) {
      return EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
      );
    }
    if (isEnd) {
      return EdgeInsets.fromLTRB(
        0.0,
        verticalPadding,
        horizontalPadding,
        verticalPadding,
      );
    }
    if (isStart) {
      return EdgeInsets.fromLTRB(
        horizontalPadding,
        verticalPadding,
        0.0,
        verticalPadding,
      );
    }

    return EdgeInsets.symmetric(vertical: verticalPadding);
  }

  BorderRadius? _getCorrectHighlightBorderRadius(bool isStart, bool isEnd) {
    if (isEnd && isStart) {
      return BorderRadius.all(borderRadius);
    }
    if (isEnd) {
      return BorderRadius.only(
        topRight: borderRadius,
        bottomRight: borderRadius,
      );
    }
    if (isStart) {
      return BorderRadius.only(
        topLeft: borderRadius,
        bottomLeft: borderRadius,
      );
    }
    return null;
  }

  void addHighlightedChar({
    required String char,
    bool isEnd = false,
    bool isStart = false,
    List<InlineSpan>? spanList,
  }) {
    assert(char.isNotEmpty);
    final span = WidgetSpan(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: verticalMargin),
        decoration: BoxDecoration(
          color: _highlightColor,
          borderRadius: _getCorrectHighlightBorderRadius(isStart, isEnd),
        ),
        padding: _getCorrectHighlightPadding(isStart, isEnd),
        child: Text(
          char,
          style: baseStyle?.copyWith(
            color: _highlightTextColor,
          ),
        ),
      ),
    );

    if (spanList != null) {
      spanList.add(span);
      return;
    }
    spans.add(span);
  }


  void addHighlightedCharList({
    required String charList,
    required Color color,
    Color textColor = Colors.white,
    bool includesStart = true,
    bool includeEnd = true,
  }) {
    assert(charList.isNotEmpty);
    setHighlightColor(
      color,
      textColor: textColor,
    );

    if (charList.length == 1 && includesStart && includesStart) {
      addHighlightedChar(char: charList[0], isStart: true, isEnd: true);
      return;
    }

    final List<InlineSpan> spanList = [];

    for (int i = 0; i < charList.length; i++) {
      final char = charList[i];
      if (i == 0 && includesStart) {
        addHighlightedChar(char: char, isStart: true, spanList: spanList);
        continue;
      }
      if (i == charList.length - 1 && includeEnd) {
        addHighlightedChar(char: char, isEnd: true, spanList: spanList);
        continue;
      }
      addHighlightedChar(char: char, spanList: spanList);
    }

    if (includesStart && includeEnd) {
      spans.add(
        TextSpan(
          children: spanList,
        ),
      );
      return;
    }

    spans.addAll(spanList);
  }

  void addCharList({
    required String charList,
    Color? textColor,
  }) {
    assert(charList.isNotEmpty);
    for (int i = 0; i < charList.length; i++) {
      addChar(char: charList[i], textColor: textColor);
    }
  }

  List<InlineSpan> build() {
    return spans;
  }
}
