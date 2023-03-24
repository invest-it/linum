//  Action Lip - A Lip that replaced the ModalBottomSheet Functionality. An ActionLip can be triggered on any screen, supposed that the screenKey is unique.
//
//  Code was Spaghetti before the SizeGuide remake. Code is Spaghetti after the SizeGuide remake.
//
//  Author: NightmindOfficial
//  Co-Author: SoTBurst
//  (Refactored)

import 'package:flutter/material.dart';
import 'package:linum/common/components/action_lip/viewmodels/action_lip_viewmodel.dart';
import 'package:linum/core/design/layout/enums/screen_fraction_enum.dart';
import 'package:linum/core/design/layout/enums/screen_key.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:linum/core/design/layout/utils/media_query_accessors.dart';
import 'package:linum/core/design/layout/widgets/screen_skeleton.dart';
import 'package:provider/provider.dart';

// ignore_for_file: deprecated_member_use
//TODO DEPRECATED

// ignore: must_be_immutable
class ActionLip extends StatefulWidget {
  const ActionLip(this.screenKey);

  final ScreenKey screenKey;

  @override
  State<ActionLip> createState() => _ActionLipState(screenKey);
}

class _ActionLipState extends State<ActionLip> {
  _ActionLipState(this.screenKey);

  final ScreenKey screenKey;

  @override
  Widget build(BuildContext context) {
    final ActionLipViewModel provider =
        context.watch<ActionLipViewModel>();

    final status = provider.getActionLipStatus(screenKey);

    return AnimatedContainer(
      curve: Curves.fastLinearToSlowEaseIn,
      duration: const Duration(milliseconds: 1000),
      transform: Matrix4.translationValues(
        0,
        _calculateYOffset(status),
        1,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(80),
            blurRadius: 16,
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: context
            .proportionateScreenHeightFraction(ScreenFraction.threefifths),
        child: Column(
          children: [
            AppBar(
              primary: false,
              automaticallyImplyLeading: false,
              title: Text(
                provider.getActionLipTitle(screenKey),
                style: Theme.of(context).textTheme.headline5,
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    provider.setActionLipStatus(
                      screenKey: screenKey,
                      status: ActionLipVisibility.hidden,
                    );
                  },
                ),
              ],
              iconTheme: const IconThemeData(color: Colors.black),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            provider.getActionLipBody(screenKey),
          ],
        ),
      ),
    );
  }

  double _calculateYOffset(
    ActionLipVisibility status,
  ) {
    switch (status) {
      case ActionLipVisibility.hidden:
        return useScreenHeight(context);
      case ActionLipVisibility.onviewport:
        return context.isKeyboardOpen()
            ? context.proportionateScreenHeightFraction(
                  ScreenFraction.twofifths,
                ) -
                (useKeyBoardHeight(context) / 2)
            : context
                .proportionateScreenHeightFraction(ScreenFraction.twofifths);
      case ActionLipVisibility.disabled:
        throw ArgumentError(
          'If the actionLipStatus is set to DISABLED, the ActionLip class must not be invoked.',
          'actionLipStatus',
        );
    }
  }
}
