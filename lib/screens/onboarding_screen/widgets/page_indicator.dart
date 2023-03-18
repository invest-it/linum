//  Page Indicator - Typically a row of grey-ish circles on the bottom of a PageView which tells you 1) How many pages there are 2) which page is currently shown.
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//  (Refactored by damattl)

import 'package:flutter/cupertino.dart';
import 'package:linum/screens/onboarding_screen/widgets/page_indicator_item.dart';

class PageIndicator extends StatefulWidget {
  const PageIndicator({
    super.key,
    required this.slideCount,
    required this.currentSlide,
  });

  final int slideCount;
  final int currentSlide;

  @override
  State<PageIndicator> createState() => _PageIndicatorState();
}

class _PageIndicatorState extends State<PageIndicator> {
  List<Widget> _buildChildrenList() {
    final List<Widget> childrenList = <Widget>[];

    for (int i = 0; i < widget.slideCount; i++) {
      childrenList
          .add(PageIndicatorItem(isCurrentIndicator: i == widget.currentSlide));
      if (i != widget.slideCount - 1) {
        childrenList.add(
          const SizedBox(
            width: 12,
          ),
        );
      }
    }

    return childrenList;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _buildChildrenList(),
    );
  }
}
