//  Home Screen Functions - Handles "Flipping" of the card
//
//  Author: NightmindOfficial
//  Co-Author: damattl
//  (Refactored)

import 'package:easy_localization/easy_localization.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:linum/generated/translation_keys.g.dart';



TextStyle? getBalanceTextStyle(BuildContext context, num balance) {
  return MediaQuery.of(context).size.height < 650
      ? Theme.of(context).textTheme.displayMedium?.copyWith(
            color: balance < 0
                ? Theme.of(context).colorScheme.error
                : const Color(0xFF202020),
          )
      : Theme.of(context).textTheme.displayLarge?.copyWith(
            color: balance < 0
                ? Theme.of(context).colorScheme.error
                : const Color(0xFF505050),
          );
}

// TODO: Perhaps build this file as class that gets inherited

void onFlipCardTap(FlipCardController controller) {
  controller.hint(
    duration: const Duration(
      milliseconds: 100,
    ),
    total: const Duration(
      milliseconds: 500,
    ),
  );

  Fluttertoast.showToast(
    msg: tr(translationKeys.homeScreenCard.homeScreenCardToast),
    toastLength: Toast.LENGTH_SHORT,
  );
}
