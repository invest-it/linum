//  Lip Section - the upper part of the ScreenSkeleton
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//

import 'package:flutter/material.dart';
import 'package:linum/utilities/frontend/size_guide.dart';

class LipSection extends StatelessWidget {
  final String lipTitle;
  final bool isInverted;
  final bool hasScreenCard;
  final Widget Function(BuildContext)? leadingAction;
  final List<Widget Function(BuildContext)>? actions;

  const LipSection({
    required this.lipTitle,
    required this.isInverted,
    required this.hasScreenCard,
    this.leadingAction,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return isInverted
        ? Stack(
            children: [
              ClipRRect(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  width: proportionateScreenWidthFraction(ScreenFraction.full),
                  height: proportionateScreenHeight(164),
                  color: Theme.of(context).colorScheme.primary,
                  child: Baseline(
                    baselineType: TextBaseline.alphabetic,
                    baseline: hasScreenCard
                        ? proportionateScreenHeight(144)
                        : proportionateScreenHeight(164) - 8,
                    child: Text(
                      lipTitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6,

                      /// Headlines are considered decorative elements and should therefore not be affected by system accessibility modifications - fixes #47
                      textScaleFactor: 1.0,
                    ),
                  ),
                ),
              ),
              if (leadingAction != null || actions != null)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: AppBar(
                      elevation: 0,
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.transparent,
                      leading: leadingAction!(context),
                      actions: _actionHelper(actions, context),
                    ),
                  ),
                ),
            ],
          )
        : Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(40),
                ),
                child: Container(
                  alignment: Alignment.bottomCenter,
                  width: proportionateScreenWidth(375),
                  height: proportionateScreenHeight(164),
                  color: Theme.of(context).colorScheme.primary,
                  child: Baseline(
                    baselineType: TextBaseline.alphabetic,
                    baseline: proportionateScreenHeight(164) - 12,
                    child: Text(
                      lipTitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6,
                      textScaleFactor: 1.0,
                    ),
                  ),
                ),
              ),
              if (leadingAction != null || actions != null)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: AppBar(
                      primary: false,
                      elevation: 0,
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.transparent,
                      leading: leadingAction!(context),
                      actions: _actionHelper(actions, context),
                    ),
                  ),
                ),
            ],
          );
  }

  List<Widget>? _actionHelper(
    List<Widget Function(BuildContext context)>? functions,
    BuildContext context,
  ) {
    final List<Widget> widgets = [];
    if (functions != null) {
      for (int i = 0; i < functions.length; i++) {
        widgets.add(functions[i](context));
      }
    }
    return widgets;
  }
}
