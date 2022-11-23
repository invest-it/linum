//  Home Screen Card Avatar - Aesthetics-only widget acting as Icon or Badge on the side of metrics
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//

import 'package:flutter/material.dart';

class HomeScreenCardAvatar extends StatelessWidget {
  final Color? bodyColor;
  final Color backgroundColor;
  final Widget body;

  static const Map<Preset, Widget> _defaultIcons = {
    Preset.arrowDown: Icon(
      Icons.arrow_downward_rounded,
      color: Colors.white,
      size: 20,
    ),
    Preset.arrowUp: Icon(
      Icons.arrow_upward_rounded,
      color: Colors.white,
      size: 20,
    ),
  };

  const HomeScreenCardAvatar._({
    required this.backgroundColor,
    this.bodyColor,
    required this.body,
  });

  factory HomeScreenCardAvatar.withArrow({
    Color backgroundColor = Colors.grey,
    required Preset arrow,
  }) {
    return HomeScreenCardAvatar._(
      backgroundColor: backgroundColor,
      body: _defaultIcons[arrow]!,
    );
  }

  factory HomeScreenCardAvatar.withText({
    Color backgroundColor = Colors.grey,
    Color bodyColor = Colors.white,
    required String text,
  }) {
    return HomeScreenCardAvatar._(
      backgroundColor: backgroundColor,
      bodyColor: bodyColor,
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          const Icon(
            Icons.abc,
            color: Colors.transparent,
          ),
          Text(
            text,
            style: TextStyle(
              color: bodyColor,
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
      ),
      child: Center(
        child: body,
      ),
    );
  }
}

enum Preset { arrowUp, arrowDown }
