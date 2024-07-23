import 'package:flutter/material.dart';

void _onTap() {}

class TagSelectorButton extends StatelessWidget {
  final String title;
  final String? symbol;
  final IconData? icon;
  final Color textColor;
  final bool showBadge;
  final void Function() onTap;
  const TagSelectorButton({
    super.key,
    required this.title,
    this.symbol,
    this.icon,
    this.textColor = Colors.black,
    this.onTap = _onTap,
    this.showBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    assert(symbol == null || icon == null);

    final List<Widget> iconWidgets = [];
    if (symbol != null) {
      iconWidgets.add(
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Text(
            symbol ?? "",
            style: TextStyle(color: textColor),
          ),
        ),
      );
    }
    if (icon != null) {
      iconWidgets.add(
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Icon(
            icon,
            size: 14.0,
            color: textColor,
          ),
        ),
      );
    }

    final badges = <Widget>[];
    if (showBadge) {
      badges.add(
        Positioned(
          top: -8,
          right: -16,
          child: Badge.count(
            count: 1,
            textColor: Colors.white,
            largeSize: 14,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFd2d2d2)),
          borderRadius: const BorderRadius.all(Radius.circular(5000)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...iconWidgets,
                Text(
                  title,
                  style: TextStyle(color: textColor, fontSize: 14),
                ),
              ],
            ),
            ...badges,
          ],
        ),
      ),
    );
  }
}
