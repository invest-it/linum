//  ScreenSkeleton - the absolute root of every screen used in the app. See extensive documentation below.
//
//  Author: NightmindOfficial
//  Co-Author: SoTBurst
//  (No Refactoring pls)


import 'package:flutter/material.dart';
import 'package:linum/common/components/action_lip/action_lip.dart';
import 'package:linum/common/components/action_lip/viewmodels/action_lip_viewmodel.dart';
import 'package:linum/core/design/layout/enums/screen_key.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:linum/core/design/layout/widgets/body_section.dart';
import 'package:linum/core/design/layout/widgets/lip_section.dart';
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
  final ScreenKey? screenKey;
  ActionLipVisibility initialActionLipStatus;
  late final Widget _initialActionLipBody;

  ScreenSkeleton({
    required this.head,
    required this.body,
    this.contentOverride = false,
    this.isInverted = false,
    this.screenCard,
    this.initialActionLipStatus = ActionLipVisibility.hidden,
    this.screenKey,
    Widget? initialActionLipBody,
    this.actions,
    this.leadingAction,
  }) {
    if (initialActionLipBody == null) {
      _initialActionLipBody = Container();
    } else {
      _initialActionLipBody = initialActionLipBody;
    }
    if (screenKey == null) {
      initialActionLipStatus = ActionLipVisibility.disabled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ActionLipViewModel actionLipStatusProvider =
        context.read<ActionLipViewModel>();

    if (screenKey != null &&
        !actionLipStatusProvider.isActionStatusInitialized(screenKey!)) {
      actionLipStatusProvider.setActionLipStatusSilently(
        context: context,
        screenKey: screenKey!,
        status: initialActionLipStatus,
      );
    }

    if (screenKey != null &&
        !actionLipStatusProvider.isBodyInitialized(screenKey!)) {
      actionLipStatusProvider.setActionLipSilently(
        screenKey: screenKey!,
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
                  top: context.proportionateScreenHeight(164 - 25),
                  left: 0,
                  right: 0,
                  child: screenCard!,
                )
              : Container(
                  /// to make sure we'd actually notice fuck-ups with this
                  color: Colors.red,
                  height: 0,
                ),
          if (screenKey != null)
            ActionLip(
              screenKey!,
            ),
        ],
      );
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            body,
            if (screenKey != null)
              ActionLip(
                screenKey!,
              ),
          ],
        ),
      );
    }
  }
}

enum ActionLipVisibility {
  hidden,
  onviewport,
  disabled,
}
