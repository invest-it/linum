import 'package:flutter/material.dart';
import 'package:linum/frontend_functions/size_guide.dart';

class LipSection extends StatelessWidget {
  final String lipTitle;
  final bool isInverted;
  final Widget? leadingAction;
  final List<Widget>? actions;

  const LipSection({
    required this.lipTitle,
    required this.isInverted,
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
                  width: proportionateScreenWidthFraction(ScreenFraction.FULL),
                  height: proportionateScreenHeight(164),
                  color: Theme.of(context).colorScheme.primary,
                  child: Baseline(
                    baselineType: TextBaseline.alphabetic,
                    baseline: (proportionateScreenHeight(164) - 8),
                    child: Text(lipTitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6),
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
                      leading: leadingAction,
                      actions: actions,
                    ),
                  ),
                ),
            ],
          )
        : Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.zero,
                  bottom: Radius.circular(40),
                ),
                child: Container(
                  alignment: Alignment.bottomCenter,
                  width: proportionateScreenWidth(375),
                  height: proportionateScreenHeight(164),
                  color: Theme.of(context).colorScheme.primary,
                  child: Baseline(
                    baselineType: TextBaseline.alphabetic,
                    baseline: (proportionateScreenHeight(164) - 12),
                    child: Text(lipTitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6),
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
                      leading: leadingAction,
                      actions: actions,
                    ),
                  ),
                ),
            ],
          );
  }
}
