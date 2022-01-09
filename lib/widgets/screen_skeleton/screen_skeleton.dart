import 'package:flutter/material.dart';
import 'package:linum/frontend_functions/size_guide.dart';
import 'package:linum/widgets/home_screen/home_screen_card.dart';
import 'package:linum/widgets/screen_skeleton/body_section.dart';
import 'package:linum/widgets/screen_skeleton/lip_section.dart';

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

  const ScreenSkeleton({
    Key? key,
    required this.head,
    required this.body,
    required this.isInverted,
    this.hasHomeScreenCard = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            LipSection(
              lipTitle: head,
              isInverted: isInverted,
            ),
            BodySection(
              body: body,
              isInverted: isInverted,
            ),
          ],
        ),
        Positioned(
          top: proportionateScreenHeight(164 - 25),
          left: 0,
          right: 0,
          child: HomeScreenCard(
            balance: 1081.46,
            income: 1200.00,
            expense: 1200 - 1081.46,
          ),
        ),
      ],
    );
  }
}
