//  Note: If this breaks in the future, remind @NightmindOfficial to add his very own NoGlow() class from another project. (It works better than this, but I'm not gonna mess with a working file)

import 'package:flutter/material.dart';

/// ScrollBehaviour without Material Glow Effects
class SilentScroll extends ScrollBehavior {
  const SilentScroll();
  @override
  // ignore: override_on_non_overriding_member
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}
