//  HomeScreen Card Time Warp - Time Machine for the HomeScreenCard (return the statistics for a given month)
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//

import 'package:linum/providers/algorithm_provider.dart';

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
