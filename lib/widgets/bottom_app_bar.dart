//  Bottom App Bar - the Navigation Bar on the bottom of almost every screen.
//
//  Author: thebluebaronx
//  Co-Author: n/a
//

import 'package:flutter/material.dart';
import 'package:linum/utilities/frontend/size_guide.dart';

class BottomAppBarItem {
  BottomAppBarItem({required this.iconData, required this.text});
  IconData iconData;
  String text;
}

class FABBottomAppBar extends StatefulWidget {
  FABBottomAppBar({
    required this.items,
    required this.centerItemText,
    required this.backgroundColor,
    required this.color,
    required this.selectedColor,
    required this.notchedShape,
    required this.onTabSelected,
  });
  final List<BottomAppBarItem> items;
  final String centerItemText;
  final double height = proportionateScreenHeight(64);
  final double minHeight = 64.0;
  final double iconSize = proportionateScreenHeight(24);
  final Color backgroundColor;
  final Color color;
  final Color selectedColor;
  final NotchedShape notchedShape;
  final ValueChanged<int> onTabSelected;

  @override
  State<StatefulWidget> createState() => FABBottomAppBarState();
}

class FABBottomAppBarState extends State<FABBottomAppBar> {
  @override
  Widget build(BuildContext context) {

    final List<Widget> items = List.generate(widget.items.length, (int index) {
      return _buildTabItem(
        item: widget.items[index],
        index: index,
        onPressed: (innerdex) => {}, // TODO: screenIndexProvider.setPageIndex(innerdex),
      );
    });
    items.insert(items.length >> 1, _buildMiddleTabItem());

    return BottomAppBar(
      shape: widget.notchedShape,
      color: widget.backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
    );
  }

  Widget _buildMiddleTabItem() {
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: widget.iconSize),
            Text(
              widget.centerItemText,
              style: TextStyle(color: widget.color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required BottomAppBarItem item,
    required int index,
    required ValueChanged<int> onPressed,
  }) {
    final Color color = // TODO: screenIndexProvider.pageIndex == index
        1 == index // TODO: REMOVE
        ? widget.selectedColor
        : widget.color;
    return Expanded(
      child: Container(
        height: widget.height,
        constraints: BoxConstraints(minHeight: widget.minHeight),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => onPressed(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(item.iconData, color: color, size: widget.iconSize),
                Text(
                  item.text,
                  style: TextStyle(
                    color: color,
                    fontSize: proportionateScreenHeight(12),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
