//  SilentScroll - Wrapper for removing Material Glow Effects
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//  Note: If this breaks in the future, remind @NightmindOfficial to add his very own NoGlow() class from another project. (It works better than this, but I'm not gonna mess with a working file)

import 'package:flutter/material.dart';

class SilentScroll extends ScrollBehavior {
  // TODO what is happening here? Pls investigate.
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
