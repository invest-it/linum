import 'package:flip_card/flip_card_controller.dart';

extension FlipCardControllerExtensions on FlipCardController {
  void turnToBack() {
    if (state?.isFront ?? true) {
      toggleCard();
    }
  }

  void turnToFront() {
    if (!(state?.isFront ?? true)) {
      toggleCard();
    }
  }
}
