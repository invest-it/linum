//  HomeScreen Card Time Warp - Time Machine for the HomeScreenCard (return the statistics for a given month)
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//

import 'package:flutter/material.dart';
import 'package:linum/core/balance/presentation/algorithm_service.dart';
import 'package:provider/provider.dart';

void goBackInTime(AlgorithmService algorithmService) {
  // Right Swipe, going back in time
  algorithmService.previousMonth(notify: true);
}

void goForwardInTime(AlgorithmService algorithmService) {
  //Left Swipe, going forward in time
  algorithmService.nextMonth(notify: true);
}

void goToCurrentTime(AlgorithmService algorithmService) {
  // Reset to current month
  algorithmService.resetCurrentShownMonth(notify: true);
}

void onHorizontalDragEnd(DragEndDetails details, BuildContext context) {
  // Note: Sensitivity is integer used when you don't want to mess up vertical drag
  final algorithmProvider =
      context.read<AlgorithmService>();
  const int sensitivity = 1;
  if (details.primaryVelocity! > sensitivity) {
    //Right Swipe, going back in time
    goBackInTime(algorithmProvider);
  } else if (details.primaryVelocity! < -sensitivity) {
    goForwardInTime(algorithmProvider);
  }
}
