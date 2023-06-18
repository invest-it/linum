import 'package:linum/screens/enter_screen/enums/input_type.dart';

enum InputFlag {
  category,
  date,
  repeatInfo;

  InputType toInputType() {
    switch(this) {
      case InputFlag.repeatInfo:
        return InputType.repeatInfo;
      case InputFlag.category:
        return InputType.category;
      case InputFlag.date:
        return InputType.date;
    }
  }
}
