import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ScreenCardProvider extends ChangeNotifier {
  FlipCardController? _controller;
  dynamic _data;

  void setData(dynamic data) {
    _data = data;
  }

  dynamic get data => _data;

  void setFlipCardControllerSoftSilently(FlipCardController controller) {
    _controller = controller;
  }

  void toggleFlipCard() {
    _controller?.toggleCard();
    notifyListeners();
  }

  void turnToBack() {
    if (_controller?.state?.isFront ?? true) {
      toggleFlipCard();
    }
  }

  void turnToFront() {
    if (!(_controller?.state?.isFront ?? true)) {
      toggleFlipCard();
    }
  }

  static SingleChildWidget provider(
    BuildContext context, {
    bool testing = false,
  }) {
    return ChangeNotifierProvider<ScreenCardProvider>(
      create: (_) => ScreenCardProvider(),
    );
  }
}
