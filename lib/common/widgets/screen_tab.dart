import 'package:flutter/material.dart';
import 'package:linum/common/utils/silent_scroll.dart';

/// Use this widget if you need to embed an entire screen inside an Material Tab
class ScreenTab extends StatelessWidget {
  final Widget child;
  const ScreenTab({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ScrollConfiguration(
        behavior: const SilentScroll(),
        child: SingleChildScrollView(child: child),
      ),
    );
  }
}
