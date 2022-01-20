import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:linum/frontend_functions/size_guide.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/widgets/screen_skeleton/app_bar_action.dart';
import 'package:linum/widgets/screen_skeleton/screen_skeleton.dart';
import 'package:provider/provider.dart';

class ActionLip extends StatefulWidget {
  ActionLip(this.providerKey);

  final ProviderKey providerKey;
  @override
  State<ActionLip> createState() => _ActionLipState(providerKey);
}

class _ActionLipState extends State<ActionLip> {
  _ActionLipState(this.providerKey);

  final ProviderKey providerKey;
  double _lipYOffset = realScreenHeight();

  @override
  Widget build(BuildContext context) {
    ActionLipStatusProvider actionLipStatusProvider =
        Provider.of<ActionLipStatusProvider>(context);

    // log('Status when ActionLip was built:' + actionLipStatus.toString());
    switch (actionLipStatusProvider.getActionLipStatus(providerKey)) {
      case ActionLipStatus.HIDDEN:
        setState(() {
          _lipYOffset = realScreenHeight();
        });
        break;
      case ActionLipStatus.ONVIEWPORT:
        setState(() {
          log('The offset of the card is currently' + _lipYOffset.toString());
          _lipYOffset = proportionateScreenHeight(200);
        });
        break;
      case ActionLipStatus.DISABLED:
        throw ArgumentError(
            'If the actionLipStatus is set to DISABLED, the ActionLip class must not be invoked.',
            'actionLipStatus');
    }

    return AnimatedContainer(
      curve: Curves.fastLinearToSlowEaseIn,
      duration: Duration(milliseconds: 1000),
      transform: Matrix4.translationValues(0, _lipYOffset, 1),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.only(
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
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppBar(
              primary: false,
              automaticallyImplyLeading: false,
              title: Text(
                  actionLipStatusProvider.getActionLipTitle(providerKey),
                  style: Theme.of(context).textTheme.headline5),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    actionLipStatusProvider.setActionLipStatus(
                        providerKey: providerKey,
                        actionLipStatus: ActionLipStatus.HIDDEN);
                  },
                ),
              ],
              iconTheme: IconThemeData(color: Colors.black),
              backgroundColor: Colors.yellow.withAlpha(80),
              elevation: 0,
            ),
            actionLipStatusProvider.getActionLipBody(providerKey),
          ],
        ),
      ),
    );
  }
}
