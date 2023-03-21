import 'package:flutter/material.dart';

void _onTap() {}

class TagSelectorButton extends StatelessWidget {
  final String title;
  final String symbol;
  final Color textColor;
  final void Function() onTap;
  const TagSelectorButton({
    super.key,
    required this.title,
    required this.symbol,
    this.textColor = Colors.black,
    this.onTap = _onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFd2d2d2)),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: EdgeInsets.only(right: symbol != "" ? 5 : 0),
            child: Text(
              symbol,
              style: TextStyle(color: textColor),
            ),
          ),
          Text(
            title,
            style: TextStyle(color: textColor, fontSize: 14),
          ),
        ],
        ),
      ),
    );
  }
}
