import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';

class ScreenCardViewModel extends ChangeNotifier {
  final FlipCardController? controller;
  ScreenCardViewModel({this.controller});
}
