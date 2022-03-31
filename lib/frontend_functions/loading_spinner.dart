import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingSpinner extends StatelessWidget {
  final String loadingTitle;
  const LoadingSpinner({
    this.loadingTitle = "",
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SpinKitFadingCircle(
            color: Theme.of(context).colorScheme.primary,
            size: 40.0,
          ),
          const SizedBox(
            height: 10,
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
