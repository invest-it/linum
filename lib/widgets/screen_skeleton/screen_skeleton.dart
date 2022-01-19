import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:linum/frontend_functions/size_guide.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/providers/balance_data_provider.dart';
import 'package:linum/widgets/home_screen/home_screen_card.dart';
import 'package:linum/widgets/onboarding/action_lip.dart';
import 'package:linum/widgets/screen_skeleton/body_section.dart';
import 'package:linum/widgets/screen_skeleton/lip_section.dart';
import 'package:provider/provider.dart';

// ScreenSkeleton(required head, required body, required isInverted, hasHomeScreenCard)
//
// head - erwartet einen String (keinen Text()!) der für die Überschrift benutzt wird
// body - hier alle anzuzeigenden Widgets reinbauen
// isInverted - bei true wird der "Body" zur Karte (Lower Lip) genutzt, sonst wird das Standardlayout verwendet (grüne Lippe oben)
//
//
// hasHomeScreenCard - kann optional auf true gesetzt werden, dann wird zwischen der UpperLip und dem Body noch eine Content Card eingesetzt.
// Im Moment ist das auf die HomeScreenCard hardcoded, und das ist auch gut so, falls wir es jemals woanders bräuchten, könnte man das aber u.U. noch erweitern.
// Dadurch kann man jetzt sogar beim HomeScreen das ScreenSkeleton->isInverted auf false setzen, und der Screen sieht trotzdem gut aus.

class ScreenSkeleton extends StatelessWidget {
  final String head;
  final Widget body;
  final bool isInverted;
  final bool hasHomeScreenCard;
  final Widget? leadingAction;
  final List<Widget>? actions;
  final ProviderKey? providerKey;
  ActionLipStatus initialActionLipStatus;
  late final Widget _initialActionLipBody;

  ScreenSkeleton({
    required this.head,
    required this.body,
    this.isInverted = false,
    this.hasHomeScreenCard = false,
    this.initialActionLipStatus = ActionLipStatus.HIDDEN,
    this.providerKey,
    this.actions,
    this.leadingAction,
    initialActionLipBody,
  }) {
    if (initialActionLipBody == null) {
      _initialActionLipBody = Container();
    } else {
      _initialActionLipBody = initialActionLipBody;
    }
    if (providerKey == null) {
      initialActionLipStatus = ActionLipStatus.DISABLED;
    }
  }

  @override
  Widget build(BuildContext context) {
    BalanceDataProvider balanceDataProvider =
        Provider.of<BalanceDataProvider>(context);

    ActionLipStatusProvider actionLipStatusProvider =
        Provider.of<ActionLipStatusProvider>(context, listen: false);

    if (providerKey != null &&
        !actionLipStatusProvider.isActionStatusInitialized(providerKey!)) {
      actionLipStatusProvider.setActionLip(
          providerKey: providerKey!, actionLipStatus: initialActionLipStatus);
    }

    if (providerKey != null &&
        !actionLipStatusProvider.isBodyInitialized(providerKey!)) {
      actionLipStatusProvider.setActionLipBody(
          providerKey: providerKey!, actionLipBody: _initialActionLipBody);
    }
    return Stack(
      children: [
        Column(
          children: [
            LipSection(
              lipTitle: head,
              isInverted: isInverted,
              actions: actions,
              leadingAction: leadingAction,
            ),
            BodySection(
              body: body,
              isInverted: isInverted,
              hasHomeScreenCard: hasHomeScreenCard,
            ),
          ],
        ),
        hasHomeScreenCard
            ? Positioned(
                top: proportionateScreenHeight(164 - 25),
                left: 0,
                right: 0,
                child: balanceDataProvider
                    .fillStatisticPanelWithData(HomeScreenCardManager()),
              )
            : Container(
                // to make sure we'd actually notice fuck-ups with this
                color: Colors.red,
                height: 0,
              ),
        if (providerKey != null)
          ActionLip(
            providerKey: providerKey!,
          ),
      ],
    );
  }
}

enum ActionLipStatus {
  HIDDEN,
  ONVIEWPORT,
  DISABLED,
}
