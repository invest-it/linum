//  Sandbox Screen - Allows for easier feature building and testing while in debug mode
//
//  Author: damattl
//  Co-Author: n/a

import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/design/layout/widgets/screen_skeleton.dart';
import 'package:linum/screens/home_screen/components/home_screen_card/widgets/home_screen_card.dart';

final FlipCardController flipCardController = FlipCardController();

class SandboxScreen extends StatelessWidget {
  const SandboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenSkeleton(
      head: 'Sandbox',
      screenCard: HomeScreenCard(
        controller: flipCardController,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          /* children: [
            // EnterScreen(
            //   transaction: Transaction(
            //     name: 'Test',
            //     amount: 30,
            //     currency: 'EUR',
            //     category: 'none-income',
            //     date: Timestamp.fromDate(DateTime.now()),
            //   ),
            // ),
           ], */
        ),
      ),
      isInverted: true,
    );
  }
}
