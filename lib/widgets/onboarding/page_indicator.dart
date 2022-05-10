import 'package:flutter/cupertino.dart';
import 'package:linum/widgets/onboarding/page_indicator_item.dart';

class PageIndicator extends StatefulWidget {
  const PageIndicator({Key? key, required this.slideCount, required this.currentSlide}) : super(key: key);

  final int slideCount;
  final int currentSlide;

  @override
  State<PageIndicator> createState() => _PageIndicatorState();
}

class _PageIndicatorState extends State<PageIndicator> {

  List<Widget> _buildChildrenList() {
    final List<Widget> childrenList = <Widget>[];

    for (int i = 0; i < widget.slideCount; i++) {
      childrenList.add(PageIndicatorItem(isCurrentIndicator: i == widget.currentSlide));
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
