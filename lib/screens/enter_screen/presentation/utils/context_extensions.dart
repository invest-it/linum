import 'package:flutter/cupertino.dart';
import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/screens/enter_screen/presentation/view_models/enter_screen_view_model.dart';
import 'package:provider/provider.dart';

extension GetEntryType on BuildContext {
  EntryType getEntryType() {
    return read<EnterScreenViewModel>().entryType;
  }
}
