import 'package:linum/providers/algorithm_provider.dart';

void goBackInTime(AlgorithmProvider algorithmProvider) {
  // Right Swipe, going back in time
  algorithmProvider.previousMonth();
}

void goForwardInTime(AlgorithmProvider algorithmProvider) {
  //Left Swipe, going forward in time
  algorithmProvider.nextMonth();
}

void goToCurrentTime(AlgorithmProvider algorithmProvider) {
  // Reset to current month
  algorithmProvider.resetCurrentShownMonth();
}
