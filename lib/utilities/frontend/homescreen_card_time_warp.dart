//  HomeScreen Card Time Warp - Time Machine for the HomeScreenCard (return the statistics for a given month)
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//

import 'package:flutter/material.dart';
import 'package:linum/providers/algorithm_provider.dart';
import 'package:provider/provider.dart';

void goBackInTime(AlgorithmProvider algorithmProvider) {
  // Right Swipe, going back in time
  algorithmProvider.previousMonth(notify: true);
}

void goForwardInTime(AlgorithmProvider algorithmProvider) {
  //Left Swipe, going forward in time
  algorithmProvider.nextMonth(notify: true);
}

void goToCurrentTime(AlgorithmProvider algorithmProvider) {
  // Reset to current month
  algorithmProvider.resetCurrentShownMonth(notify: true);
}

void onHorizontalDragEnd(DragEndDetails details, BuildContext context) {
  // Note: Sensitivity is integer used when you don't want to mess up vertical drag
  final algorithmProvider =
      Provider.of<AlgorithmProvider>(context, listen: false);
  const int sensitivity = 1;
  if (details.primaryVelocity! > sensitivity) {
    //Right Swipe, going back in time
    goBackInTime(algorithmProvider);
  } else if (details.primaryVelocity! < -sensitivity) {
    goForwardInTime(algorithmProvider);
  }
}
