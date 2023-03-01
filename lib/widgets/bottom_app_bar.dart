//  Bottom App Bar - the Navigation Bar on the bottom of almost every screen.
//
//  Author: thebluebaronx
//  Co-Author: n/a
//

import 'package:flutter/material.dart';
import 'package:linum/providers/size_guide_provider.dart';
import 'package:provider/provider.dart';

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
  FABBottomAppBar({
    required this.items,
    required this.centerItemText,
    required this.backgroundColor,
    required this.color,
    required this.selectedColor,
    required this.notchedShape,
  });
  final List<BottomAppBarItem> items;
  final String centerItemText;
  final double notproportionateHeight = 64;
  final double minHeight = 64.0;
  final double iconSize = 26;
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
    final sizeGuideProvider = Provider.of<SizeGuideProvider>(context);

    final List<Widget> items = List.generate(widget.items.length, (int index) {
      return _buildTabItem(
        item: widget.items[index],
        index: index,
        sizeGuideProvider: sizeGuideProvider,
      );
    });
    items.insert(items.length >> 1, _buildMiddleTabItem(sizeGuideProvider));

    return BottomAppBar(
      shape: widget.notchedShape,
      color: widget.backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
    );
  }

  Widget _buildMiddleTabItem(SizeGuideProvider sizeGuideProvider) {
    return Expanded(
      child: SizedBox(
        height: sizeGuideProvider
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

  Widget _buildTabItem(
      {required BottomAppBarItem item,
      required int index,
      required SizeGuideProvider sizeGuideProvider}) {
    final Color color = item.selected ? widget.selectedColor : widget.color;
    return Expanded(
      child: Container(
        height: sizeGuideProvider
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
