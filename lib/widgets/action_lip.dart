//  Action Lip - A Lip that replaced the ModalBottomSheet Functionality. An ActionLip can be triggered on any screen, supposed that the providerKey is unique.
//
//  Code was Spaghetti before the SizeGuide remake. Code is Spaghetti after the SizeGuide remake.
//
//  Author: NightmindOfficial
//  Co-Author: SoTBurst
//  (Refactored)

import 'package:flutter/material.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/providers/size_guide_provider.dart';
import 'package:linum/utilities/frontend/size_guide.dart';
import 'package:linum/widgets/screen_skeleton/screen_skeleton.dart';
import 'package:provider/provider.dart';

class ActionLip extends StatefulWidget {
  const ActionLip(this.providerKey);

  final ProviderKey providerKey;
  @override
  State<ActionLip> createState() => _ActionLipState(providerKey);
}

class _ActionLipState extends State<ActionLip> {
  _ActionLipState(this.providerKey);

  final ProviderKey providerKey;

  @override
  Widget build(BuildContext context) {
    final sizeGuideProvider = Provider.of<SizeGuideProvider>(context);
    final ActionLipStatusProvider provider =
        Provider.of<ActionLipStatusProvider>(context);

    final status = provider.getActionLipStatus(providerKey);

    // log('Status when ActionLip was built:' + actionLipStatus.toString());
    switch (status) {
      case ActionLipStatus.hidden:
        // _lipYOffset = realScreenHeight();
        sizeGuideProvider.update();
        break;
      case ActionLipStatus.onviewport:
        // setState(() {
        // log('The offset of the actionLip is currently' +
        // _lipYOffset.toString());
        // SizeGuide.keyboardIsOpened
        // ? log('Because the keyboard is opened, ')
        // : log('Because the keyboard is not opened,');
        // log('the offset has been reduced by ' +
        // (SizeGuide.keyboardHeight / 2).toString());
        sizeGuideProvider.update();
        // _lipYOffset = sizeGuideProvider.isKeyboardOpen(context)
        //     ? sizeGuideProvider.proportionateScreenHeightFraction(ScreenFraction.twofifths) -
        //         (sizeGuideProvider.keyboardHeight / 2)
        //     : sizeGuideProvider.proportionateScreenHeightFraction(ScreenFraction.twofifths);
        // });
        break;
      case ActionLipStatus.disabled:
        throw ArgumentError(
          'If the actionLipStatus is set to DISABLED, the ActionLip class must not be invoked.',
          'actionLipStatus',
        );
    }

    return AnimatedContainer(
      curve: Curves.fastLinearToSlowEaseIn,
      duration: const Duration(milliseconds: 1000),
      transform: Matrix4.translationValues(
          0, _calculateYOffset(sizeGuideProvider, status), 1),
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
        height: sizeGuideProvider
            .proportionateScreenHeightFraction(ScreenFraction.threefifths),
        child: Column(
          children: [
            AppBar(
              primary: false,
              automaticallyImplyLeading: false,
              title: Text(
                provider.getActionLipTitle(providerKey),
                style: Theme.of(context).textTheme.headline5,
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    provider.setActionLipStatus(
                      providerKey: providerKey,
                      status: ActionLipStatus.hidden,
                    );
                  },
                ),
              ],
              iconTheme: const IconThemeData(color: Colors.black),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            provider.getActionLipBody(providerKey),
          ],
        ),
      ),
    );
  }

  double _calculateYOffset(
      SizeGuideProvider sizeGuideProvider, ActionLipStatus status) {
    switch (status) {
      case ActionLipStatus.hidden:
        return sizeGuideProvider.realScreenHeight();
      case ActionLipStatus.onviewport:
        return sizeGuideProvider.isKeyboardOpen(context)
            ? sizeGuideProvider.proportionateScreenHeightFraction(
                    ScreenFraction.twofifths) -
                (sizeGuideProvider.keyboardHeight / 2)
            : sizeGuideProvider
                .proportionateScreenHeightFraction(ScreenFraction.twofifths);
      case ActionLipStatus.disabled:
        throw ArgumentError(
          'If the actionLipStatus is set to DISABLED, the ActionLip class must not be invoked.',
          'actionLipStatus',
        );
    }
  }
}
