import 'package:flutter/material.dart';

class MainTransitionDelegate extends TransitionDelegate<void> {
  @override
  Iterable<RouteTransitionRecord> resolve({required List<RouteTransitionRecord> newPageRouteHistory, required Map<RouteTransitionRecord?, RouteTransitionRecord> locationToExitingPageRoute, required Map<RouteTransitionRecord?, List<RouteTransitionRecord>> pageRouteToPagelessRoutes}) {
    final results = <RouteTransitionRecord>[];

    for (final pageRoute in newPageRouteHistory) {
      if (pageRoute.isWaitingForEnteringDecision) {
        pageRoute.markForPush();
      }
      results.add(pageRoute);
    }

    for (final exitingPageRoute in locationToExitingPageRoute.values) {
      if (exitingPageRoute.isWaitingForExitingDecision) {
        exitingPageRoute.markForPop();
        final pagelessRoutes = pageRouteToPagelessRoutes[exitingPageRoute];
        if (pagelessRoutes != null) {
          for (final pagelessRoute in pagelessRoutes) {
            pagelessRoute.markForPop();
          }
        }
      }

      results.add(exitingPageRoute);
    }
    return results;
  }

}
