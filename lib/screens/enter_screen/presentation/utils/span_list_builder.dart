import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SpanListBuilder {

  List<InlineSpan> spans = [];
  final double verticalPadding;
  final double horizontalPadding;
  final double verticalMargin;
  final Radius borderRadius;
  late final TextStyle? baseStyle;
  final GlobalKey cursorRefKey;
  final int cursor;
  late final double lineHeight;

  int _charCount = 0;

  SpanListBuilder({
    required this.verticalPadding,
    required this.horizontalPadding,
    required this.borderRadius,
    required this.verticalMargin,
    required this.cursorRefKey,
    required this.cursor,
    this.baseStyle,
  }) {
    lineHeight = baseStyle?.height ?? 1.0;
  }

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

    _charCount += 1;

    spans.add(
      PaddedSpan(
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        content: char,
        key: _charCount == cursor ? cursorRefKey : null,
        textStyle: style,
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

    _charCount += 1;


    final span = PaddedSpan(
      key: _charCount == cursor ? cursorRefKey : null,
      margin: EdgeInsets.symmetric(vertical: verticalMargin),
      padding:  _getCorrectHighlightPadding(isStart, isEnd),
      content: char,
      decoration: BoxDecoration(
        color: _highlightColor,
        borderRadius: _getCorrectHighlightBorderRadius(isStart, isEnd),
      ),
      textStyle: baseStyle?.copyWith(
        color: _highlightTextColor,
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

class PaddedSpan extends WidgetSpan {
  final TextStyle? textStyle;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Key? key;
  final String content;
  final BoxDecoration? decoration;

  PaddedSpan({
    this.textStyle,
    this.margin = EdgeInsets.zero,
    required this.padding,
    required this.content,
    this.decoration,
    super.alignment = PlaceholderAlignment.middle,
    this.key,
  }): super(
    child: SizedBox(
      height: (textStyle?.fontSize ?? 16) * (textStyle?.height ?? 1.0),
      child: Padding(
        padding: margin,
        child: Container(
          key: key,
          decoration: decoration,
          padding: padding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                content,
                style: textStyle?.copyWith(
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
