//  Action Lip - A Lip that replaced the ModalBottomSheet Functionality. An ActionLip can be triggered on any screen, supposed that the screenKey is unique.
//
//  Author: NightmindOfficial & damattl
//  Co-Author: SoTBurst
//  (Refactored)

import 'package:flutter/material.dart';
import 'package:linum/common/components/action_lip/utils/action_lip_y_offset.dart';
import 'package:linum/common/components/action_lip/viewmodels/action_lip_viewmodel.dart';
import 'package:linum/core/design/layout/enums/screen_fraction_enum.dart';
import 'package:linum/core/design/layout/enums/screen_key.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:linum/core/design/layout/widgets/screen_skeleton.dart';
import 'package:provider/provider.dart';


class ActionLip extends StatelessWidget {
  const ActionLip(this.screenKey);

  final ScreenKey screenKey;

  @override
  Widget build(BuildContext context) {
    return Consumer<ActionLipViewModel>(
      builder: (context, viewModel, _) {

        final status = viewModel.getActionLipStatus(screenKey);
        final close = () {
          FocusManager.instance.primaryFocus?.unfocus();
          viewModel.setActionLipStatus(
            context: context,
            screenKey: screenKey,
            status: ActionLipVisibility.hidden,
          );
        };

        return Stack(
          children: [
            GestureDetector(
              onTap: close,
              child: Container(
                height: status == ActionLipVisibility.onviewport ? double.infinity : 0,
                color: Colors.transparent,
              ),
            ),
            AnimatedContainer(
              curve: Curves.fastLinearToSlowEaseIn,
              duration: const Duration(milliseconds: 1000),
              transform: Matrix4.translationValues(
                0,
                ActionLipYOffset(context).forStatus(status),
                1,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
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
                        viewModel.getActionLipTitle(screenKey),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      centerTitle: true,
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: close,
                        ),
                      ],
                      iconTheme: const IconThemeData(color: Colors.black),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                    viewModel.getActionLipBody(screenKey),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
