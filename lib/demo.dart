import 'package:flutter/widgets.dart';

class Child extends StatelessWidget {
  const Child({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

void main() {
  runApp(const DemoUI());
}

class DemoUI extends StatelessWidget {
  const DemoUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Child(),
      ),
    );
  }
}
