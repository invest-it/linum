import 'package:flutter/material.dart';

class EnterScreenMenuScaffold extends StatelessWidget {
  final String? title;
  final Widget content;
  const EnterScreenMenuScaffold({
    super.key,
    required this.title,
    required this.content,
  });


  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(16.0);
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: radius, topRight: radius),
      ),
      child: Flex(
        direction: Axis.vertical,
        children: _buildFlexItems(context),
      ),
    );
  }

  List<Widget> _buildFlexItems(BuildContext context) {
    final List<Widget> items = [];

    if (title != null) {
      items.add(
        Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: Text(
            title!,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      );
    }
    items.add(content);
    return items;
  }
}
