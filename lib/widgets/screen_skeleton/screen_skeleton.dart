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

/// [head] - erwartet einen String (keinen Text()!) der für die Überschrift benutzt wird
/// [body] - hier alle anzuzeigenden Widgets reinbauen
/// [isInverted] - bei true wird der "Body" zur Karte (Lower Lip) genutzt, sonst wird das Standardlayout verwendet (grüne Lippe oben)
///
/// [contentOverride] - kann genutzt werden, um die Rückgabe des ScreenSkeletons auf den Body zu beschränken. Es wird nicht das übliche Styling angewendet.
/// [hasHomeScreenCard] - kann optional auf true gesetzt werden, dann wird zwischen der UpperLip und dem Body noch eine Content Card eingesetzt.
/// Im Moment ist das auf die HomeScreenCard hardcoded, und das ist auch gut so, falls wir es jemals woanders bräuchten, könnte man das aber u.U. noch erweitern.
/// Dadurch kann man jetzt sogar beim HomeScreen das ScreenSkeleton->isInverted auf false setzen, und der Screen sieht trotzdem gut aus.
///
/// Mithilfe der Parameter:
///
/// Widget? [leadingAction],
/// List<Widget>? [actions],
///
/// könnt ihr nun IconButtons oben bei den Screens einfügen. Um Actions einzubauen, habt ihr dabei zwei Möglichkeiten:
///
/// a. Ihr wählt aus einer Liste vordefinierter appBarActions aus
/// b. Ihr kreiert euren eigenen appBarAction
///
/// A: Vordefinierte appBarAction
/// Es sind aktuell folgende Buttons vordefiniert:
///
/// DefaultAction.BACK /// Zurück-Button
/// DefaultAction.CLOSE /// Schließen-Button
/// DefaultAction.ACADEMY /// Invest it! Academy Button
/// DefaultAction.NOTIFICATION /// Benachrichtigungs-Center Button (coming soon)
/// DefaultAction.FILTER /// Filter-Button für den Budget Screen (coming soon)
///
///
/// Nutzen könnt ihr diesen folgendermaßen (hier am Beispiel einer leadingAction):
///
/// ScreenSkeleton(
///   [head] : 'Titel der Lip'
///   [body] : /// Body des Screens ,
///   [leadingAction] : AppBarAction.fromPreset(DefaultAction.CLOSE),
///
///
/// Beispiel für zwei Actions:
///
/// ScreenSkeleton(
///   [head] : 'Titel der Lip'
///   [body] : /// Body des Screens ,
///   [actions] : [
///     AppBarAction.fromPresets(DefaultAction.ACADEMY),
///     AppBarAction.fromPresets(DefaultAction.NOTIFICATION),
///   ],
///
///
/// B: Eine eigene appBarAction erstellen
/// Wenn ihr einen custom Button braucht, müsst ihr folgende Methode nutzen (hier am Beispiel einer leadingAction):
///
/// ScreenSkeleton(
///   [head] : 'Titel der Lip'
///   [body] : /// Body des Screens ,
///   [leadingAction] : AppBarAction.fromParameters(icon: Icons.unicorn, ontap: ///hier die   Funktion rein die ausgeführt werden soll, beide Parameter sind required!),
///
///
/// Beispiel für zwei Actions:
///
/// ScreenSkeleton(
///   [head] : 'Titel der Lip'
///   [body] : /// Body des Screens ,
///   [actions] : [
///     AppBarAction.fromParameters(icon: Icons.lamp, ontap: () => turnOnLight() ),
///     AppBarAction.fromParameters(icon: Icons.microphone-muted, ontap: () {turnOffMic(); }),
///   ],
///
///
/// Wichtig sind außerdem noch folgende Dinge:
/// Ihr könnt kein eigenständiges AppBarAction Widget erstellen. Ihr müsst immer entweder .fromPreset() oder .fromParameters() nutzen.
/// Wenn ihr weder actions: noch leadingAction: definiert, wird keine AppBar angelegt.
class ScreenSkeleton extends StatelessWidget {
  final String head;
  final Widget body;
  final bool contentOverride;
  final bool isInverted;
  final bool hasHomeScreenCard;
  final Widget Function(BuildContext)? leadingAction;
  final List<Widget Function(BuildContext)>? actions;
  final ProviderKey? providerKey;
  ActionLipStatus initialActionLipStatus;
  late final Widget _initialActionLipBody;

  ScreenSkeleton({
    required this.head,
    required this.body,
    this.contentOverride = false,
    this.isInverted = false,
    this.hasHomeScreenCard = false,
    this.initialActionLipStatus = ActionLipStatus.HIDDEN,
    this.providerKey,
    Widget? initialActionLipBody,
    this.actions,
    this.leadingAction,
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
      actionLipStatusProvider.setActionLipStatusSilently(
          providerKey: providerKey!, actionLipStatus: initialActionLipStatus);
    }

    if (providerKey != null &&
        !actionLipStatusProvider.isBodyInitialized(providerKey!)) {
      actionLipStatusProvider.setActionLipSilently(
          providerKey: providerKey!, actionLipBody: _initialActionLipBody);
    }

    if (!contentOverride) {
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
                  /// to make sure we'd actually notice fuck-ups with this
                  color: Colors.red,
                  height: 0,
                ),
          if (providerKey != null)
            ActionLip(
              providerKey!,
            ),
        ],
      );
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            body,
            if (providerKey != null)
              ActionLip(
                providerKey!,
              ),
          ],
        ),
      );
    }
  }
}

enum ActionLipStatus {
  HIDDEN,
  ONVIEWPORT,
  DISABLED,
}
