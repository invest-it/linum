//  Page Indicator Item - One "Dot" on a PageIndicator.
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//  (Refactored by damattl)

import 'package:flutter/material.dart';

class PageIndicatorItem extends StatefulWidget {
  const PageIndicatorItem({
    super.key,
    required this.isCurrentIndicator,
  });

  final bool isCurrentIndicator;

  @override
  State<PageIndicatorItem> createState() => _PageIndicatorItemState();
}

class _PageIndicatorItemState extends State<PageIndicatorItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.isCurrentIndicator ? 8 : 5,
      height: widget.isCurrentIndicator ? 8 : 5,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.isCurrentIndicator
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
