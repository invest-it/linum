import 'package:flutter/material.dart';
import 'package:linum/frontend_functions/size_guide.dart';
import 'package:linum/providers/screen_index_provider.dart';
import 'package:provider/provider.dart';

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
  final double height = 56; //proportionateScreenHeight(64);
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
    final ScreenIndexProvider screenIndexProvider =
        Provider.of<ScreenIndexProvider>(context);

    final List<Widget> items = List.generate(widget.items.length, (int index) {
      return _buildTabItem(
        item: widget.items[index],
        index: index,
        onPressed: (innerdex) => screenIndexProvider.setPageIndex(innerdex),
        screenIndexProvider: screenIndexProvider,
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
    required ScreenIndexProvider screenIndexProvider,
  }) {
    final Color color = screenIndexProvider.pageIndex == index
        ? widget.selectedColor
        : widget.color;
    return Expanded(
      child: SizedBox(
        height: widget.height,
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
