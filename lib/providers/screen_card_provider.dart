import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';

class ScreenCardProvider extends ChangeNotifier {
  final FlipCardController? controller;
  ScreenCardProvider({this.controller});
}
