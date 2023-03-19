import 'package:flutter/material.dart';

class EnterScreenMenu extends StatelessWidget {
  final String title;
  final Widget content;
  const EnterScreenMenu({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.1),
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        content,
      ],
    );
  }
}
