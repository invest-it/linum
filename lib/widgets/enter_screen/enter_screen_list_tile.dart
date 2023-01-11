import 'package:flutter/material.dart';

class EnterScreenListTile extends StatelessWidget {
  final GestureTapCallback onTap;
  final Icon icon;
  final String label;
  final String currentSelection;
  const EnterScreenListTile({
    super.key,
    required this.onTap,
    required this.icon,
    required this.label,
    required this.currentSelection,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color:
                    Theme.of(context).colorScheme.background,),
                borderRadius: BorderRadius.circular(5),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 2.0,
                    offset: Offset(0.5, 2.0),
                    // shadow direction: bottom right
                  )
                ],
              ),
              child: icon,
            ),
            const SizedBox(width: 20),
            Text("$label:"),
            const SizedBox(width: 5),
            Text(currentSelection),
          ],
        ),
      ),
    );
  }
}
