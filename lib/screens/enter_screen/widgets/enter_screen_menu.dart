import 'package:flutter/material.dart';

class EnterScreenMenu extends StatelessWidget {
  final String? title;
  final Widget content;
  const EnterScreenMenu({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      child: Flex(
        direction: Axis.vertical,
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 32.0),
            child: Text(
              title ?? "", // TODO make field conditional
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          content,
        ],
      ),
    );
  }
}
