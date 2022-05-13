import 'package:flutter/material.dart';


class NumericField extends StatelessWidget {
  final int value;
  final Function(int value) onPress;

  const NumericField(this.value, this.onPress);

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: double.infinity,
        ),
        child: TextButton(
          onPressed: () {
            onPress(value);
          },
          style: TextButton.styleFrom(
            shape: const CircleBorder(),
          ),
          child: Text(
            value.toString(),
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
      ),
    );
  }
}
