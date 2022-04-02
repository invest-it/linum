import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linum/providers/algorithm_provider.dart';

void goBackInTime(AlgorithmProvider algorithmProvider) {
  // Right Swipe, going back in time
  algorithmProvider.previousMonth();
  if (algorithmProvider.currentShownMonth.month == DateTime.now().month &&
      algorithmProvider.currentShownMonth.year == DateTime.now().year) {
    algorithmProvider.setCurrentFilterAlgorithm(
      AlgorithmProvider.inBetween(
        Timestamp.fromDate(
          DateTime(
            DateTime.now().year,
            DateTime.now().month,
          ).subtract(const Duration(microseconds: 1)),
        ),
        Timestamp.fromDate(
          DateTime(
            DateTime.now().year,
            DateTime.now().month + 1,
          ),
        ),
      ),
    );
  } else {
    algorithmProvider.setCurrentFilterAlgorithm(
      AlgorithmProvider.inBetween(
        Timestamp.fromDate(
          algorithmProvider.currentShownMonth
              .subtract(const Duration(microseconds: 1)),
        ),
        Timestamp.fromDate(
          DateTime(
            algorithmProvider.currentShownMonth.year,
            algorithmProvider.currentShownMonth.month + 1,
          ),
        ),
      ),
    );
  }
}

void goForwardInTime(AlgorithmProvider algorithmProvider) {
  //Left Swipe, going forward in time
  algorithmProvider.nextMonth();
  if (algorithmProvider.currentShownMonth.month == DateTime.now().month &&
      algorithmProvider.currentShownMonth.year == DateTime.now().year) {
    algorithmProvider.setCurrentFilterAlgorithm(
      AlgorithmProvider.inBetween(
        Timestamp.fromDate(
          DateTime(
            DateTime.now().year,
            DateTime.now().month,
          ).subtract(const Duration(microseconds: 1)),
        ),
        Timestamp.fromDate(
          DateTime(
            DateTime.now().year,
            DateTime.now().month + 1,
          ),
        ),
      ),
    );
  } else {
    algorithmProvider.setCurrentFilterAlgorithm(
      AlgorithmProvider.inBetween(
        Timestamp.fromDate(
          algorithmProvider.currentShownMonth
              .subtract(const Duration(microseconds: 1)),
        ),
        Timestamp.fromDate(
          DateTime(
            algorithmProvider.currentShownMonth.year,
            algorithmProvider.currentShownMonth.month + 1,
          ),
        ),
      ),
    );
  }
}
