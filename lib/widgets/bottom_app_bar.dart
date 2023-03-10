//  Bottom App Bar - the Navigation Bar on the bottom of almost every screen.
//
//  Author: thebluebaronx
//  Co-Author: n/a
//

import 'package:flutter/material.dart';
import 'package:linum/utilities/frontend/layout_helpers.dart';

class BottomAppBarItem {
  final IconData iconData;
  final String text;
  final bool selected;
  final Function() onTap;
  BottomAppBarItem({
    required this.iconData,
    required this.text,
    required this.selected,
    required this.onTap,
  });
}

class FABBottomAppBar extends StatefulWidget {
  const FABBottomAppBar({
    required this.items,
    required this.centerItemText,
    required this.backgroundColor,
    required this.color,
    required this.selectedColor,
    required this.notchedShape,
  });
  final List<BottomAppBarItem> items;
  final String centerItemText;
  double get notproportionateHeight => 64;
  double get minHeight => 64.0;
  double get iconSize => 26;
  final Color backgroundColor;
  final Color color;
  final Color selectedColor;
  final NotchedShape notchedShape;

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
        height: context
            .proportionateScreenHeight(widget.notproportionateHeight),
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
  }) {
    final Color color = item.selected ? widget.selectedColor : widget.color;
    return Expanded(
      child: Container(
        height: context
            .proportionateScreenHeight(widget.notproportionateHeight),
        constraints: BoxConstraints(minHeight: widget.minHeight),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: item.onTap,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(item.iconData, color: color, size: widget.iconSize),
                Text(
                  item.text,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
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
