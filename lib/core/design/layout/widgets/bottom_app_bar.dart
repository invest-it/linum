//  Bottom App Bar - the Navigation Bar on the bottom of almost every screen.
//
//  Author: thebluebaronx
//  Co-Author: n/a
//

import 'package:flutter/material.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';

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


class LinumNavigationBar extends StatelessWidget {
  const LinumNavigationBar({
    required this.items,
    required this.centerItemText,
    required this.backgroundColor,
    required this.iconColor,
    required this.selectedColor,
    required this.notchedShape,
    this.useInlineAB = false,
    this.onABPressed,
  });
  final void Function()? onABPressed;
  final bool useInlineAB;
  final List<BottomAppBarItem> items;
  final String centerItemText;
  double get notproportionateHeight => 64;
  double get minHeight => 64.0;
  double get iconSize => 26;
  final Color backgroundColor;
  final Color iconColor;
  final Color selectedColor;
  final NotchedShape notchedShape;

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = List.generate(this.items.length, (int index) {
      return _buildTabItem(
        context,
        item: this.items[index],
        index: index,
      );
    });

    if (useInlineAB) {
      final actionButton = Padding(
        padding: const EdgeInsets.only(left: 20),
        child: FloatingActionButton(
          onPressed: onABPressed,
          elevation: 0,
          backgroundColor: Colors.white,
          child: const Icon(Icons.add, color: Colors.black87),
        ),
      );

      items.add(actionButton);
    }

    return BottomAppBar(
      color: backgroundColor,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items,
      ),
    );
  }

  Widget _buildTabItem(BuildContext context, {
    required BottomAppBarItem item,
    required int index,
  }) {
    final Color color = item.selected ? selectedColor : iconColor;
    return Expanded(
      child: Container(
        height: context
            .proportionateScreenHeight(notproportionateHeight),
        constraints: BoxConstraints(minHeight: minHeight),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: item.onTap,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(item.iconData, color: color, size: iconSize),
                Text(
                  item.text,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
