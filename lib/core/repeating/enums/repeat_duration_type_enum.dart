//  Repeat Duration Type - Enum that specifies the unit of a repeat duration
//
//  Author: SoTBurst
//  Co-Author: n/a
//



enum RepeatDurationType {
  seconds,
  months,
}

RepeatDurationType? repeatDurationTypeFromString(String enumStr) {
  try {
    return RepeatDurationType.values.byName(enumStr.toLowerCase());
  } catch(e) {
    return null;
  }
}
