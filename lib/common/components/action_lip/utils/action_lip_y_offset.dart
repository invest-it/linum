import 'package:flutter/material.dart';
import 'package:linum/core/design/layout/enums/screen_fraction_enum.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:linum/core/design/layout/utils/media_query_accessors.dart';
import 'package:linum/core/design/layout/widgets/screen_skeleton.dart';

class ActionLipYOffset {
  final BuildContext context;

  ActionLipYOffset(this.context);

  double forStatus(ActionLipVisibility status) {
    switch (status) {
      case ActionLipVisibility.hidden:
        return hidden();
      case ActionLipVisibility.onviewport:
        return onviewport();
      case ActionLipVisibility.disabled:
        throw ArgumentError(
          'If the actionLipStatus is set to DISABLED, the ActionLip class must not be invoked.',
          'actionLipStatus',
        );
    }
  }

  double hidden() {
    return useScreenHeight(context);
  }

  double onviewport() {
    if (context.isKeyboardOpen()) {
      final screenHeight = context.proportionateScreenHeightFraction(
          ScreenFraction.twofifths,
      );
      return  screenHeight - (useKeyBoardHeight(context) / 2);
    }
    return context.proportionateScreenHeightFraction(ScreenFraction.twofifths);
  }

}