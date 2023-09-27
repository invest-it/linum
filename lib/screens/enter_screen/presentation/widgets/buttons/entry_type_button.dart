import 'package:flutter/material.dart';

class EntryTypeButton extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Color iconColor;
  final void Function()? onTap;

  const EntryTypeButton({
    super.key,
    required this.title,
    required this.iconData,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Icon(
              iconData,
              color: iconColor,
              size: 60,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge
                  ?.copyWith(color: Colors.black, fontSize: 16.0),

            ),
          ],
        ),
      ),
    );
  }
}
