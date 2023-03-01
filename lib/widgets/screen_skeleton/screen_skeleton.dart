//  ScreenSkeleton - the absolute root of every screen used in the app. See extensive documentation below.
//
//  Author: NightmindOfficial
//  Co-Author: SoTBurst
//  (No Refactoring pls)

import 'package:flutter/material.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/providers/size_guide_provider.dart';
import 'package:linum/utilities/frontend/size_guide.dart';
import 'package:linum/widgets/action_lip.dart';
import 'package:linum/widgets/screen_skeleton/body_section.dart';
import 'package:linum/widgets/screen_skeleton/lip_section.dart';
import 'package:provider/provider.dart';

/// [head] - erwartet einen String (keinen Text()!) der für die Überschrift benutzt wird
/// [body] - hier alle anzuzeigenden Widgets reinbauen
/// [isInverted] - bei true wird der "Body" zur Karte (Lower Lip) genutzt, sonst wird das Standardlayout verwendet (grüne Lippe oben)
///
/// [contentOverride] - kann genutzt werden, um die Rückgabe des ScreenSkeletons auf den Body zu beschränken. Es wird nicht das übliche Styling angewendet.
/// [hasScreenCard] - kann optional auf true gesetzt werden, dann wird zwischen der UpperLip und dem Body noch eine Content Card eingesetzt.
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
// ignore: must_be_immutable
class ScreenSkeleton extends StatelessWidget {
  final String head;
  final Widget body;
  final bool contentOverride;
  final bool isInverted;
  final Widget? screenCard;
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
    this.screenCard,
    this.initialActionLipStatus = ActionLipStatus.hidden,
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
      initialActionLipStatus = ActionLipStatus.disabled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ActionLipStatusProvider actionLipStatusProvider =
        Provider.of<ActionLipStatusProvider>(context, listen: false);
    final sizeGuideProvider =
        Provider.of<SizeGuideProvider>(context, listen: false);
    if (providerKey != null &&
        !actionLipStatusProvider.isActionStatusInitialized(providerKey!)) {
      actionLipStatusProvider.setActionLipStatusSilently(
        providerKey: providerKey!,
        status: initialActionLipStatus,
      );
    }

    if (providerKey != null &&
        !actionLipStatusProvider.isBodyInitialized(providerKey!)) {
      actionLipStatusProvider.setActionLipSilently(
        providerKey: providerKey!,
        actionLipBody: _initialActionLipBody,
      );
    }

    if (!contentOverride) {
      return Stack(
        children: [
          Column(
            children: [
              LipSection(
                lipTitle: head,
                hasScreenCard: screenCard != null,
                isInverted: isInverted,
                actions: actions,
                leadingAction: leadingAction,
              ),
              BodySection(
                body: body,
                isInverted: isInverted,
                hasScreenCard: screenCard != null,
              ),
            ],
          ),
          screenCard != null
              ? Positioned(
                  top: sizeGuideProvider.proportionateScreenHeight(164 - 25),
                  left: 0,
                  right: 0,
                  child: screenCard!,
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
  hidden,
  onviewport,
  disabled,
}
