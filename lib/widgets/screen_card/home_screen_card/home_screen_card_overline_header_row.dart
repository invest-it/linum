import 'dart:math' as math;
import 'package:flutter/material.dart';

class HomeScreenCardOverlineHeaderRow extends StatelessWidget {
  final List<String> _bodyList;
  final MainAxisAlignment _maa;
  final bool _capitalize;

  const HomeScreenCardOverlineHeaderRow(
    List<String> bodyList, {
    MainAxisAlignment maa = MainAxisAlignment.center,
    bool capitalize = true,
  })  : _bodyList = bodyList,
        _maa = maa,
        _capitalize = capitalize;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: _maa,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ..._bodyList.map(
            (e) => Expanded(
              child: Container(
                color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                    .withOpacity(1.0),
                child: Center(
                  child: FittedBox(
                    child: Text(
                      _capitalize ? e.toUpperCase() : e,
                      style: Theme.of(context).textTheme.overline,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
