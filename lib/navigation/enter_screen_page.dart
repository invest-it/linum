//  EnterScreenPageSettings and EnterScreenPage
//  A customized page for the EnterScreen
//
//  Author: damattl
//
//

import 'package:flutter/material.dart';
import 'package:linum/models/currency.dart';
import 'package:linum/models/transaction.dart';
import 'package:linum/providers/enter_screen_provider.dart';
import 'package:linum/screens/enter_screen.dart';
import 'package:provider/provider.dart';

class EnterScreenPageSettings {
  final bool isFromBalanceData;
  final Transaction? transaction;
  final String? category;
  final String? secondaryCategory;
  final Currency? currency;

  EnterScreenPageSettings._(
      {this.transaction, this.category, this.secondaryCategory, this.currency, this.isFromBalanceData = false,});

  factory EnterScreenPageSettings.withTransaction(Transaction transaction) {
    return EnterScreenPageSettings._(transaction: transaction, isFromBalanceData: true);
  }
  factory EnterScreenPageSettings.withSettings(
      {required Currency currency, String? category, String? secondaryCategory}) {
    return EnterScreenPageSettings._(category: category, secondaryCategory: secondaryCategory, currency: currency);
  }
}

class EnterScreenPage extends Page {
  final EnterScreenPageSettings settings;
  const EnterScreenPage(this.settings) : super();

  @override
  Route createRoute(BuildContext context) {
    final enterScreenProvider = ChangeNotifierProvider<EnterScreenProvider>(
      create: (_) {
        if (settings.isFromBalanceData) {
          return EnterScreenProvider.fromTransaction(settings.transaction!);
        } else {
          return EnterScreenProvider(
            category: settings.category ??
                "None",
            secondaryCategory: settings.secondaryCategory ??
                "None",
            currency: settings.currency!.name,
          );
        }
      },
      child: const EnterScreen(),
    );
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, animation, animation2) {
        final tween = Tween(begin: const Offset(0.0, 1.0), end: Offset.zero);
        final curveTween = CurveTween(curve: Curves.easeInOut);
        return SlideTransition(
          position: animation.drive(curveTween).drive(tween),
          child: enterScreenProvider,
        );
      },
    );
  }
  
}
