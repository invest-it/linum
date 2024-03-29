//  Date Time Calculations - Used for moving forwards and backwards in time, mainly for the AlgorighmProvider which calculates filters for Transaction Lists
//
//  Author: SoTBurst
//  Co-Author: n/a
//

/// calculate next time step and decide for that if you need monthly steps or seconds as stepsize
DateTime calculateOneTimeStep(
  int stepsize,
  DateTime currentDate, {
  required bool monthly,
  int? dayOfTheMonth,
}) {
  late DateTime newCurrentDate;
  if (!monthly) {
    newCurrentDate = currentDate.add(
      Duration(
        seconds: stepsize,
      ),
    );
  } else {
    newCurrentDate = monthlyStepCalculator(
      currentDate.year,
      currentDate.month + stepsize,
      dayOfTheMonth ?? currentDate.day,
    );
  }
  return newCurrentDate;
}

/// the counterpart to calculateOneTimeStep
DateTime calculateOneTimeStepBackwards(
  int stepsize,
  DateTime currentDate, {
  required bool monthly,
  int? dayOfTheMonth,
}) {
  late DateTime newCurrentDate;
  if (!monthly) {
    newCurrentDate = currentDate.subtract(
      Duration(
        seconds: stepsize,
      ),
    );
  } else {
    newCurrentDate = monthlyStepCalculator(
      currentDate.year,
      currentDate.month - stepsize,
      dayOfTheMonth ?? currentDate.day,
    );
  }
  return newCurrentDate;
}

/// avoid errors with 29th 30th and 31th
DateTime monthlyStepCalculator(int year, int month, int day) {
  final DateTime temp = DateTime(year, month, day);
  if ((temp.month % 12) == (month % 12)) {
    return temp;
  } else {
    return DateTime(temp.year, temp.month).subtract(const Duration(days: 1));
  }
}
