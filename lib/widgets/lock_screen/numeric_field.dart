import 'package:flutter/material.dart';


class NumericField extends StatelessWidget {
  final int digit;
  final void Function(int) onPress;

  const NumericField(this.digit, this.onPress);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: double.infinity,
        ),
        child: TextButton(
          onPressed: () {
            onPress(digit);
          },
          style: TextButton.styleFrom(
            shape: const CircleBorder(),
          ),
          child: Text(
            digit.toString(),
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
      ),
    );
  }
}
