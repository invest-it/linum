import 'package:linum/enter_screen/enums/input_flag.dart';

const inputFlagMap = <String, InputFlag>{
  "KATEGORIE": InputFlag.category,
  "CATEGORY": InputFlag.category,
  "CAT": InputFlag.category,
  "C": InputFlag.category,
  "K": InputFlag.category,
  "DATUM": InputFlag.date,
  "DATE": InputFlag.date,
  "D": InputFlag.date,
  "WIEDERHOLUNG": InputFlag.repeatInfo,
  "REPEATINFO": InputFlag.repeatInfo,
  "REPEAT": InputFlag.repeatInfo,
  "R": InputFlag.repeatInfo,
  "W": InputFlag.repeatInfo,
};
