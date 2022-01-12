import 'package:flutter/material.dart';

class TimeWidget extends StatelessWidget {
  const TimeWidget({required this.displayValue});

  final String displayValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(displayValue),
    );
  }
}
