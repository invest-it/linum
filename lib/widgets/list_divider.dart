import 'package:flutter/material.dart';

class ListDivider extends StatelessWidget {
  final double T;
  final double R;
  final double B;
  final double L;

  const ListDivider({this.T = 16.0, this.R = 0, this.B = 16.0, this.L = 0});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: T, right: R, bottom: B, left: L),
      child: Divider(
        thickness: 1.0,
        color: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}
