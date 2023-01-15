//  Loading Spinner - Custom Loading Indicator
//
//  Author: thebluebaronx
//  Co-Author: n/a
//

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingThreeBounce extends StatelessWidget {
  final String loadingTitle;
  final double loadingSize;

  const LoadingThreeBounce({
    this.loadingTitle = "",
    required this.loadingSize,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SpinKitThreeBounce(
            color: Theme.of(context).colorScheme.primary,
            size: loadingSize,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            loadingTitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
